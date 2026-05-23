-- ============================================================
-- PROYECTO SEMANA 02 — MercaData: Respondiendo preguntas
--                      de negocio con SQL
-- ============================================================
-- Instrucciones:
--   1. Ejecuta la Parte 1 COMPLETA para preparar el entorno.
--   2. Luego resuelve cada pregunta en la Parte 2.
--   3. Cada TODO indica qué consulta debes escribir.
--   4. Agrega un comentario explicando la lógica de tu consulta.
-- ============================================================


-- ============================================================
-- PARTE 1: PREPARAR EL ENTORNO (ya está hecho — solo ejecútalo)
-- ============================================================

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders      CASCADE;
DROP TABLE IF EXISTS products    CASCADE;
DROP TABLE IF EXISTS categories  CASCADE;
DROP TABLE IF EXISTS customers   CASCADE;

-- Categorías de productos
CREATE TABLE categories (
    category_id   UUID         DEFAULT gen_random_uuid() PRIMARY KEY,
    category_name VARCHAR(80)  NOT NULL UNIQUE
);

-- Catálogo de productos
CREATE TABLE products (
    product_id    UUID          DEFAULT gen_random_uuid() PRIMARY KEY,
    product_name  VARCHAR(150)  NOT NULL,
    category_id   UUID          NOT NULL REFERENCES categories(category_id),
    product_price NUMERIC(10,2) NOT NULL CHECK (product_price >= 0),
    product_stock INTEGER       NOT NULL DEFAULT 0 CHECK (product_stock >= 0)
);

-- Clientes registrados
CREATE TABLE customers (
    customer_id      UUID         DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_name    VARCHAR(100) NOT NULL,
    customer_email   VARCHAR(150) NOT NULL UNIQUE,
    customer_city    VARCHAR(80),
    customer_country VARCHAR(60)  NOT NULL
);

-- Cabecera de pedidos
CREATE TABLE orders (
    order_id      UUID         DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_id   UUID         NOT NULL REFERENCES customers(customer_id),
    order_date    DATE         NOT NULL DEFAULT CURRENT_DATE,
    order_status  VARCHAR(20)  NOT NULL DEFAULT 'pending'
                               CHECK (order_status IN ('pending','processing','shipped','delivered','cancelled'))
);

-- Líneas de pedido
CREATE TABLE order_items (
    item_id          UUID          DEFAULT gen_random_uuid() PRIMARY KEY,
    order_id         UUID          NOT NULL REFERENCES orders(order_id),
    product_id       UUID          NOT NULL REFERENCES products(product_id),
    item_quantity    SMALLINT      NOT NULL CHECK (item_quantity > 0),
    item_unit_price  NUMERIC(10,2) NOT NULL CHECK (item_unit_price >= 0)
);

-- -----------------------------------------------------------
-- Datos de prueba
-- -----------------------------------------------------------

INSERT INTO categories (category_name) VALUES
    ('Electrónica'),
    ('Libros'),
    ('Hogar'),
    ('Deportes'),
    ('Ropa');      -- sin ventas

INSERT INTO products (product_name, category_id, product_price, product_stock)
SELECT b.product_name, c.category_id, b.product_price::NUMERIC(10,2), b.product_stock::INTEGER
FROM (VALUES
    ('Laptop Básica 15"',        'Electrónica', 8500.00,  12),
    ('Mouse Inalámbrico',         'Electrónica',  320.00,  45),
    ('Teclado Mecánico',          'Electrónica',  750.00,   8),
    ('Monitor 24"',               'Electrónica', 4200.00,   3),
    ('Auriculares Bluetooth',     'Electrónica',  950.00,   2),
    ('Clean Code',                'Libros',        450.00,  30),
    ('Sapiens',                   'Libros',        320.00,  18),
    ('El Principito',             'Libros',        120.00,  50),
    ('Designing Data-Intensive',  'Libros',        680.00,   4),
    ('Licuadora 2L',              'Hogar',         890.00,  15),
    ('Cafetera de Goteo',         'Hogar',         650.00,   0),
    ('Set de Sartenes',           'Hogar',        1200.00,   7),
    ('Pelota de Fútbol',          'Deportes',      280.00,  22),
    ('Raqueta de Tenis',          'Deportes',      950.00,  10),
    ('Camiseta Deportiva',        'Ropa',          180.00,  60)
) AS b(product_name, cat_name, product_price, product_stock)
JOIN categories c ON c.category_name = b.cat_name;

