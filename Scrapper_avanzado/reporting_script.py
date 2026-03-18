import requests
import pandas as pd
import time
from datetime import datetime, timedelta

# --- CONFIGURACIÓN ---
# Pausa entre publicaciones para no saturar la API durante extracción de 12 meses
PAUSA_ENTRE_POSTS = 0.5
# Asegúrate de usar el Token de Página que te funcionó en el explorador
ACCESS_TOKEN = 'EAANNyZBoAJMwBQi3clv0VXRtgAZATCn1GAU1DKPOk6MwDbdZAkkfZCr2IW6WQXPk60DJrGGpsEiy3hRz0DcjAQCWp2BMjJd2wzqB84birAS4ZCmQoQBAoT4L87grO6QwfcPBfxoDWEApsvIT3i9ZCc81OtMiyinZCGB9OLdOflO0QksXz7u4b9ELSBPZCBEUgtwbh2WF8CrWBwZDZD' 
ACCESS_TOKEN_FB = 'EAANNyZBoAJMwBQh21RYZC2tOO281iZA2ZB2lG3VitZCZBLkudGqNsM4RGDiHk0LeiU0tUkR1jEzJryHN58g4ZBJsaOdrh5LHeHBObYsCZAYBOTPauGojpJFRRHf8m5ZBzDNiDI8Ka3LZCtgQWgGcYPM99FodvjtGlH6sfaY3FCD0sTZCP7Vb1mrnXov52ydakHaWs7ZCxjZBCoi7mcqK6VruD8wSbpwZDZD'
# El ID que ya sabemos que funciona
IG_USER_ID = '17841400776254025' 
FB_PAGE_ID = '314141662423369'

# Límite para histórico: 12 meses
DIAS_HISTORICO = 365

def obtener_valor(json_data, nombre_metrica):
    """Extrae de forma segura el valor de la métrica desde la estructura de Meta."""
    if 'data' in json_data: 
        for m in json_data['data']:
            if m['name'] == nombre_metrica:
                try:
                    return m['values'][0]['value']
                except (IndexError, KeyError):
                    return 0
    return 0

