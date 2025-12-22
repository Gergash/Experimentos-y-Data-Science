--Total de ventas por año
SELECT
    DATE_PART('year', o.order_date) AS year,
    SUM(oi.quantity * oi.list_price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY year
ORDER BY year;
--Top 10 productos mas vendidos
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_units
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_units DESC
LIMIT 10;
--Relaciones de tablas madres e hijas
SELECT
    pk_t.relname AS tabla_madre,
    fk_t.relname AS tabla_hija,
    con.conname AS nombre_relacion
FROM pg_constraint con
JOIN pg_class AS fk_t ON con.conrelid = fk_t.oid
JOIN pg_class AS pk_t ON con.confrelid = pk_t.oid
WHERE con.contype = 'f'; -- 'f' significa Foreign Key
--inventario total por tienda
SELECT
    s.store_name,
    SUM(st.quantity) AS total_stock
FROM stores s
JOIN stocks st ON st.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_stock DESC;
--Crear vistas(VISUALIZADORAS)
CREATE VIEW sales_summary AS
SELECT
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name AS customer_name,
    s.store_name,
    st.first_name || ' ' || st.last_name AS staff_name,
    SUM(oi.quantity * oi.list_price) AS order_total
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN stores s ON s.store_id = o.store_id
JOIN staffs st ON st.staff_id = o.staff_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY
    o.order_id,
    c.first_name,
    c.last_name,
    s.store_name,
    st.first_name,
    st.last_name;