INSERT INTO customers (customer_name, customer_email, customer_city, customer_country) VALUES
    ('Ana Torres',      'ana.torres@email.com',   'Ciudad de México', 'México'),
    ('Bob Ramírez',     'bob.ramirez@email.com',  'Guadalajara',      'México'),
    ('Carla Mendoza',   'carla.m@email.com',       'Bogotá',          'Colombia'),
    ('Diego Herrera',   'diego.h@email.com',       'Buenos Aires',    'Argentina'),
    ('Elena Castillo',  'elena.c@email.com',       'Lima',            'Perú'),
    ('Franco Silva',    'franco.s@email.com',      'Monterrey',       'México'),
    ('Gloria Ortiz',    'gloria.o@email.com',      NULL,              'México'),
    ('Hugo Ruiz',       'hugo.r@email.com',        'Bogotá',          'Colombia'),  -- sin pedidos
    ('Irene Vega',      'irene.v@email.com',       'Santiago',        'Chile'),     -- sin pedidos
    ('Juan Pérez',      'juan.p@email.com',        'Lima',            'Perú');

-- Pedidos (referenciamos clientes por email)
INSERT INTO orders (customer_id, order_date, order_status)
SELECT c.customer_id, o.order_date::DATE, o.order_status
FROM (VALUES
    ('ana.torres@email.com',   '2026-01-05', 'delivered'),
    ('ana.torres@email.com',   '2026-01-20', 'delivered'),
    ('bob.ramirez@email.com',  '2026-01-15', 'delivered'),
    ('carla.m@email.com',      '2026-02-03', 'shipped'),
    ('diego.h@email.com',      '2026-02-10', 'delivered'),
    ('diego.h@email.com',      '2026-02-18', 'processing'),
    ('elena.c@email.com',      '2026-03-01', 'pending'),
    ('franco.s@email.com',     '2026-03-05', 'delivered'),
    ('gloria.o@email.com',     '2026-03-12', 'cancelled'),
    ('juan.p@email.com',       '2026-03-20', 'delivered'),
    ('ana.torres@email.com',   '2026-04-02', 'processing'),
    ('bob.ramirez@email.com',  '2026-04-10', 'pending'),
    ('elena.c@email.com',      '2026-04-15', 'shipped')
) AS o(customer_email, order_date, order_status)
JOIN customers c ON c.customer_email = o.customer_email;

