# Práctica: Normalizar `orders_raw` de LibroExpress hasta 2FN

## Contexto

LibroExpress es una librería online. Su equipo de desarrollo creó una tabla
`orders_raw` para registrar pedidos, pero la diseñaron sin aplicar formas
normales. Tu tarea es llevarla desde **UNF hasta 2FN** paso a paso.

**Herramientas:** PostgreSQL 16, pgAdmin 4 o DBeaver  
**Tiempo estimado:** 3 horas  
**Archivos de apoyo:** `../0-assets/02-dependencias-funcionales.svg`,
`../0-assets/03-primera-forma-normal.svg`, `../0-assets/04-segunda-forma-normal.svg`

---

## Tabla inicial: `orders_raw`

Ejecuta este bloque para crear la tabla y poblarla con datos de prueba:

```sql
-- ============================================================
-- SETUP: Esquema inicial desnormalizado (UNF)
-- ============================================================
DROP TABLE IF EXISTS orders_raw;

CREATE TABLE orders_raw (
    order_id         VARCHAR(10),
    product_id       VARCHAR(10),
    customer_id      VARCHAR(10),
    customer_name    VARCHAR(100),
    customer_email   VARCHAR(150),
    customer_phones  TEXT,                   -- "555-1234, 555-5678"
    product_name     VARCHAR(100),
    product_category VARCHAR(80),
    quantity         SMALLINT,
    unit_price       NUMERIC(10, 2),
    order_date       DATE,
    PRIMARY KEY (order_id, product_id)       -- PK compuesta
);

INSERT INTO orders_raw VALUES
    ('o-001','p-001','c-001','Ana López','ana@email.com','555-1234, 555-5678','SQL Avanzado','Tecnología',2,29.99,'2025-01-15'),
    ('o-001','p-002','c-001','Ana López','ana@email.com','555-1234, 555-5678','Python Pro','Tecnología',1,49.99,'2025-01-15'),
    ('o-002','p-001','c-002','Beto Ruiz','beto@email.com','555-9012','SQL Avanzado','Tecnología',3,29.99,'2025-01-16'),
    ('o-002','p-003','c-002','Beto Ruiz','beto@email.com','555-9012','Diseño BD','Tecnología',1,39.99,'2025-01-16'),
    ('o-003','p-002','c-003','Carla Vega','carla@email.com','555-3456, 555-7890','Python Pro','Tecnología',2,49.99,'2025-01-17');
```

---

## Paso 1 — Identificar todas las dependencias funcionales

Antes de escribir cualquier DDL, analiza los datos e identifica qué determina qué.

Ejecuta estas consultas de diagnóstico para comprender la estructura:

```sql
-- ¿Cambia customer_name para el mismo order_id?
-- Si no cambia → order_id → customer_name
SELECT order_id, COUNT(DISTINCT customer_name) AS variantes
FROM orders_raw
GROUP BY order_id
HAVING COUNT(DISTINCT customer_name) > 1;
-- Resultado esperado: 0 filas (confirma la FD)

-- ¿Cambia product_name para el mismo product_id?
SELECT product_id, COUNT(DISTINCT product_name) AS variantes
FROM orders_raw
GROUP BY product_id
HAVING COUNT(DISTINCT product_name) > 1;
-- Resultado esperado: 0 filas (confirma la FD)

-- ¿Depende quantity de ambos (order_id + product_id)?
-- Si varía quantity para la misma combinación → problema
SELECT order_id, product_id, COUNT(*) AS filas
FROM orders_raw
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;
-- Resultado esperado: 0 filas (la PK es correcta)
```

**Registro de dependencias encontradas:**

| Determinante             | Dependiente                         | Tipo        |
|--------------------------|-------------------------------------|-------------|
| `{order_id, product_id}` | `quantity`, `unit_price`            | Completa ✅ |
| `order_id`               | `customer_id`, `customer_name`, ... | Parcial ❌  |
| `product_id`             | `product_name`, `product_category`  | Parcial ❌  |
| `customer_id`            | `customer_name`, `customer_email`   | Transitiva* |

> *La dependencia transitiva (`order_id → customer_id → customer_name`) se abordará en la Semana 08 (3FN).

---

## Paso 2 — Diagnosticar la violación de 1FN

Observa la columna `customer_phones`. Ejecuta:

```sql
-- Ver los valores de customer_phones
SELECT DISTINCT customer_id, customer_name, customer_phones
FROM orders_raw
ORDER BY customer_id;
```

Identifica el problema:

