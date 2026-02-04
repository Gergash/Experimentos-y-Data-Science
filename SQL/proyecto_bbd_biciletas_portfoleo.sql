CREATE TABLE products (product_id INTEGER PRIMARY KEY, product_name TEXT, brand_id, category_id, model_year, list_price NUMERIC);
CREATE TABLE products (product_id INTEGER PRIMARY KEY, product_name TEXT, brand_id NUMERIC, category_id, model_year, list_price NUMERIC);
CREATE TABLE products (product_id INTEGER PRIMARY KEY, product_name TEXT, brand_id INTEGER, category_id INTEGER, model_year INTEGER, list_price NUMERIC);
CREATE TABLE staffs (staff_id INTEGER PRIMARY KEY,first_name TEXT,last_name TEXT,email TEXT,phone NUMERIC,active NUMERIC,store_id NUMERIC,manager_id NUMERIC);
CREATE TABLE stocks (store_id INTEGER PRIMARY KEY,product_id NUMERIC,quantity NUMERIC);
CREATE TABLE stores (store_id INTEGER PRIMARY KEY,store_name TEXT,phone NUMERIC,email TEXT,street TEXT,city TEXT,state TEXT,zip_code NUMERIC);
CREATE TABLE brands (brand_id INTEGER PRIMARY KEY,brand_name TEXT); 
CREATE TABLE categories (category_id INTEGER PRIMARY KEY ,category_name TEXT);
CREATE TABLE customers (customer_id INTEGER PRIMARY KEY,first_name TEXT,last_name TEXT,phone NUMERIC,email TEXT,street TEXT,city TEXT,state TEXT,zip_code NUMERIC);
CREATE TABLE order_items (order_id INTEGER PRIMARY KEY,item_id NUMERIC,product_id NUMERIC,quantity NUMERIC,list_price FLOAT,discount FLOAT);
CREATE TABLE orders (order_id INTEGER PRIMARY KEY,customer_id NUMERIC,order_status NUMERIC,order_date DATE,required_date DATE,shipped_date DATE,store_id NUMERIC,staff_id NUMERIC);
CREATE TABLE products (product_id INTEGER PRIMARY KEY,product_name TEXT,brand_id INTEGER,category_id INTEGER,model_year INTEGER,list_price FLOAT);
CREATE TABLE stocks (store_id INTEGER PRIMARY KEY,product_id NUMERIC,quantity NUMERIC);
CREATE TABLE stores (store_id INTEGER PRIMARY KEY,store_name TEXT,phone NUMERIC,email TEXT,street TEXT,city TEXT,state TEXT,zip_code NUMERIC);
CREATE TABLE brands (brand_id INTEGER PRIMARY KEY,brand_name TEXT); 
CREATE TABLE categories (category_id INTEGER PRIMARY KEY ,category_name TEXT);
CREATE TABLE customers (customer_id INTEGER PRIMARY KEY,first_name TEXT,last_name TEXT,phone NUMERIC,email TEXT,street TEXT,city TEXT,state TEXT,zip_code NUMERIC);
CREATE TABLE order_items (order_id INTEGER PRIMARY KEY,item_id NUMERIC,product_id NUMERIC,quantity NUMERIC,list_price FLOAT,discount FLOAT);
CREATE TABLE orders (order_id INTEGER PRIMARY KEY,customer_id NUMERIC,order_status NUMERIC,order_date DATE,required_date DATE,shipped_date DATE,store_id NUMERIC,staff_id NUMERIC);
CREATE TABLE products (product_id INTEGER PRIMARY KEY,product_name TEXT,brand_id INTEGER,category_id INTEGER,model_year INTEGER,list_price FLOAT);
ALTER TABLE products ADD CONSTRAINT fk_brand FOREIGN KEY (brand_id) REFERENCES brands(brand_id);
ALTER TABLE products ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(category_id);
ALTER TABLE orders ADD CONSTRAINT fk_customer FOREIGN KEY (costumer_id) REFERENCES customers(customer_id);
ALTER TABLE orders ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id);
ALTER TABLE orders ADD CONSTRAINT fk_staff FOREIGN KEY (staff_id) REFERENCES staffs(staff_id);
ALTER TABLE order_items ADD CONSTRAINT fk_order_items FOREIGN KEY (order_id) REFERENCES orders(order_id);
ALTER TABLE order_items ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE staffs ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id);
ALTER TABLE staffs ADD CONSTRAINT fk_manager FOREIGN KEY (staff_id) REFERENCES staffs(staff_id);
ALTER TABLE stocks ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id);
ALTER TABLE stocks ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE orders ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE orders ALTER COLUMN store_id TYPE INTEGER USING store_id::INTEGER;
ALTER TABLE orders ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id);
ALTER TABLE orders ALTER COLUMN staff_id TYPE INTEGER USING staff_id::INTEGER;
ALTER TABLE orders ADD CONSTRAINT fk_staff FOREIGN KEY (staff_id) REFERENCES staffs(staff_id);
ALTER TABLE orders_items ALTER COLUMN product_id TYPE INTEGER USING product_id::INTEGER;
ALTER TABLE order_items ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE staffs ALTER COLUMN store_id TYPE INTEGER USING store_id::INTEGER;
ALTER TABLE staffs ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id);
ALTER TABLE stocks ALTER COLUMN product_id TYPE INTEGER USING product_id::INTEGER;
ALTER TABLE stocks ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id);
ALTER TABLE orders ALTER COLUMN customer_id TYPE INTEGER USING customer_id::INTEGER;
ALTER TABLE orders ADD CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE order_items ALTER COLUMN product_id TYPE INTEGER USING product_id::INTEGER;
ALTER TABLE order_items ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id);
COPY brands FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/brands.csv' DELIMITER ',' CSV HEADER;
SELECT brand_name FROM brands;
COPY categories FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/categories.csv' DELIMITER ',' CSV HEADER;
COPY products FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/products.csv' DELIMITER ',' CSV HEADER;
COPY stocks FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stocks.csv' DELIMITER ',' CSV HEADER;
COPY stores FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stores.csv' DELIMITER ',' CSV HEADER;
COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' DELIMITER ',' CSV HEADER;
COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' DELIMITER ',' CSV HEADER;
ALTER TABLE stocks DROP CONSTRAINT stocks_pkey;
ALTER TABLE stocks ADD PRIMARY KEY (store_id, product_id);
--COPY stocks FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stocks.csv' DELIMITER ',' CSV HEADER;
--COPY stores FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stores.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' DELIMITER ',' CSV HEADER;
--COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' DELIMITER ',' CSV HEADER;
COPY stocks FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stocks.csv' DELIMITER ',' CSV HEADER;
--COPY stores FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stores.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' DELIMITER ',' CSV HEADER;
--COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' DELIMITER ',' CSV HEADER;
COPY stores FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stores.csv' DELIMITER ',' CSV HEADER;
COPY stocks FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stocks.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' DELIMITER ',' CSV HEADER;
--COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' DELIMITER ',' CSV HEADER;
ALTER TABLE stores ALTER COLUMN phone TYPE VARCHAR USING phone::VARCHAR;