-- Ítems de pedido (referenciamos pedidos por customer_email+order_date y productos por nombre)
INSERT INTO order_items (order_id, product_id, item_quantity, item_unit_price)
SELECT ord.order_id, p.product_id, oi.item_qty::SMALLINT, oi.item_price::NUMERIC(10,2)
FROM (VALUES
    ('ana.torres@email.com',   '2026-01-05', 'Laptop Básica 15"',        1, 8500.00),
    ('ana.torres@email.com',   '2026-01-05', 'Mouse Inalámbrico',         2,  320.00),
    ('ana.torres@email.com',   '2026-01-20', 'Clean Code',                1,  450.00),
    ('ana.torres@email.com',   '2026-01-20', 'Sapiens',                   1,  320.00),
    ('bob.ramirez@email.com',  '2026-01-15', 'Teclado Mecánico',          1,  750.00),
    ('bob.ramirez@email.com',  '2026-01-15', 'Auriculares Bluetooth',     1,  950.00),
    ('carla.m@email.com',      '2026-02-03', 'Clean Code',                2,  450.00),
    ('carla.m@email.com',      '2026-02-03', 'El Principito',             3,  120.00),
    ('diego.h@email.com',      '2026-02-10', 'Monitor 24"',               1, 4200.00),
    ('diego.h@email.com',      '2026-02-10', 'Licuadora 2L',              1,  890.00),
    ('diego.h@email.com',      '2026-02-18', 'Laptop Básica 15"',        1, 8500.00),
    ('diego.h@email.com',      '2026-02-18', 'Mouse Inalámbrico',         1,  320.00),
    ('franco.s@email.com',     '2026-03-05', 'Pelota de Fútbol',          2,  280.00),
    ('gloria.o@email.com',     '2026-03-12', 'Set de Sartenes',           1, 1200.00),
    ('gloria.o@email.com',     '2026-03-12', 'Cafetera de Goteo',         1,  650.00),
    ('juan.p@email.com',       '2026-03-20', 'Camiseta Deportiva',        3,  180.00),  -- pedido cancelado
    ('ana.torres@email.com',   '2026-04-02', 'Clean Code',                1,  450.00),
    ('ana.torres@email.com',   '2026-04-02', 'Designing Data-Intensive',  1,  680.00),
    ('bob.ramirez@email.com',  '2026-04-10', 'Mouse Inalámbrico',         3,  320.00),
    ('bob.ramirez@email.com',  '2026-04-10', 'Auriculares Bluetooth',     1,  950.00),
    ('elena.c@email.com',      '2026-04-15', 'Sapiens',                   2,  320.00),
    ('elena.c@email.com',      '2026-04-15', 'Raqueta de Tenis',          1,  950.00),
    ('elena.c@email.com',      '2026-04-15', 'Pelota de Fútbol',          1,  280.00)
) AS oi(customer_email, order_date, product_name, item_qty, item_price)
JOIN customers c   ON c.customer_email = oi.customer_email
JOIN orders    ord ON ord.customer_id  = c.customer_id AND ord.order_date = oi.order_date::DATE
JOIN products  p   ON p.product_name   = oi.product_name;


-- ============================================================
-- PARTE 2: LAS 10 PREGUNTAS DE NEGOCIO
-- ============================================================
-- Instrucción general:
--   - Escribe la consulta debajo de cada TODO
--   - Agrega un comentario (--) explicando qué hace y qué resultado esperas
--   - Usa alias descriptivos en español para las columnas del resultado
-- ============================================================


-- ------------------------------------------------------------
-- Pregunta 1: ¿Cuántos productos hay en cada categoría?
-- Resultado esperado: 5 filas, una por categoría, con el conteo de productos.
-- ------------------------------------------------------------

-- TODO: Escribe una consulta que muestre el nombre de la categoría y
--       la cantidad de productos que tiene, ordenada de mayor a menor.
--       Tablas: categories (c), products (p)
--       Columnas clave: c.category_name, COUNT(*)


-- ------------------------------------------------------------
-- Pregunta 2: ¿Cuáles son los 5 productos más vendidos por unidades?
-- Resultado esperado: 5 filas con nombre del producto y total de unidades vendidas.
-- Nota: considera solo pedidos NO cancelados.
-- ------------------------------------------------------------

-- TODO: Escribe una consulta con JOIN entre order_items, orders y products.
--       Filtra los pedidos cancelados (order_status <> 'cancelled').
--       Suma las cantidades vendidas por producto (item_quantity).
--       Usa p.product_name como nombre del producto.
--       Limita a los 5 primeros.


-- ------------------------------------------------------------
-- Pregunta 3: ¿Qué clientes no han realizado ningún pedido?
-- Resultado esperado: 2 clientes (Hugo Ruiz e Irene Vega).
-- ------------------------------------------------------------

