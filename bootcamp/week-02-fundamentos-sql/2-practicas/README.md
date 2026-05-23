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
    genre_id   UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    genre_name VARCHAR(60) NOT NULL UNIQUE
);

-- 2. Autores
CREATE TABLE authors (
    author_id      UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    author_name    VARCHAR(100) NOT NULL,
    author_nationality VARCHAR(50),
    author_birth_year  SMALLINT
);

-- 3. Libros
CREATE TABLE books (
    book_id             UUID          DEFAULT gen_random_uuid() PRIMARY KEY,
    book_title          VARCHAR(200)  NOT NULL,
    author_id           UUID          NOT NULL REFERENCES authors(author_id),
    genre_id            UUID          NOT NULL REFERENCES genres(genre_id),
    book_price          NUMERIC(8,2)  NOT NULL CHECK (book_price >= 0),
    book_stock          SMALLINT      NOT NULL DEFAULT 0 CHECK (book_stock >= 0),
    book_published_year SMALLINT
);

-- 4. Clientes
CREATE TABLE customers (
    customer_id      UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_name    VARCHAR(100) NOT NULL,
    customer_email   VARCHAR(150) NOT NULL UNIQUE,
    customer_city    VARCHAR(80),
    customer_country VARCHAR(60)  NOT NULL DEFAULT 'México'
);

