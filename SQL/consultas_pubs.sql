 SELECT COUNT(*) AS Empleados FROM employee;   -- debe dar 43
 SELECT COUNT(*) AS Autores   FROM authors;    -- debe dar 23
 SELECT COUNT(*) AS Titulos   FROM titles;     -- debe dar 18

USE pubs;
GO

/* ============================================================
   Consulta #1
   Empleados con más de 10 años de antigüedad,
   ordenados por fecha de contratación ascendente.
   ============================================================ */
SELECT
    fname                                   AS Nombre,
    minit                                   AS Inicial,
    lname                                   AS Apellido,
    hire_date                               AS FechaContratacion,
    DATEDIFF(YEAR, hire_date, GETDATE())    AS AñosAntiguedad
FROM employee
WHERE DATEDIFF(YEAR, hire_date, GETDATE()) > 10
ORDER BY hire_date ASC;

GO

/* ============================================================
   Consulta #2
   Tiendas con más de 2 pedidos realizados,
   junto con el total de pedidos.
   ============================================================ */
SELECT
    s.stor_name         AS NombreTienda,
    COUNT(sa.ord_num)   AS TotalPedidos
FROM stores s
INNER JOIN sales sa ON s.stor_id = sa.stor_id
GROUP BY s.stor_name
HAVING COUNT(sa.ord_num) > 2
ORDER BY TotalPedidos DESC;

GO

/* ============================================================
   Consulta #3
   Top 10 libros más vendidos, con categoría y editorial,
   ordenados por total de ventas descendente.
   Utiliza cláusula WITH (CTE).
   ============================================================ */
WITH LibrosVentas AS (
    SELECT
        t.title         AS Titulo,
        t.type          AS Categoria,
        p.pub_name      AS Editorial,
        t.ytd_sales     AS TotalVentas
    FROM titles t
    INNER JOIN publishers p ON t.pub_id = p.pub_id
    WHERE t.ytd_sales IS NOT NULL
)
SELECT TOP 10
    Titulo,
    Categoria,
    Editorial,
    TotalVentas
FROM LibrosVentas
ORDER BY TotalVentas DESC;

GO