-- TODO: Usa LEFT JOIN entre customers y orders.
--       Filtra con WHERE para encontrar los que no tienen pedido asociado.
--       Muestra customer_name y customer_email.


-- ------------------------------------------------------------
-- Pregunta 4: ¿Cuál es el ingreso total por mes en 2026?
-- Resultado esperado: una fila por cada mes que tenga ventas.
-- Nota: excluir pedidos cancelados. Usa TO_CHAR(date, 'YYYY-MM') para agrupar por mes.
-- ------------------------------------------------------------

-- TODO: Haz JOIN entre order_items, orders.
--       Agrupa por mes usando TO_CHAR(o.order_date, 'YYYY-MM').
--       Suma item_quantity * item_unit_price como ingreso_total.
--       Filtra order_status <> 'cancelled' y order_date >= '2026-01-01'.


-- ------------------------------------------------------------
-- Pregunta 5: ¿Qué productos tienen stock menor a 5 unidades?
-- Resultado esperado: productos con stock = 0, 2, 3 o 4. Incluye los de stock = 0.
-- ------------------------------------------------------------

-- TODO: Consulta simple sobre la tabla products.
--       Filtra product_stock < 5.
--       Muestra product_name, categoría (JOIN con categories) y product_stock.
--       Ordena por product_stock ascendente.


-- ------------------------------------------------------------
-- Pregunta 6: ¿Cuál es el ticket promedio por pedido?
-- Resultado esperado: una sola fila con el promedio redondeado a 2 decimales.
-- Nota: el "ticket" de un pedido es la suma de sus ítems (quantity * unit_price).
--       Excluir pedidos cancelados.
-- ------------------------------------------------------------

-- TODO: Usa una subconsulta o CTE para calcular primero el total de cada pedido,
--       luego calcula el AVG sobre esos totales.
--       El total de un pedido: SUM(item_quantity * item_unit_price)
--       Sugerencia: AVG(SELECT SUM(...)...) no es válido — necesitas una subconsulta.


-- ------------------------------------------------------------
-- Pregunta 7: ¿Qué países generan más ingresos?
-- Resultado esperado: una fila por país, ordenada por ingresos de mayor a menor.
-- Nota: excluir pedidos cancelados.
-- ------------------------------------------------------------

-- TODO: JOIN: order_items → orders → customers.
--       Agrupa por customers.customer_country.
--       Suma item_quantity * item_unit_price.
--       Filtra order_status <> 'cancelled'.


-- ------------------------------------------------------------
-- Pregunta 8: ¿Cuántos pedidos hay en cada estado?
-- Resultado esperado: una fila por cada valor de status con su conteo.
-- ------------------------------------------------------------

-- TODO: Consulta simple sobre orders.
--       Agrupa por order_status, cuenta los pedidos.
--       Ordena de mayor a menor.


-- ------------------------------------------------------------
-- Pregunta 9: ¿Qué categorías no tienen ninguna venta registrada?
-- Resultado esperado: solo la categoría 'Ropa'.
-- Nota: "sin venta" significa que ningún producto de esa categoría
--       aparece en order_items con un pedido no cancelado.
-- ------------------------------------------------------------

-- TODO: Usa LEFT JOIN: categories → products → order_items (con JOIN a orders para filtrar cancelados).
--       Agrupa por categoría.
--       Usa HAVING COUNT(oi.item_id) = 0 para encontrar las sin ventas.


-- ------------------------------------------------------------
-- Pregunta 10: ¿Cuál es el top 3 de clientes por monto total comprado?
-- Resultado esperado: 3 clientes con el mayor gasto acumulado (excluir cancelados).
-- ------------------------------------------------------------

-- TODO: JOIN: customers → orders → order_items.
--       Filtra order_status <> 'cancelled'.
--       Agrupa por cliente (customer_id, customer_name).
--       Suma item_quantity * item_unit_price como total_gastado.
--       Ordena DESC, LIMIT 3.