-- 5. Pedidos
CREATE TABLE orders (
    order_id        UUID     DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_id     UUID     NOT NULL REFERENCES customers(customer_id),
    book_id         UUID     NOT NULL REFERENCES books(book_id),
    order_quantity  SMALLINT NOT NULL DEFAULT 1 CHECK (order_quantity > 0),
    order_date      DATE     NOT NULL DEFAULT CURRENT_DATE
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
INSERT INTO genres (genre_name) VALUES
    ('Novela'),
    ('Ciencia Ficción'),
    ('Historia'),
    ('Programación'),
    ('Filosofía'),
    ('Poesía');

-- Autores
INSERT INTO authors (author_name, author_nationality, author_birth_year) VALUES
    ('Gabriel García Márquez',    'Colombiana',      1927),
    ('Isaac Asimov',              'Estadounidense',  1920),
    ('Yuval Noah Harari',         'Israelí',         1976),
    ('Robert C. Martin',          'Estadounidense',  1952),
    ('Jorge Luis Borges',         'Argentina',       1899),
    ('Ursula K. Le Guin',         'Estadounidense',  1929),
    ('Thomas Cormen',             'Estadounidense',  NULL),  -- año desconocido
    ('Octavio Paz',               'Mexicana',        1914);

-- Libros (referenciamos autores y géneros por nombre, no por ID numérico)
INSERT INTO books (book_title, author_id, genre_id, book_price, book_stock, book_published_year)
SELECT
    b.book_title,
    a.author_id,
    g.genre_id,
    b.book_price::NUMERIC(8,2),
    b.book_stock::SMALLINT,
    b.book_year::SMALLINT
FROM (VALUES
    ('Cien años de soledad',              'Gabriel García Márquez', 'Novela',          280.00,  8, 1967),
    ('El amor en los tiempos del cólera', 'Gabriel García Márquez', 'Novela',          250.00,  3, 1985),
    ('Fundación',                          'Isaac Asimov',           'Ciencia Ficción', 199.00, 15, 1951),
    ('Yo, Robot',                          'Isaac Asimov',           'Ciencia Ficción', 179.00,  0, 1950),
    ('Sapiens',                            'Yuval Noah Harari',      'Historia',        320.00, 12, 2011),
    ('Homo Deus',                          'Yuval Noah Harari',      'Historia',        310.00,  5, 2015),
    ('Código Limpio',                      'Robert C. Martin',       'Programación',    450.00,  6, 2008),
    ('El Aleph',                           'Jorge Luis Borges',      'Novela',          220.00,  4, 1949),
    ('Ficciones',                          'Jorge Luis Borges',      'Novela',          210.00,  7, 1944),
    ('La mano izquierda de la oscuridad',  'Ursula K. Le Guin',      'Ciencia Ficción', 240.00,  9, 1969),
    ('Introducción a los Algoritmos',      'Thomas Cormen',          'Programación',    650.00,  2, 1990),
    ('El laberinto de la soledad',         'Octavio Paz',            'Filosofía',       195.00, 10, 1950),
    ('Piedra de sol',                      'Octavio Paz',            'Poesía',          120.00,  0, 1957)
) AS b(book_title, author_name, genre_name, book_price, book_stock, book_year)
JOIN authors a ON a.author_name = b.author_name
JOIN genres  g ON g.genre_name  = b.genre_name;

-- Clientes
INSERT INTO customers (customer_name, customer_email, customer_city, customer_country) VALUES
    ('Ana Torres',      'ana.torres@email.com',    'Ciudad de México', 'México'),
    ('Bob Ramírez',     'bob.ramirez@email.com',   'Guadalajara',      'México'),
    ('Carla Mendoza',   'carla.m@email.com',        'Monterrey',        'México'),
    ('Diego Herrera',   'diego.h@email.com',        'Puebla',           'México'),
    ('Elena Castillo',  'elena.c@email.com',        'Buenos Aires',     'Argentina'),
    ('Franco Silva',    'franco.s@email.com',       'Bogotá',           'Colombia'),
    ('Gloria Ortiz',    'gloria.o@email.com',       NULL,               'México'),  -- ciudad desconocida
    ('Hugo Ruiz',       'hugo.r@email.com',         'Lima',             'Perú');   -- nunca ha pedido

-- Pedidos (referenciamos clientes y libros por email/título)
INSERT INTO orders (customer_id, book_id, order_quantity, order_date)
SELECT c.customer_id, b.book_id, o.order_qty::SMALLINT, o.order_date::DATE
FROM (VALUES
    ('ana.torres@email.com',    'Cien años de soledad',             1, '2026-01-10'),
    ('ana.torres@email.com',    'Sapiens',                          2, '2026-01-15'),
    ('ana.torres@email.com',    'Código Limpio',                    1, '2026-02-03'),
    ('bob.ramirez@email.com',   'Fundación',                        1, '2026-01-20'),
    ('bob.ramirez@email.com',   'Yo, Robot',                        1, '2026-01-20'),
    ('carla.m@email.com',       'Sapiens',                          1, '2026-01-22'),
    ('carla.m@email.com',       'Homo Deus',                        1, '2026-02-10'),
    ('diego.h@email.com',       'El Aleph',                         2, '2026-02-14'),
    ('diego.h@email.com',       'Ficciones',                        1, '2026-02-14'),
    ('elena.c@email.com',       'La mano izquierda de la oscuridad', 1, '2026-03-01'),
    ('franco.s@email.com',      'Cien años de soledad',             1, '2026-03-05'),
    ('franco.s@email.com',      'El laberinto de la soledad',       3, '2026-03-05'),
    ('gloria.o@email.com',      'Código Limpio',                    1, '2026-03-10')
) AS o(customer_email, book_title, order_qty, order_date)
JOIN customers c ON c.customer_email = o.customer_email
JOIN books     b ON b.book_title     = o.book_title;
```

---

## Parte 2: SELECT, WHERE, ORDER BY, LIMIT

### Paso 2.1 — Consultas básicas de selección

```sql
-- ¿Qué libros tenemos en el catálogo?
SELECT book_id, book_title, book_price, book_stock
FROM books
ORDER BY book_title ASC;
```

Observa cómo ORDER BY ASC ordena alfabéticamente.

```sql
-- ¿Cuánto cuesta el libro más caro y el más barato?
SELECT
    book_title  AS libro,
    book_price  AS precio
FROM books
ORDER BY book_price DESC
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
    b.book_title            AS titulo,
    a.author_name           AS autor,
    g.genre_name            AS genero,
    b.book_price            AS precio,
    b.book_stock            AS stock
FROM books      AS b
INNER JOIN authors AS a  ON a.author_id = b.author_id
INNER JOIN genres  AS g  ON g.genre_id  = b.genre_id
ORDER BY b.book_price DESC;
```

Nota: ¿cuántas filas devuelve? Debe ser igual al número de libros (13).

### Paso 3.2 — LEFT JOIN: clientes con sus pedidos

```sql
-- Todos los clientes y cuántos pedidos tienen
-- (incluye Hugo, que no tiene ninguno)
SELECT
    c.customer_name                 AS cliente,
    c.customer_city                 AS ciudad,
    COUNT(o.order_id)               AS total_pedidos
FROM customers   AS c
LEFT JOIN orders AS o  ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_city
ORDER BY total_pedidos DESC;
```

Observa que Hugo aparece con `total_pedidos = 0`.

### Paso 3.3 — Clientes que NUNCA han pedido (anti-join)

```sql
-- LEFT JOIN + WHERE IS NULL = anti-join
SELECT
    c.customer_id,
    c.customer_name  AS cliente,
    c.customer_email
FROM customers   AS c
LEFT JOIN orders AS o  ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;
```

Resultado esperado: solo Hugo.

### Paso 3.4 — JOIN con múltiples tablas

```sql
-- Detalle de pedidos: cliente, libro, autor y monto
SELECT
    o.order_date                        AS fecha,
    c.customer_name                     AS cliente,
    b.book_title                        AS libro,
    a.author_name                       AS autor,
    o.order_quantity                    AS cantidad,
    b.book_price * o.order_quantity     AS monto
FROM orders     AS o
INNER JOIN customers AS c  ON c.customer_id = o.customer_id
INNER JOIN books     AS b  ON b.book_id     = o.book_id
INNER JOIN authors   AS a  ON a.author_id   = b.author_id
ORDER BY o.order_date, c.customer_name;
```

---

## Parte 4: NULL

### Paso 4.1 — Explorar valores NULL

```sql
-- Autores con año de nacimiento desconocido
SELECT author_name, author_birth_year
FROM authors
WHERE author_birth_year IS NULL;

-- ¿Qué pasa si usamos = NULL?
SELECT author_name, author_birth_year
FROM authors
WHERE author_birth_year = NULL;  -- siempre 0 filas
```

### Paso 4.2 — Clientes sin ciudad registrada

```sql
-- Ciudad NULL: sabemos que existe, pero no la registramos
SELECT customer_name, customer_city, customer_country
FROM customers
WHERE customer_city IS NULL;
```

### Paso 4.3 — COALESCE para valores por defecto

```sql
-- Mostrar "Ciudad no registrada" cuando customer_city es NULL
SELECT
    customer_name                                        AS cliente,
    COALESCE(customer_city, 'Ciudad no registrada')     AS ciudad
FROM customers
ORDER BY customer_city NULLS LAST;
```

### Paso 4.4 — NULLIF para evitar división por cero

```sql
-- Precio por unidad vendida (evitando división por cero si order_quantity fuera 0)
SELECT
    b.book_title                                        AS libro,
    o.order_quantity,
    b.book_price,
    b.book_price / NULLIF(o.order_quantity, 0)          AS precio_por_unidad
FROM orders AS o
INNER JOIN books AS b ON b.book_id = o.book_id
ORDER BY o.order_quantity DESC;
```

---

## Parte 5: Agregación y GROUP BY

### Paso 5.1 — Estadísticas globales

```sql
-- Resumen estadístico del catálogo
SELECT
    COUNT(*)                        AS total_libros,
    COUNT(book_published_year)      AS con_año_publicacion,
    ROUND(AVG(book_price), 2)       AS precio_promedio,
    MIN(book_price)                 AS precio_minimo,
    MAX(book_price)                 AS precio_maximo,
    SUM(book_stock)                 AS unidades_en_stock
FROM books;
```

### Paso 5.2 — Ventas por género

```sql
-- Ingresos totales y libros vendidos por género
SELECT
    g.genre_name                                    AS genero,
    COUNT(o.order_id)                               AS pedidos,
    SUM(o.order_quantity)                           AS unidades_vendidas,
    SUM(o.order_quantity * b.book_price)            AS ingresos_totales
FROM genres     AS g
INNER JOIN books   AS b  ON b.genre_id = g.genre_id
INNER JOIN orders  AS o  ON o.book_id  = b.book_id
GROUP BY g.genre_id, g.genre_name
ORDER BY ingresos_totales DESC;
```

### Paso 5.3 — HAVING: autores con más de un libro vendido

```sql
-- Autores que han tenido más de 2 pedidos
SELECT
    a.author_name           AS autor,
    COUNT(o.order_id)       AS total_pedidos,
    SUM(o.order_quantity)   AS unidades_vendidas
FROM authors AS a
INNER JOIN books  AS b  ON b.author_id = a.author_id
INNER JOIN orders AS o  ON o.book_id   = b.book_id
GROUP BY a.author_id, a.author_name
HAVING COUNT(o.order_id) > 2
ORDER BY total_pedidos DESC;
```

### Paso 5.4 — Géneros sin ninguna venta (LEFT JOIN + HAVING / WHERE IS NULL)

```sql
-- Géneros que no tienen ningún pedido aún
SELECT
    g.genre_name        AS genero,
    COUNT(o.order_id)   AS pedidos
FROM genres     AS g
LEFT JOIN books  AS b  ON b.genre_id = g.genre_id
LEFT JOIN orders AS o  ON o.book_id  = b.book_id
GROUP BY g.genre_id, g.genre_name
HAVING COUNT(o.order_id) = 0
ORDER BY g.genre_name;
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