```sql
-- Intento de buscar un número específico (consulta frágil):
SELECT customer_name
FROM orders_raw
WHERE customer_phones LIKE '%555-1234%';

-- ¿Por qué esto es problemático?
-- 1. No podemos indexar customer_phones para búsquedas exactas
-- 2. No podemos validar el formato de cada número individualmente
-- 3. Un mismo cliente puede tener 0, 1, o N teléfonos → no es atómico
```

**Diagnóstico:** `customer_phones` viola la **Primera Forma Normal** porque
almacena múltiples valores en una sola celda (valor no atómico).

---

## Paso 3 — Aplicar 1FN: extraer `customer_phones` a tabla separada

Ejecuta los siguientes bloques en orden:

```sql
-- ============================================================
-- PASO 3.1: Crear tabla de clientes (sin los teléfonos)
-- ============================================================
CREATE TABLE customers (
    customer_id    VARCHAR(10)  NOT NULL,
    customer_name  VARCHAR(100) NOT NULL,
    customer_email VARCHAR(150) NOT NULL,
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email UNIQUE (customer_email)
);
```

```sql
-- ============================================================
-- PASO 3.2: Crear tabla de teléfonos (1 fila = 1 número)
-- ============================================================
CREATE TABLE customer_phones (
    phone_id      UUID         NOT NULL DEFAULT gen_random_uuid(),
    customer_id   VARCHAR(10)  NOT NULL,
    phone_number  VARCHAR(20)  NOT NULL,
    phone_type    VARCHAR(10)  NOT NULL DEFAULT 'mobile',
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_customer_phones PRIMARY KEY (phone_id),
    CONSTRAINT fk_customer_phones_customer_id
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);
```

```sql
-- ============================================================
-- PASO 3.3: Migrar datos desde orders_raw
-- ============================================================
INSERT INTO customers (customer_id, customer_name, customer_email)
SELECT DISTINCT customer_id, customer_name, customer_email
FROM orders_raw;

-- Verificar migración
SELECT * FROM customers ORDER BY customer_id;
```

```sql
-- Migrar teléfonos (separar el string en filas individuales)
-- Nota: regexp_split_to_table divide por coma seguida de espacio opcional
INSERT INTO customer_phones (customer_id, phone_number)
SELECT DISTINCT
    customer_id,
    TRIM(phone) AS phone_number
FROM orders_raw,
     regexp_split_to_table(customer_phones, ',\s*') AS phone;

-- Verificar: cada teléfono en su propia fila
SELECT c.customer_name, p.phone_number, p.phone_type
FROM customers c
JOIN customer_phones p ON p.customer_id = c.customer_id
ORDER BY c.customer_id;
```

Ahora la consulta por número es limpia e indexable:

```sql
-- Buscar cliente por número exacto (eficiente con índice)
SELECT c.customer_name, c.customer_email
FROM customers c
JOIN customer_phones p ON p.customer_id = c.customer_id
WHERE p.phone_number = '555-1234';
```

---

## Paso 4 — Identificar las dependencias parciales en la PK compuesta

La tabla `orders_raw` aún tiene su PK compuesta `{order_id, product_id}`. Mapea
las dependencias parciales que quedan por resolver:

```sql
-- ¿customer_id depende solo de order_id (no de product_id)?
SELECT order_id, COUNT(DISTINCT customer_id) AS clientes_distintos
FROM orders_raw
GROUP BY order_id
HAVING COUNT(DISTINCT customer_id) > 1;
-- 0 filas → confirmado: order_id → customer_id (PARCIAL)

-- ¿product_name depende solo de product_id?
SELECT product_id, COUNT(DISTINCT product_name) AS nombres
FROM orders_raw
GROUP BY product_id
HAVING COUNT(DISTINCT product_name) > 1;
-- 0 filas → confirmado: product_id → product_name, product_category (PARCIAL)
```

---

## Paso 5 — Aplicar 2FN: descomponer en 4 tablas

Ejecuta cada bloque y verifica el resultado antes de continuar:

```sql
-- ============================================================
-- PASO 5.1: Crear tabla products
-- ============================================================
CREATE TABLE products (
    product_id       VARCHAR(10)  NOT NULL,
    product_name     VARCHAR(100) NOT NULL,
    product_category VARCHAR(80)  NOT NULL,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_products PRIMARY KEY (product_id)
);

INSERT INTO products (product_id, product_name, product_category)
SELECT DISTINCT product_id, product_name, product_category
FROM orders_raw;

SELECT * FROM products ORDER BY product_id;
```