--COPY stores FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stores.csv' DELIMITER ',' CSV HEADER;
--COPY stocks FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stocks.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' DELIMITER ',' CSV HEADER;
--COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' DELIMITER ',' CSV HEADER;
COPY stores FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stores.csv' DELIMITER ',' CSV HEADER;
COPY stocks FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/stocks.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
--COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' DELIMITER ',' CSV HEADER;
--COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' DELIMITER ',' CSV HEADER;
COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
COPY staff FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' DELIMITER ',' CSV HEADER;
COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' DELIMITER ',' CSV HEADER;
COPY staffs FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv'  DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
ALTER TABLE staffs ALTER COLUMN phone TYPE VARCHAR USING phone::VARCHAR;
COPY staffs FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv'  DELIMITER ',' CSV HEADER;
--COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
--COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
COPY staffs FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv'  WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
--COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
--COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
COPY staffs FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/staffs.csv'  WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' WITH (FORMAT CSV, NULL 'NULL', DELIMITER ',');
COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
ALTER TABLE customers ALTER COLUMN phone TYPE INTEGER USING phone::VARCHAR;
COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
ALTER TABLE customers ALTER COLUMN phone TYPE VARCHAR USING phone::VARCHAR;
COPY customers FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/customers.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
COPY orders FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/orders.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
SELECT
    DATE_PART('year', o.order_date) AS year,
    SUM(oi.quantity * oi.list_price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY year
ORDER BY year;
SELECT DATE_PART('year', o.order_date) AS year, SUM(oi.quantity * oi.list_price) AS revenue FROM orders o JOIN order_items oi ON oi.order_id = o.order_id GROUP BY year ORDER BY year;
SELECT DATE_PART('year', o.order_date) AS year, SUM(oi.quantity * oi.list_price) AS revenue FROM orders o JOIN order_items oi ON oi.order_id = o.order_id GROUP BY year ORDER BY year;
--SELECT DATE_PART('year', o.order_date) AS year, SUM(oi.quantity * oi.list_price) AS revenue FROM orders o JOIN order_items oi ON oi.order_id = o.order_id GROUP BY year ORDER BY year;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
--SELECT DATE_PART('year', o.order_date) AS year, SUM(oi.quantity * oi.list_price) AS revenue FROM orders o JOIN order_items oi ON oi.order_id = o.order_id GROUP BY year ORDER BY year;
--SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
COPY order_items FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/order_items.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
TRUNCATE TABLE order_items RESTART IDENTITY CASCADE;
COPY order_items FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/order_items.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
-- (El nombre suele ser 'order_items_pkey' según tu error previo)
ALTER TABLE order_items DROP CONSTRAINT order_items_pkey;
-- 2. Crear la Llave Primaria Compuesta correcta
ALTER TABLE order_items ADD PRIMARY KEY (order_id, item_id);
-- 3. Limpiar la tabla por si acaso quedó algo
TRUNCATE TABLE order_items;
-- 4. Ejecutar el COPY de nuevo
COPY order_items FROM 'C:/Users/57317/Desktop/Portafoleo_Data_Science/Experimentos-y-Data-Science/SQL/order_items.csv' WITH (FORMAT CSV, HEADER true, NULL 'NULL', DELIMITER ',');
SELECT COUNT(*) FROM order_items;
SELECT
    DATE_PART('year', o.order_date) AS year,
    SUM(oi.quantity * oi.list_price) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY year
ORDER BY year;
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
--Relaciones de tablas
SELECT
    pk_t.relname AS tabla_madre,
    fk_t.relname AS tabla_hija,
    con.conname AS nombre_relacion
FROM pg_constraint con
JOIN pg_class AS fk_t ON con.conrelid = fk_t.oid
JOIN pg_class AS pk_t ON con.confrelid = pk_t.oid
WHERE con.contype = 'f'; -- 'f' significa Foreign Key

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
--Indices de rendimiento
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_stocks_product ON stocks(product_id);

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
--Indices de rendimiento
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_stocks_product ON stocks(product_id);
--KPI crecimiento de ventas anual
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
        ((curr.total_sales - prev.total_sales) / prev.total_sales) * 100,
        2
    ) AS growth_percentage,
    CASE
        WHEN curr.total_sales > prev.total_sales THEN 'CRECIMIENTO'
        ELSE 'DISMINUCIÓN'
    END AS status
