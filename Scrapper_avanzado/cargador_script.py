import pandas as pd
import gspread
from oauth2client.service_account import ServiceAccountCredentials
import os
# Importamos la función del otro archivo
from reporting_script import ejecutar_extraccion_completa 


# --- CONFIGURACIÓN ---
FILE_JSON_CREDS = 'credenciales.json'
SHEET_NAME = 'Dashboard_PowerUps_Data'
FILE_IG = 'reporte_maestro_powerups_FINAL.csv'
FILE_FB = 'reporte_maestro_facebook.csv'

def _col(df, nombre, alternativas=None, default=0):
    """Obtiene una columna del DataFrame si existe; si no, crea una serie con default (tolerante a fallos)."""
    alternativas = alternativas or []
    for cand in [nombre] + alternativas:
        if cand in df.columns:
            return df[cand]
    return pd.Series([default] * len(df), index=df.index)

def preparar_datos_consolidados(df_ig, df_fb):
    """Une los datos de IG y FB con todas las métricas solicitadas. Tolerante a columnas faltantes."""
    print("Consolidando métricas detalladas...")
    
    columnas_finales = [
        'Fecha', 'Hora', 'Alcance', 'Visualizaciones', 'Me gusta', 'Comentarios',
        'Veces que se compartió', 'Veces que se guardó', 'Tipo de publicación', 'Enlace', 'Plataforma', 'Segundos reproducidos'
    ]

    # --- ESTANDARIZAR INSTAGRAM (mapeo robusto: si no existe la columna, se usa 0) ---
    df_ig_clean = pd.DataFrame(index=df_ig.index)
    df_ig_clean['Fecha'] = _col(df_ig, 'Fecha')
    df_ig_clean['Hora'] = _col(df_ig, 'Hora de publicación', ['Hora'], '00:00:00')
    df_ig_clean['Alcance'] = _col(df_ig, 'Alcance', default=0)
    df_ig_clean['Visualizaciones'] = _col(df_ig, 'Visualizaciones', default=0)
    df_ig_clean['Me gusta'] = _col(df_ig, 'Me gusta', default=0)
    df_ig_clean['Comentarios'] = _col(df_ig, 'Comentarios', default=0)
    df_ig_clean['Veces que se compartió'] = _col(df_ig, 'Veces que se compartió', default=0)
    df_ig_clean['Veces que se guardó'] = _col(df_ig, 'Veces que se guardó', default=0)
    df_ig_clean['Tipo de publicación'] = _col(df_ig, 'Tipo de publicación', default='')
    df_ig_clean['Enlace'] = _col(df_ig, 'Enlace permanente', ['Enlace permanente (IG)', 'Enlace'], default='')
    df_ig_clean['Plataforma'] = 'Instagram'
    # Segundos reproducidos: usar columna existente; solo 0 si falta (no sobreescribir valores del extractor)
    df_ig_clean['Segundos reproducidos'] = _col(df_ig, 'Segundos reproducidos', default=0)

    # --- ESTANDARIZAR FACEBOOK (Reacciones → Me gusta; Enlace unificado) ---
    df_fb_clean = pd.DataFrame(index=df_fb.index)
    df_fb_clean['Fecha'] = _col(df_fb, 'Fecha')
    df_fb_clean['Hora'] = _col(df_fb, 'Hora', default='00:00:00')
    df_fb_clean['Alcance'] = _col(df_fb, 'Alcance', default=0)
    df_fb_clean['Visualizaciones'] = _col(df_fb, 'Visualizaciones', ['Total de clics'], default=0)
    df_fb_clean['Me gusta'] = _col(df_fb, 'Reacciones', ['Reacciones (FB)'], default=0)
    df_fb_clean['Comentarios'] = _col(df_fb, 'Comentarios', default=0)
    df_fb_clean['Veces que se compartió'] = _col(df_fb, 'Veces que se compartió', default=0)
    df_fb_clean['Veces que se guardó'] = 0
    df_fb_clean['Tipo de publicación'] = 'Post/Video'
    df_fb_clean['Enlace'] = _col(df_fb, 'Enlace', ['Enlace (FB)'], default='')
    df_fb_clean['Plataforma'] = 'Facebook'
    df_fb_clean['Segundos reproducidos'] = _col(df_fb, 'Segundos reproducidos', default=0)

    # --- UNIFICAR ---
    df_final = pd.concat([df_ig_clean, df_fb_clean], ignore_index=True)
    df_final = df_final[columnas_finales]
    df_final['Fecha'] = pd.to_datetime(df_final['Fecha'], errors='coerce')
    df_final = df_final.sort_values(by='Fecha', ascending=False)
    # Convertir métricas numéricas a float (Power BI debe poder sumar; no formatear como texto)
    cols_numericas = ['Alcance', 'Visualizaciones', 'Me gusta', 'Comentarios', 'Veces que se compartió', 'Veces que se guardó', 'Segundos reproducidos']
    for col in cols_numericas:
        if col in df_final.columns:
            s = pd.to_numeric(df_final[col], errors='coerce')
            df_final[col] = s.fillna(0).astype(float)
    return df_final

