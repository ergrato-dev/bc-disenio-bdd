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
    id   SMALLINT    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE
);

-- Catálogo de productos
CREATE TABLE products (
    id          INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(150)  NOT NULL,
    category_id SMALLINT      NOT NULL REFERENCES categories(id),
    price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock       INTEGER       NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

-- Clientes registrados
CREATE TABLE customers (
    id        INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email     VARCHAR(150) NOT NULL UNIQUE,
    city      VARCHAR(80),
    country   VARCHAR(60)  NOT NULL
);

-- Cabecera de pedidos
CREATE TABLE orders (
    id          INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER     NOT NULL REFERENCES customers(id),
    order_date  DATE        NOT NULL DEFAULT CURRENT_DATE,
    status      VARCHAR(20) NOT NULL DEFAULT 'pending'
                            CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);

-- Líneas de pedido
CREATE TABLE order_items (
    id          INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id    INTEGER       NOT NULL REFERENCES orders(id),
    product_id  INTEGER       NOT NULL REFERENCES products(id),
    quantity    SMALLINT      NOT NULL CHECK (quantity > 0),
    unit_price  NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

-- -----------------------------------------------------------
-- Datos de prueba
-- -----------------------------------------------------------

INSERT INTO categories (name) VALUES
    ('Electrónica'),
    ('Libros'),
    ('Hogar'),
    ('Deportes'),
    ('Ropa');      -- sin ventas

INSERT INTO products (name, category_id, price, stock) VALUES
    ('Laptop Básica 15"',       1, 8500.00,  12),
    ('Mouse Inalámbrico',        1,  320.00,  45),
    ('Teclado Mecánico',         1,  750.00,   8),
    ('Monitor 24"',              1, 4200.00,   3),
    ('Auriculares Bluetooth',    1,  950.00,   2),   -- stock bajo
    ('Clean Code',               2,  450.00,  30),
    ('Sapiens',                  2,  320.00,  18),
    ('El Principito',            2,  120.00,  50),
    ('Designing Data-Intensive', 2,  680.00,   4),   -- stock bajo
    ('Licuadora 2L',             3,  890.00,  15),
    ('Cafetera de Goteo',        3,  650.00,   0),   -- sin stock
    ('Set de Sartenes',          3, 1200.00,   7),
    ('Pelota de Fútbol',         4,  280.00,  22),
    ('Raqueta de Tenis',         4,  950.00,  10),
    ('Camiseta Deportiva',       5,  180.00,  60);   -- categoría Ropa

INSERT INTO customers (full_name, email, city, country) VALUES
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

-- Pedidos
INSERT INTO orders (customer_id, order_date, status) VALUES
    (1,  '2026-01-05', 'delivered'),
    (1,  '2026-01-20', 'delivered'),
    (2,  '2026-01-15', 'delivered'),
    (3,  '2026-02-03', 'shipped'),
    (4,  '2026-02-10', 'delivered'),
    (4,  '2026-02-18', 'processing'),
    (5,  '2026-03-01', 'pending'),
    (6,  '2026-03-05', 'delivered'),
    (7,  '2026-03-12', 'cancelled'),
    (10, '2026-03-20', 'delivered'),
    (1,  '2026-04-02', 'processing'),
    (2,  '2026-04-10', 'pending'),
    (5,  '2026-04-15', 'shipped');

-- Ítems de pedido
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1,  1,  1, 8500.00),
    (1,  2,  2,  320.00),
    (2,  6,  1,  450.00),
    (2,  7,  1,  320.00),
    (3,  3,  1,  750.00),
    (3,  5,  1,  950.00),
    (4,  6,  2,  450.00),
    (4,  8,  3,  120.00),
    (5,  4,  1, 4200.00),
    (5,  10, 1,  890.00),
    (6,  1,  1, 8500.00),
    (6,  2,  1,  320.00),
    (7,  13, 2,  280.00),
    (8,  12, 1, 1200.00),
    (8,  11, 1,  650.00),
    (9,  15, 3,  180.00),  -- pedido cancelado
    (10, 6,  1,  450.00),
    (10, 9,  1,  680.00),
    (11, 2,  3,  320.00),
    (11, 5,  1,  950.00),
    (12, 7,  2,  320.00),
    (13, 14, 1,  950.00),
    (13, 13, 1,  280.00);


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


-- ------------------------------------------------------------
-- Pregunta 2: ¿Cuáles son los 5 productos más vendidos por unidades?
-- Resultado esperado: 5 filas con nombre del producto y total de unidades vendidas.
-- Nota: considera solo pedidos NO cancelados.
-- ------------------------------------------------------------

-- TODO: Escribe una consulta con JOIN entre order_items, orders y products.
--       Filtra los pedidos cancelados (status <> 'cancelled').
--       Suma las cantidades vendidas por producto.
--       Limita a los 5 primeros.


-- ------------------------------------------------------------
-- Pregunta 3: ¿Qué clientes no han realizado ningún pedido?
-- Resultado esperado: 2 clientes (Hugo Ruiz e Irene Vega).
-- ------------------------------------------------------------

-- TODO: Usa LEFT JOIN entre customers y orders.
--       Filtra con WHERE para encontrar los que no tienen pedido asociado.


-- ------------------------------------------------------------
-- Pregunta 4: ¿Cuál es el ingreso total por mes en 2026?
-- Resultado esperado: una fila por cada mes que tenga ventas.
-- Nota: excluir pedidos cancelados. Usa TO_CHAR(date, 'YYYY-MM') para agrupar por mes.
-- ------------------------------------------------------------

-- TODO: Haz JOIN entre order_items, orders.
--       Agrupa por mes usando TO_CHAR(o.order_date, 'YYYY-MM').
--       Suma quantity * unit_price como ingreso_total.
--       Filtra status <> 'cancelled' y order_date >= '2026-01-01'.


-- ------------------------------------------------------------
-- Pregunta 5: ¿Qué productos tienen stock menor a 5 unidades?
-- Resultado esperado: productos con stock = 0, 2, 3 o 4. Incluye los de stock = 0.
-- ------------------------------------------------------------

-- TODO: Consulta simple sobre la tabla products.
--       Filtra stock < 5.
--       Muestra nombre, categoría (con JOIN) y stock.
--       Ordena por stock ascendente.


-- ------------------------------------------------------------
-- Pregunta 6: ¿Cuál es el ticket promedio por pedido?
-- Resultado esperado: una sola fila con el promedio redondeado a 2 decimales.
-- Nota: el "ticket" de un pedido es la suma de sus ítems (quantity * unit_price).
--       Excluir pedidos cancelados.
-- ------------------------------------------------------------

-- TODO: Usa una subconsulta o CTE para calcular primero el total de cada pedido,
--       luego calcula el AVG sobre esos totales.
--       Sugerencia: AVG(SELECT SUM(...)...) no es válido — necesitas una subconsulta.


-- ------------------------------------------------------------
-- Pregunta 7: ¿Qué países generan más ingresos?
-- Resultado esperado: una fila por país, ordenada por ingresos de mayor a menor.
-- Nota: excluir pedidos cancelados.
-- ------------------------------------------------------------

-- TODO: JOIN: order_items → orders → customers.
--       Agrupa por customers.country.
--       Suma quantity * unit_price.


-- ------------------------------------------------------------
-- Pregunta 8: ¿Cuántos pedidos hay en cada estado?
-- Resultado esperado: una fila por cada valor de status con su conteo.
-- ------------------------------------------------------------

-- TODO: Consulta simple sobre orders.
--       Agrupa por status, cuenta los pedidos.
--       Ordena de mayor a menor.


-- ------------------------------------------------------------
-- Pregunta 9: ¿Qué categorías no tienen ninguna venta registrada?
-- Resultado esperado: solo la categoría 'Ropa'.
-- Nota: "sin venta" significa que ningún producto de esa categoría
--       aparece en order_items con un pedido no cancelado.
-- ------------------------------------------------------------

-- TODO: Usa LEFT JOIN: categories → products → order_items (con JOIN a orders para filtrar cancelados).
--       Agrupa por categoría.
--       Usa HAVING COUNT(oi.id) = 0 para encontrar las sin ventas.


-- ------------------------------------------------------------
-- Pregunta 10: ¿Cuál es el top 3 de clientes por monto total comprado?
-- Resultado esperado: 3 clientes con el mayor gasto acumulado (excluir cancelados).
-- ------------------------------------------------------------

-- TODO: JOIN: customers → orders → order_items.
--       Filtra status <> 'cancelled'.
--       Agrupa por cliente.
--       Suma quantity * unit_price como total_gastado.
--       Ordena DESC, LIMIT 3.