def extraer_reporte_maestro_total():
    print(f"Iniciando extracción de doble vía para: {IG_USER_ID} (histórico {DIAS_HISTORICO} días)...")
    
    fields = "id,caption,media_type,media_product_type,permalink,timestamp,username,like_count,comments_count,duration"
    url_media = f"https://graph.facebook.com/v24.0/{IG_USER_ID}/media?fields={fields}&access_token={ACCESS_TOKEN}"
    limite_fecha = datetime.utcnow() - timedelta(days=DIAS_HISTORICO)
    resultados = []

    try:
        pagina = 0
        while url_media:
            pagina += 1
            res_json = requests.get(url_media).json()
            time.sleep(PAUSA_ENTRE_POSTS)

            if 'error' in res_json:
                print(f"Error de Meta: {res_json['error'].get('message')}")
                break

            posts = res_json.get('data', [])
            if not posts:
                print("No hay más publicaciones en esta página.")
                break

            print(f"Procesando página {pagina} ({len(posts)} publicaciones)...")
            alcanzo_limite_historico = False

            for post in posts:
                fecha_dt = pd.to_datetime(post.get('timestamp'))
                if fecha_dt.to_pydatetime().replace(tzinfo=None) < limite_fecha:
                    alcanzo_limite_historico = True

                p_id = post['id']
                tipo = post.get('media_product_type', '') or 'IMAGE'

                # Métricas por tipo (nombres exactos aceptados por la API; sin espacios ni caracteres extra)
                if tipo == 'REELS':
                    metricas = "plays,ig_reels_video_view_total_time,ig_reels_avg_watch_time,reach,shares,saved,total_interactions"
                else:
                    metricas = "impressions,reach,saved"

                url_insights = f"https://graph.facebook.com/v24.0/{p_id}/insights?metric={metricas}&period=lifetime&access_token={ACCESS_TOKEN}"
                res_insights = requests.get(url_insights).json()
                time.sleep(PAUSA_ENTRE_POSTS)

                alcance_real = obtener_valor(res_insights, 'reach')
                guardados = obtener_valor(res_insights, 'saved')
                compartidos = obtener_valor(res_insights, 'shares') if tipo == 'REELS' else 0
                seguimientos = obtener_valor(res_insights, 'total_interactions') if tipo == 'REELS' else 0

                if tipo == 'REELS':
                    visualizaciones = obtener_valor(res_insights, 'plays')
                    total_time_ms = obtener_valor(res_insights, 'ig_reels_video_view_total_time')
                    avg_watch_ms = obtener_valor(res_insights, 'ig_reels_avg_watch_time')

                    # 1) Tiempo total directo desde insights (ms → segundos)
                    if total_time_ms:
                        segundos_reproducidos = float(total_time_ms) / 1000.0
                    else:
                        # 2) Cálculo derivado: (ig_reels_avg_watch_time / 1000.0) * plays
                        if avg_watch_ms and visualizaciones:
                            segundos_reproducidos = (float(avg_watch_ms) / 1000.0) * float(visualizaciones)
                            print(f"-> Calculando tiempo derivado para Reel {p_id}")
                        else:
                            segundos_reproducidos = 0.0

                    # 3) Fallback final: duration del objeto raíz (API devuelve milisegundos → segundos). Preferir duración del video a 0.
                    if segundos_reproducidos == 0.0:
                        duracion_ms = post.get('duration')
                        if duracion_ms is not None and duracion_ms != 0:
                            try:
                                segundos_reproducidos = float(duracion_ms) / 1000.0
                                print(f"-> Usando duration del media para Reel {p_id}")
                            except (TypeError, ValueError):
                                pass

                    # 4) Si media_type es VIDEO y seguimos en 0: petición al nodo de video (GET media por ID con fields=duration)
                    if segundos_reproducidos == 0.0 and post.get('media_type') == 'VIDEO':
                        try:
                            url_video = f"https://graph.facebook.com/v24.0/{p_id}?fields=duration&access_token={ACCESS_TOKEN}"
                            res_video = requests.get(url_video).json()
                            time.sleep(PAUSA_ENTRE_POSTS)
                            if 'duration' in res_video and res_video.get('duration') is not None:
                                dur_ms = float(res_video['duration'])
                                segundos_reproducidos = dur_ms / 1000.0
                                print(f"-> Usando duration del nodo video para Reel {p_id}")
                        except (KeyError, TypeError, ValueError):
                            pass

                    # Segunda llamada exclusiva si la consulta unificada devolvió 0
                    if alcance_real == 0:
                        r = requests.get(f"https://graph.facebook.com/v24.0/{p_id}/insights?metric=reach&period=lifetime&access_token={ACCESS_TOKEN}").json()
                        alcance_real = obtener_valor(r, 'reach')
                        time.sleep(PAUSA_ENTRE_POSTS)
                    if visualizaciones == 0 or (not total_time_ms and not avg_watch_ms):
                        r2_metricas = "plays,ig_reels_video_view_total_time,ig_reels_avg_watch_time"
                        r2 = requests.get(f"https://graph.facebook.com/v24.0/{p_id}/insights?metric={r2_metricas}&period=lifetime&access_token={ACCESS_TOKEN}").json()
                        if visualizaciones == 0:
                            visualizaciones = obtener_valor(r2, 'plays')
                        if segundos_reproducidos == 0.0:
                            tm = obtener_valor(r2, 'ig_reels_video_view_total_time')
                            if tm:
                                segundos_reproducidos = float(tm) / 1000.0
                            else:
                                av = obtener_valor(r2, 'ig_reels_avg_watch_time')
                                pl = obtener_valor(r2, 'plays') or visualizaciones
                                if av and pl:
                                    segundos_reproducidos = (float(av) / 1000.0) * float(pl)
                                    print(f"-> Calculando tiempo derivado para Reel {p_id}")
                            if segundos_reproducidos == 0.0:
                                duracion_ms = post.get('duration')
                                if duracion_ms is not None and duracion_ms != 0:
                                    try:
                                        segundos_reproducidos = float(duracion_ms) / 1000.0
                                        print(f"-> Usando duration del media para Reel {p_id}")
                                    except (TypeError, ValueError):
                                        pass
                        time.sleep(PAUSA_ENTRE_POSTS)
                else:
                    visualizaciones = obtener_valor(res_insights, 'impressions')
                    segundos_reproducidos = 0.0
                    if alcance_real == 0 or visualizaciones == 0:
                        r = requests.get(f"https://graph.facebook.com/v24.0/{p_id}/insights?metric=reach,impressions&period=lifetime&access_token={ACCESS_TOKEN}").json()
                        if alcance_real == 0:
                            alcance_real = obtener_valor(r, 'reach')
                        if visualizaciones == 0:
                            visualizaciones = obtener_valor(r, 'impressions')
                        time.sleep(PAUSA_ENTRE_POSTS)

                item = {
                    'Identificador de la publicación': p_id,
                    'Identificador de la cuenta': IG_USER_ID,
                    'Nombre de usuario de la cuenta': post.get('username'),
                    'Nombre de la cuenta': 'Juan Camilo Velez Londoño',
                    'Descripción': post.get('caption', 'Sin descripción'),
                    'Duración (segundos)': 'N/A', 
                    'Hora de publicación': fecha_dt.strftime('%H:%M:%S'),
                    'Fecha': fecha_dt.strftime('%Y-%m-%d'),
                    'Enlace permanente': post.get('permalink'),
                    'Tipo de publicación': tipo,
                    'Comentario sobre los datos': 'Extracción de Doble Vía PowerUps',
                    'Visualizaciones': visualizaciones,
                    'Alcance': alcance_real,
                    'Me gusta': post.get('like_count', 0),
                    'Veces que se compartió': compartidos,
                    'Seguimientos': seguimientos,
                    'Comentarios': post.get('comments_count', 0),
                    'Veces que se guardó': guardados,
                    'Segundos reproducidos': segundos_reproducidos,
                }
                resultados.append(item)
                print(f"-> {item['Fecha']} | Alcance: {alcance_real} | Likes: {item['Me gusta']} | Seg: {segundos_reproducidos}")
                time.sleep(PAUSA_ENTRE_POSTS)

            paging = res_json.get('paging', {})
            url_media = paging.get('next')
            if alcanzo_limite_historico or not url_media:
                if alcanzo_limite_historico:
                    print(f"Alcanzado histórico de {DIAS_HISTORICO} días. Finalizando paginación.")
                break

        if not resultados:
            print("No se encontraron publicaciones.")
            return pd.DataFrame()

        df = pd.DataFrame(resultados)
        df.to_csv('reporte_maestro_powerups_FINAL.csv', index=False, encoding='utf-8-sig')
        print(f"\n¡Misión cumplida! {len(resultados)} publicaciones. Archivo generado con éxito.")
        return df

    except Exception as e:
        print(f"Error crítico: {e}")
        return pd.DataFrame()