def subir_a_google_sheets(df):
    """Realiza la conexión y carga a la nube."""
    try:
        # Ordenar por Fecha descendente antes de subir
        df['Fecha'] = pd.to_datetime(df['Fecha'], errors='coerce')
        df = df.sort_values(by='Fecha', ascending=False)
        # Limpieza: nulos → 0; métricas siempre numéricas (float) para que Power BI sume y no las trate como texto
        df = df.fillna(0)
        df = df.replace('N/A', 0)
        cols_num = ['Alcance', 'Visualizaciones', 'Me gusta', 'Comentarios', 'Veces que se compartió', 'Veces que se guardó', 'Segundos reproducidos']
        for c in cols_num:
            if c in df.columns:
                df[c] = pd.to_numeric(df[c], errors='coerce').fillna(0).astype(float)
        # Asegurar que Segundos reproducidos sea float (evitar que Sheets/Power BI lo interprete como texto)
        if 'Segundos reproducidos' in df.columns:
            df['Segundos reproducidos'] = df['Segundos reproducidos'].astype(float)
        scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/drive"]
        creds = ServiceAccountCredentials.from_json_keyfile_name(FILE_JSON_CREDS, scope)
        client = gspread.authorize(creds)
        sheet = client.open(SHEET_NAME).sheet1
        df['Fecha'] = pd.to_datetime(df['Fecha'], errors='coerce').dt.strftime('%Y-%m-%d')
        # Enviar números como float (no strings) para que Google Sheets y Power BI los traten como numéricos
        datos_a_subir = [df.columns.values.tolist()] + df.values.tolist()
        # Limpiar y actualizar
        sheet.clear()
        sheet.update(datos_a_subir)
        
        print(f"¡Éxito! {len(df)} registros subidos a '{SHEET_NAME}'.")
        print("Ahora puedes darle a 'Actualizar' en Power BI.")
    except Exception as e:
        print(f"Error en la carga de google sheets: {e}")


def flujo_principal():
    print("Iniciando proceso de Reporting PowerUps...")
    # LLAMADA AL REPORTERO: Aquí es donde se conectan
    df_ig, df_fb = ejecutar_extraccion_completa()

    if not df_ig.empty or not df_fb.empty:
        # 2. CONSOLIDACIÓN (TRANSFORMACIÓN)
        df_consolidado = preparar_datos_consolidados(df_ig, df_fb)
        # 3. CARGA A GOOGLE SHEETS
        subir_a_google_sheets(df_consolidado)
        print("Datos recibidos. Iniciando carga a Google Sheets...")
        print("PROCESO DE CARGA FINALIZADO")

    else:
        print("No hay datos nuevos para cargar, Revisa el Token de meta y revisa el ID de la cuenta.")

# --- EJECUCIÓN ---
if __name__ == "__main__":
    flujo_principal()
