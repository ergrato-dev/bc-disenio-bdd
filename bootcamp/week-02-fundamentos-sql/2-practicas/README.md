# Práctica — Semana 02: Fundamentos SQL de consulta

## Contexto

Trabajarás con la base de datos de **Librería Del Bosque**, una librería independiente
que quiere analizar su catálogo y ventas con consultas SQL.

El esquema tiene **5 tablas**: `genres`, `authors`, `books`, `customers` y `orders`.

> **¿Cómo usar esta práctica?**
> Ejecuta cada bloque SQL en pgAdmin o DBeaver, sección por sección.
> Observa el resultado antes de continuar con la siguiente sección.
> No hay nada que implementar — el código ya está escrito para que aprendas leyendo y ejecutando.

---

## Parte 1: Preparar el entorno

### Paso 1.1 — Crear el esquema y las tablas

Conecta a tu base de datos `bootcamp_db` y ejecuta el siguiente script completo:

```sql
-- ============================================================
-- BASE DE DATOS: Librería Del Bosque
-- Semana 02 — Práctica de Fundamentos SQL
-- ============================================================

-- Limpiar si existe (para poder re-ejecutar)
DROP TABLE IF EXISTS orders   CASCADE;
DROP TABLE IF EXISTS books    CASCADE;
DROP TABLE IF EXISTS authors  CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS genres   CASCADE;

-- 1. Géneros literarios
CREATE TABLE genres (
    id   SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(60) NOT NULL UNIQUE
);

-- 2. Autores
CREATE TABLE authors (
    id          INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    nationality VARCHAR(50),
    birth_year  SMALLINT
);

-- 3. Libros
CREATE TABLE books (
    id             INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title          VARCHAR(200)  NOT NULL,
    author_id      INTEGER       NOT NULL REFERENCES authors(id),
    genre_id       SMALLINT      NOT NULL REFERENCES genres(id),
    price          NUMERIC(8,2)  NOT NULL CHECK (price >= 0),
    stock          SMALLINT      NOT NULL DEFAULT 0 CHECK (stock >= 0),
    published_year SMALLINT
);

-- 4. Clientes
CREATE TABLE customers (
    id        INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email     VARCHAR(150) NOT NULL UNIQUE,
    city      VARCHAR(80),
    country   VARCHAR(60)  NOT NULL DEFAULT 'México'
);

-- 5. Pedidos
CREATE TABLE orders (
    id          INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER     NOT NULL REFERENCES customers(id),
    book_id     INTEGER     NOT NULL REFERENCES books(id),
    quantity    SMALLINT    NOT NULL DEFAULT 1 CHECK (quantity > 0),
    order_date  DATE        NOT NULL DEFAULT CURRENT_DATE
);
```

Después de ejecutar, verifica que las 5 tablas existen:

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type   = 'BASE TABLE'
ORDER BY table_name;
```

Deberías ver: `authors`, `books`, `customers`, `genres`, `orders`.

---

### Paso 1.2 — Cargar datos de prueba

```sql
-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

-- Géneros
INSERT INTO genres (name) VALUES
    ('Novela'),
    ('Ciencia Ficción'),
    ('Historia'),
    ('Programación'),
    ('Filosofía'),
    ('Poesía');

-- Autores
INSERT INTO authors (full_name, nationality, birth_year) VALUES
    ('Gabriel García Márquez',    'Colombiana',  1927),
    ('Isaac Asimov',              'Estadounidense', 1920),
    ('Yuval Noah Harari',         'Israelí',     1976),
    ('Robert C. Martin',          'Estadounidense', 1952),
    ('Jorge Luis Borges',         'Argentina',   1899),
    ('Ursula K. Le Guin',         'Estadounidense', 1929),
    ('Thomas Cormen',             'Estadounidense', NULL),  -- año desconocido
    ('Octavio Paz',               'Mexicana',    1914);

-- Libros
INSERT INTO books (title, author_id, genre_id, price, stock, published_year) VALUES
    ('Cien años de soledad',           1, 1, 280.00,  8, 1967),
    ('El amor en los tiempos del cólera', 1, 1, 250.00, 3, 1985),
    ('Fundación',                      2, 2, 199.00, 15, 1951),
    ('Yo, Robot',                      2, 2, 179.00,  0, 1950),  -- sin stock
    ('Sapiens',                        3, 3, 320.00, 12, 2011),
    ('Homo Deus',                      3, 3, 310.00,  5, 2015),
    ('Código Limpio',                  4, 4, 450.00,  6, 2008),
    ('El Aleph',                       5, 1, 220.00,  4, 1949),
    ('Ficciones',                      5, 1, 210.00,  7, 1944),
    ('La mano izquierda de la oscuridad', 6, 2, 240.00, 9, 1969),
    ('Introducción a los Algoritmos',  7, 4, 650.00,  2, 1990),
    ('El laberinto de la soledad',     8, 5, 195.00, 10, 1950),
    ('Piedra de sol',                  8, 6, 120.00,  0, 1957);  -- sin stock