#--------------------------------------------------------------------------------------------------Facebook

def extraer_facebook_definitivo():
    print(f"Iniciando extracción de Facebook para la página: {FB_PAGE_ID} (histórico {DIAS_HISTORICO} días)...")
    
    url_posts = f"https://graph.facebook.com/v24.0/{FB_PAGE_ID}/posts?fields=id,message,created_time,shares,permalink_url&access_token={ACCESS_TOKEN_FB}"
    limite_fecha = datetime.utcnow() - timedelta(days=DIAS_HISTORICO)
    resultados_fb = []

    try:
        pagina = 0
        while url_posts:
            pagina += 1
            response = requests.get(url_posts)
            res_json = response.json()
            time.sleep(PAUSA_ENTRE_POSTS)

            if 'error' in res_json:
                print(f"Error de Meta: {res_json['error'].get('message')}")
                break

            posts = res_json.get('data', [])
            if not posts:
                print("No hay más publicaciones en esta página.")
                break

            print(f"Procesando página FB {pagina} ({len(posts)} publicaciones)...")
            alcanzo_limite_historico = False

            for post in posts:
                fecha_dt = pd.to_datetime(post.get('created_time'))
                if fecha_dt.to_pydatetime().replace(tzinfo=None) < limite_fecha:
                    alcanzo_limite_historico = True

                p_id = post['id']
                metrics = "post_impressions_unique,post_clicks_by_type,post_reactions_by_type_total"
                url_ins = f"https://graph.facebook.com/v24.0/{p_id}/insights?metric={metrics}&access_token={ACCESS_TOKEN_FB}"
                ins_res = requests.get(url_ins).json()
                time.sleep(PAUSA_ENTRE_POSTS)

                m_data = {'alcance': 0, 'clics_totales': 0, 'reacciones': 0}
                if 'data' in ins_res:
                    for m in ins_res['data']:
                        nombre = m['name']
                        try:
                            valor = m['values'][0]['value']
                            if nombre == 'post_impressions_unique': m_data['alcance'] = valor
                            if nombre == 'post_clicks_by_type': m_data['clics_totales'] = sum(valor.values())
                            if nombre == 'post_reactions_by_type_total': m_data['reacciones'] = sum(valor.values())
                        except: continue

                # Si alcance es 0, segunda llamada exclusiva para post_impressions_unique (historial antiguo)
                if m_data['alcance'] == 0:
                    r_alcance = requests.get(f"https://graph.facebook.com/v24.0/{p_id}/insights?metric=post_impressions_unique&access_token={ACCESS_TOKEN_FB}").json()
                    if 'data' in r_alcance and r_alcance['data']:
                        try:
                            m_data['alcance'] = r_alcance['data'][0]['values'][0]['value']
                        except (IndexError, KeyError):
                            pass
                    time.sleep(PAUSA_ENTRE_POSTS)

                item = {
                    'Identificador': p_id,
                    'Fecha': fecha_dt.strftime('%Y-%m-%d'),
                    'Hora': fecha_dt.strftime('%H:%M:%S'),
                    'Descripción': post.get('message', 'Sin descripción')[:100],
                    'Alcance': m_data['alcance'],
                    'Reacciones': m_data['reacciones'],
                    'Comentarios': 0,
                    'Segundos reproducidos': 0,
                    'Visualizaciones': m_data['clics_totales'],
                    'Veces que se compartió': post.get('shares', {}).get('count', 0),
                    'Total de clics': m_data['clics_totales'],
                    'Enlace': post.get('permalink_url')
                }
                resultados_fb.append(item)
                print(f"OK -> {item['Fecha']} | Alcance: {item['Alcance']}")
                time.sleep(PAUSA_ENTRE_POSTS)

            paging = res_json.get('paging', {})
            url_posts = paging.get('next')
            if alcanzo_limite_historico or not url_posts:
                if alcanzo_limite_historico:
                    print(f"Alcanzado histórico de {DIAS_HISTORICO} días. Finalizando paginación FB.")
                break

        if not resultados_fb:
            print("Conexión exitosa, pero no se encontraron publicaciones en esta página.")
            return pd.DataFrame()

        df = pd.DataFrame(resultados_fb)
        df.to_csv('reporte_maestro_facebook.csv', index=False, encoding='utf-8-sig')
        print(f"\n¡Éxito! Archivo generado con {len(resultados_fb)} filas.")
        return df

    except Exception as e:
        print(f"Error inesperado: {e}")
        return pd.DataFrame()


# ... (Todo tu código anterior de Instagram y Facebook se mantiene igual) ...

def ejecutar_extraccion_completa():
    """Función maestra que orquesta ambas extracciones y devuelve los DataFrames."""
    print("--- INICIANDO EXTRACCIÓN GLOBAL DE META ---")
    # Ejecutamos Instagram
    df_ig = extraer_reporte_maestro_total()
    # Ejecutamos Facebook
    df_fb = extraer_facebook_definitivo()
    print("--- EXTRACCIÓN FINALIZADA ---")
    return df_ig, df_fb

# Eliminamos las llamadas directas al final para que no se ejecute dos veces 
# al ser importado por el cargador.