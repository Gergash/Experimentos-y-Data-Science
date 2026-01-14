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
/*
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
    */
--Indices de rendimiento
/*
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_stocks_product ON stocks(product_id);
*/
--KPI crecimiento de ventas anual
CREATE OR REPLACE VIEW yearly_sales AS
SELECT
    DATE_PART('year', o.order_date) AS year,
    SUM(oi.quantity * oi.list_price) AS total_sales
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY year
ORDER BY year;
SELECT * FROM yearly_sales;
-- KPI VERSION ESCALABLE (AUTOMATICA)
CREATE OR REPLACE VIEW kpi_sales_latest_yoy AS
WITH ranked_sales AS (
    SELECT
        year,
        total_sales,
        ROW_NUMBER() OVER (ORDER BY year DESC) AS rn
    FROM yearly_sales
)
SELECT
    curr.year AS current_year,
    prev.year AS previous_year,
    curr.total_sales AS current_sales,
    prev.total_sales AS previous_sales,
    curr.total_sales - prev.total_sales AS difference,
    ROUND(
        (((curr.total_sales - prev.total_sales) / prev.total_sales) * 100)::NUMERIC,
        2
    ) AS growth_percentage,
    CASE
        WHEN curr.total_sales > prev.total_sales THEN 'CRECIMIENTO'
        ELSE 'DISMINUCIÓN'
    END AS status
FROM ranked_sales curr
JOIN ranked_sales prev
    ON curr.rn = 1 AND prev.rn = 2;