-- Clientes
INSERT INTO customers (full_name, email, city, country) VALUES
    ('Ana Torres',      'ana.torres@email.com',    'Ciudad de México', 'México'),
    ('Bob Ramírez',     'bob.ramirez@email.com',   'Guadalajara',      'México'),
    ('Carla Mendoza',   'carla.m@email.com',        'Monterrey',       'México'),
    ('Diego Herrera',   'diego.h@email.com',        'Puebla',          'México'),
    ('Elena Castillo',  'elena.c@email.com',        'Buenos Aires',    'Argentina'),
    ('Franco Silva',    'franco.s@email.com',       'Bogotá',          'Colombia'),
    ('Gloria Ortiz',    'gloria.o@email.com',       NULL,              'México'),  -- ciudad desconocida
    ('Hugo Ruiz',       'hugo.r@email.com',         'Lima',            'Perú');    -- nunca ha pedido

-- Pedidos (Hugo nunca ha pedido)
INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
    (1, 1,  1, '2026-01-10'),
    (1, 5,  2, '2026-01-15'),
    (1, 7,  1, '2026-02-03'),
    (2, 3,  1, '2026-01-20'),
    (2, 4,  1, '2026-01-20'),  -- libro sin stock, se vendió antes de agotarse
    (3, 5,  1, '2026-01-22'),
    (3, 6,  1, '2026-02-10'),
    (4, 8,  2, '2026-02-14'),
    (4, 9,  1, '2026-02-14'),
    (5, 10, 1, '2026-03-01'),
    (6, 1,  1, '2026-03-05'),
    (6, 12, 3, '2026-03-05'),
    (7, 7,  1, '2026-03-10');
```

---

## Parte 2: SELECT, WHERE, ORDER BY, LIMIT

### Paso 2.1 — Consultas básicas de selección

```sql
-- ¿Qué libros tenemos en el catálogo?
SELECT id, title, price, stock
FROM books
ORDER BY title ASC;
```

Observa cómo ORDER BY ASC ordena alfabéticamente.

```sql
-- ¿Cuánto cuesta el libro más caro y el más barato?
SELECT
    title   AS libro,
    price   AS precio
FROM books
ORDER BY price DESC
LIMIT 5;
```

```sql
-- Paginación: libros del 6 al 10 por precio
SELECT
    title,
    price
FROM books
ORDER BY price DESC
LIMIT 5
OFFSET 5;
```

### Paso 2.2 — Filtros con WHERE

```sql
-- Libros con stock disponible (> 0)
SELECT title, price, stock
FROM books
WHERE stock > 0
ORDER BY stock DESC;
```

```sql
-- Libros de ciencia ficción (genre_id = 2)
SELECT title, price
FROM books
WHERE genre_id = 2
ORDER BY published_year;
```

```sql
-- Libros entre $200 y $350 con stock disponible
SELECT title, price, stock
FROM books
WHERE price BETWEEN 200 AND 350
  AND stock > 0
ORDER BY price;
```

```sql
-- Libros cuyo título contiene la palabra "la" (insensible a mayúsculas)
SELECT title, price
FROM books
WHERE title ILIKE '%la%'
ORDER BY title;
```

---

## Parte 3: JOINs

### Paso 3.1 — INNER JOIN: libro con su autor y género

```sql
-- Catálogo completo: título, autor, género y precio
SELECT
    b.title                 AS titulo,
    a.full_name             AS autor,
    g.name                  AS genero,
    b.price                 AS precio,
    b.stock                 AS stock
FROM books      AS b
INNER JOIN authors AS a  ON a.id = b.author_id
INNER JOIN genres  AS g  ON g.id = b.genre_id
ORDER BY b.price DESC;
```

Nota: ¿cuántas filas devuelve? Debe ser igual al número de libros (13).

### Paso 3.2 — LEFT JOIN: clientes con sus pedidos

```sql
-- Todos los clientes y cuántos pedidos tienen
-- (incluye Hugo, que no tiene ninguno)
SELECT
    c.full_name                     AS cliente,
    c.city                          AS ciudad,
    COUNT(o.id)                     AS total_pedidos
FROM customers   AS c
LEFT JOIN orders AS o  ON o.customer_id = c.id
GROUP BY c.id, c.full_name, c.city
ORDER BY total_pedidos DESC;
```

Observa que Hugo aparece con `total_pedidos = 0`.

### Paso 3.3 — Clientes que NUNCA han pedido (anti-join)

```sql
-- LEFT JOIN + WHERE IS NULL = anti-join
SELECT
    c.id,
    c.full_name     AS cliente,
    c.email