FROM ranked_sales curr
JOIN ranked_sales prev
    ON curr.rn = 1 AND prev.rn = 2;
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
        ((curr.total_sales - prev.total_sales) / prev.total_sales) * 100,
        2
    ) AS growth_percentage,
    CASE
        WHEN curr.total_sales > prev.total_sales THEN 'CRECIMIENTO'
        ELSE 'DISMINUCIÓN'
    END AS status
FROM ranked_sales curr
JOIN ranked_sales prev
    ON curr.rn = 1 AND prev.rn = 2;

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

SELECT * FROM yearly_sales;

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
        ((curr.total_sales - prev.total_sales) / prev.total_sales) * 100,
        2
    ) AS growth_percentage,
    CASE
        WHEN curr.total_sales > prev.total_sales THEN 'CRECIMIENTO'
        ELSE 'DISMINUCIÓN'
    END AS status
FROM ranked_sales curr
JOIN ranked_sales prev
    ON curr.rn = 1 AND prev.rn = 2;
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
        (((curr.total_sales - prev.total_sales) / prev.total_sales)) * 100)::NUMERIC,
        2
    ) AS growth_percentage,
    CASE
        WHEN curr.total_sales > prev.total_sales THEN 'CRECIMIENTO'
        ELSE 'DISMINUCIÓN'
    END AS status
FROM ranked_sales curr
JOIN ranked_sales prev
    ON curr.rn = 1 AND prev.rn = 2;


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


--Total de ventas por a�o
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
        ELSE 'DISMINUCI�N'
    END AS status
FROM ranked_sales curr
JOIN ranked_sales prev
    ON curr.rn = 1 AND prev.rn = 2;