```sql
-- ============================================================
-- PASO 5.2: Crear tabla orders (datos del pedido completo)
-- ============================================================
CREATE TABLE orders (
    order_id    VARCHAR(10)  NOT NULL,
    customer_id VARCHAR(10)  NOT NULL,
    order_date  DATE         NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer_id
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (order_id, customer_id, order_date)
SELECT DISTINCT order_id, customer_id, order_date
FROM orders_raw;

SELECT * FROM orders ORDER BY order_id;
```

```sql
-- ============================================================
-- PASO 5.3: Crear tabla order_items (solo FDs completas)
-- ============================================================
CREATE TABLE order_items (
    order_id              VARCHAR(10)    NOT NULL,
    product_id            VARCHAR(10)    NOT NULL,
    order_item_quantity   SMALLINT       NOT NULL,
    order_item_unit_price NUMERIC(10, 2) NOT NULL,

    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_order_id
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product_id
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT ck_order_items_quantity
        CHECK (order_item_quantity > 0),
    CONSTRAINT ck_order_items_price
        CHECK (order_item_unit_price >= 0)
);

INSERT INTO order_items (order_id, product_id, order_item_quantity, order_item_unit_price)
SELECT order_id, product_id, quantity, unit_price
FROM orders_raw;

SELECT * FROM order_items ORDER BY order_id, product_id;
```

---

## Paso 6 — Verificar la integridad del modelo

Ejecuta estas consultas para confirmar que el modelo 2FN es equivalente al original:

```sql
-- Reconstruir la vista original desde las 4 tablas
SELECT
    oi.order_id,
    oi.product_id,
    o.order_date,
    c.customer_id,
    c.customer_name,
    c.customer_email,
    p.product_name,
    p.product_category,
    oi.order_item_quantity   AS quantity,
    oi.order_item_unit_price AS unit_price
FROM order_items oi
JOIN orders   o ON o.order_id    = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
JOIN products  p ON p.product_id  = oi.product_id
ORDER BY oi.order_id, oi.product_id;

-- Comparar con la tabla original (los resultados deben coincidir)
SELECT order_id, product_id, customer_id, customer_name, customer_email,
       product_name, product_category, quantity, unit_price, order_date
FROM orders_raw
ORDER BY order_id, product_id;
```

```sql
-- Total de cada pedido (ahora fácil de calcular)
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    SUM(oi.order_item_quantity * oi.order_item_unit_price) AS order_total
FROM orders o
JOIN customers  c  ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id  = o.order_id
GROUP BY o.order_id, c.customer_name, o.order_date
ORDER BY o.order_date;
```

---

## Paso 7 — Reflexión

Responde las siguientes preguntas en tu cuaderno o un archivo de texto:

1. **Anomalía de actualización:** Antes del cambio, ¿cuántas filas habría que
   actualizar si Ana López cambia su email? ¿Y después?

2. **Anomalía de inserción:** En `orders_raw`, ¿puedo registrar un nuevo producto
   sin que haya un pedido? ¿Y en la tabla `products` del modelo 2FN?

3. **Anomalía de borrado:** Si elimino todas las filas del pedido `o-002` de
   `orders_raw`, ¿qué información pierdo? ¿Ocurre lo mismo en el modelo 2FN?

4. **Límite de 2FN:** En la tabla `orders` del modelo 2FN, ¿existe todavía alguna
   dependencia funcional problemática? Pista: revisa `customer_id → customer_name`.

5. **Diseño:** ¿Por qué `order_items` mantiene `order_item_unit_price` en lugar de
   obtenerlo siempre de `products.product_price`? ¿Qué problema de negocio resuelve?

---

## Resumen del modelo final (2FN)

```
customers          products
──────────         ──────────
customer_id PK     product_id PK
customer_name      product_name
customer_email     product_category
created_at         created_at
      │                   │
      │ FK                │ FK
      ▼                   ▼
    orders         order_items
    ──────         ───────────────────
    order_id PK    order_id    FK+PK ──→ orders
    customer_id FK product_id  FK+PK ──→ products
    order_date     order_item_quantity
    created_at     order_item_unit_price

customer_phones
───────────────
phone_id PK
customer_id FK ──→ customers
phone_number
phone_type
created_at
```

> **¿Qué sigue?** En la Semana 08 aplicaremos **3FN** para eliminar la
> dependencia transitiva `order_id → customer_id → customer_name`,
> y también estudiaremos la Forma Normal de Boyce-Codd (FNBC).

---

← [README](../README.md) | Semana 08 →