FROM customers   AS c
LEFT JOIN orders AS o  ON o.customer_id = c.id
WHERE o.id IS NULL;
```

Resultado esperado: solo Hugo.

### Paso 3.4 — JOIN con múltiples tablas

```sql
-- Detalle de pedidos: cliente, libro, autor y monto
SELECT
    o.order_date                        AS fecha,
    c.full_name                         AS cliente,
    b.title                             AS libro,
    a.full_name                         AS autor,
    o.quantity                          AS cantidad,
    b.price * o.quantity                AS monto
FROM orders     AS o
INNER JOIN customers AS c  ON c.id = o.customer_id
INNER JOIN books     AS b  ON b.id = o.book_id
INNER JOIN authors   AS a  ON a.id = b.author_id
ORDER BY o.order_date, c.full_name;
```

---

## Parte 4: NULL

### Paso 4.1 — Explorar valores NULL

```sql
-- Autores con año de nacimiento desconocido
SELECT full_name, birth_year
FROM authors
WHERE birth_year IS NULL;

-- ¿Qué pasa si usamos = NULL?
SELECT full_name, birth_year
FROM authors
WHERE birth_year = NULL;  -- siempre 0 filas
```

### Paso 4.2 — Clientes sin ciudad registrada

```sql
-- Ciudad NULL: sabemos que existe, pero no la registramos
SELECT full_name, city, country
FROM customers
WHERE city IS NULL;
```

### Paso 4.3 — COALESCE para valores por defecto

```sql
-- Mostrar "Ciudad no registrada" cuando city es NULL
SELECT
    full_name                             AS cliente,
    COALESCE(city, 'Ciudad no registrada') AS ciudad
FROM customers
ORDER BY city NULLS LAST;
```

### Paso 4.4 — NULLIF para evitar división por cero

```sql
-- Precio por unidad vendida (evitando división por cero si quantity fuera 0)
SELECT
    b.title                                     AS libro,
    o.quantity,
    b.price,
    b.price / NULLIF(o.quantity, 0)             AS precio_por_unidad
FROM orders AS o
INNER JOIN books AS b ON b.id = o.book_id
ORDER BY o.quantity DESC;
```

---

## Parte 5: Agregación y GROUP BY

### Paso 5.1 — Estadísticas globales

```sql
-- Resumen estadístico del catálogo
SELECT
    COUNT(*)                    AS total_libros,
    COUNT(published_year)       AS con_año_publicacion,
    ROUND(AVG(price), 2)        AS precio_promedio,
    MIN(price)                  AS precio_minimo,
    MAX(price)                  AS precio_maximo,
    SUM(stock)                  AS unidades_en_stock
FROM books;
```

### Paso 5.2 — Ventas por género

```sql
-- Ingresos totales y libros vendidos por género
SELECT
    g.name                                      AS genero,
    COUNT(o.id)                                 AS pedidos,
    SUM(o.quantity)                             AS unidades_vendidas,
    SUM(o.quantity * b.price)                   AS ingresos_totales
FROM genres     AS g
INNER JOIN books   AS b  ON b.genre_id = g.id
INNER JOIN orders  AS o  ON o.book_id  = b.id
GROUP BY g.id, g.name
ORDER BY ingresos_totales DESC;
```

### Paso 5.3 — HAVING: autores con más de un libro vendido

```sql
-- Autores que han tenido más de 2 pedidos
SELECT
    a.full_name             AS autor,
    COUNT(o.id)             AS total_pedidos,
    SUM(o.quantity)         AS unidades_vendidas
FROM authors AS a
INNER JOIN books  AS b  ON b.author_id = a.id
INNER JOIN orders AS o  ON o.book_id   = b.id
GROUP BY a.id, a.full_name
HAVING COUNT(o.id) > 2
ORDER BY total_pedidos DESC;
```

### Paso 5.4 — Géneros sin ninguna venta (LEFT JOIN + HAVING / WHERE IS NULL)

```sql
-- Géneros que no tienen ningún pedido aún
SELECT
    g.name          AS genero,
    COUNT(o.id)     AS pedidos
FROM genres     AS g
LEFT JOIN books  AS b  ON b.genre_id = g.id
LEFT JOIN orders AS o  ON o.book_id  = b.id
GROUP BY g.id, g.name
HAVING COUNT(o.id) = 0
ORDER BY g.name;
```

---

## Resumen de lo practicado

| Concepto | Ejercicio |
|----------|-----------|
| SELECT básico + ORDER BY + LIMIT | Pasos 2.1 |
| WHERE con operadores | Pasos 2.2 |
| INNER JOIN múltiple | Paso 3.1, 3.4 |
| LEFT JOIN y anti-join | Pasos 3.2, 3.3 |
| IS NULL / IS NOT NULL | Pasos 4.1, 4.2 |
| COALESCE y NULLIF | Pasos 4.3, 4.4 |
| Funciones de agregación | Paso 5.1 |
| GROUP BY + JOIN | Paso 5.2 |
| HAVING | Pasos 5.3, 5.4 |

---

← [README Semana 02](../README.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Proyecto →](../3-proyecto/README.md)
