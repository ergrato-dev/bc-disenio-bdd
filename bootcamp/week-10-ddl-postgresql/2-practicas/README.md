# Práctica: ShopHub DDL — Implementación Física Completa

## Objetivo

Tomar el modelo de datos de ShopHub que diseñamos en la Semana 09 (con
restricciones de integridad) e implementarlo como un script DDL profesional
y completo en PostgreSQL 16, aplicando la guía de selección de tipos de datos.

**Duración estimada:** 3 horas  
**Prerequisito:** Haber completado las semanas 09 (restricciones) y leer
los tres archivos de teoría de esta semana.

---

## Contexto: ShopHub

ShopHub es una plataforma de e-commerce con las siguientes entidades
(ya conocidas de semanas anteriores):

| Tabla            | Descripción                                         |
|------------------|-----------------------------------------------------|
| `customers`      | Clientes registrados en la plataforma               |
| `addresses`      | Direcciones de los clientes (múltiples por cliente) |
| `categories`     | Árbol de categorías de productos                    |
| `products`       | Catálogo de productos                               |
| `product_images` | Imágenes de cada producto                           |
| `orders`         | Pedidos realizados por clientes                     |
| `order_items`    | Líneas de detalle de cada pedido                    |
| `reviews`        | Valoraciones de productos por clientes              |

---

## Paso 1: Crear el Schema y Establecer search_path

El schema `shophub` agrupa todos los objetos de la plataforma y evita
colisiones con objetos de otros proyectos en la misma base de datos.

Ejecuta el siguiente bloque en pgAdmin o DBeaver:

```sql
-- ============================================================
-- PASO 1: Schema y search_path
-- Patrón idempotente — seguro para ejecutar múltiples veces
-- ============================================================

BEGIN;

CREATE SCHEMA IF NOT EXISTS shophub;

SET search_path = shophub;

COMMIT;
```

Verifica que el schema se creó:

```sql
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'shophub';
```

---

## Paso 2: Revisión Tipo a Tipo

Antes de escribir el DDL, revisamos qué tipo de dato corresponde a cada
columna, aplicando la guía de la Semana 10:

| Columna              | Tipo seleccionado     | Justificación                              |
|----------------------|-----------------------|--------------------------------------------|
| `customer_id`        | `UUID`                | PK interna, no visible al cliente          |
| `customer_name`      | `VARCHAR(100)`        | Texto con longitud máxima razonable        |
| `customer_email`     | `VARCHAR(150)`        | Longitud máxima RFC 5321                   |
| `customer_phone`     | `VARCHAR(20)`         | Incluye prefijo internacional              |
| `is_active`          | `BOOLEAN`             | Flag binario                               |
| `created_at`         | `TIMESTAMPTZ`         | Evento con zona horaria                    |
| `product_price`      | `NUMERIC(10, 2)`      | Decimal exacto para dinero                 |
| `product_stock`      | `INTEGER`             | Conteo que puede superar 32 767            |
| `order_item_quantity`| `SMALLINT`            | Raramente supera 100 unidades              |
| `review_rating`      | `SMALLINT`            | Entero 1–5, rango pequeño                  |
| `address_zip`        | `VARCHAR(12)`         | Códigos postales son alfanuméricos         |
| `country_code`       | `CHAR(2)`             | Siempre exactamente 2 caracteres (ISO)     |

---

## Paso 3: Crear Tablas sin FKs (Orden Topológico)

Crea primero las tablas que no dependen de otras:

```sql
-- ============================================================
-- PASO 3: Tablas base (sin FK)
-- ============================================================

-- Categorías (auto-referencial — se crea sola primero)
CREATE TABLE IF NOT EXISTS shophub.categories (
    category_id     UUID            NOT NULL DEFAULT gen_random_uuid(),
    category_name   VARCHAR(80)     NOT NULL,
    parent_id       UUID,           -- FK auto-ref — se agrega en paso 4
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_categories PRIMARY KEY (category_id),
    CONSTRAINT uq_categories_name UNIQUE (category_name)
);

-- Clientes
CREATE TABLE IF NOT EXISTS shophub.customers (
    customer_id         UUID            NOT NULL DEFAULT gen_random_uuid(),
    customer_name       VARCHAR(100)    NOT NULL,
    customer_email      VARCHAR(150)    NOT NULL,
    customer_phone      VARCHAR(20),
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_customers         PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_email   UNIQUE (customer_email),
    CONSTRAINT ck_customers_email   CHECK (customer_email LIKE '%@%.%')
);

-- Productos
CREATE TABLE IF NOT EXISTS shophub.products (
    product_id          UUID            NOT NULL DEFAULT gen_random_uuid(),
    category_id         UUID            NOT NULL, -- FK → categories (paso 4)
    product_name        VARCHAR(200)    NOT NULL,
    product_description TEXT,
    product_price       NUMERIC(10, 2)  NOT NULL,
    product_stock       INTEGER         NOT NULL DEFAULT 0,
    product_sku         VARCHAR(40)     NOT NULL,
    is_active           BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_products              PRIMARY KEY (product_id),
    CONSTRAINT uq_products_sku          UNIQUE (product_sku),
    CONSTRAINT ck_products_price_pos    CHECK (product_price >= 0),
    CONSTRAINT ck_products_stock_nn_neg CHECK (product_stock >= 0)
);
```

Observa el patrón `CREATE TABLE IF NOT EXISTS` — el script puede ejecutarse
dos veces sin error.

---

## Paso 4: Agregar FKs con ALTER TABLE

Separar la creación de tablas y las FK permite manejar dependencias
circulares y es más fácil de leer en scripts de migración:

```sql
-- ============================================================
-- PASO 4: Foreign Keys
-- ============================================================

-- Dirección de los clientes
CREATE TABLE IF NOT EXISTS shophub.addresses (
    address_id      UUID            NOT NULL DEFAULT gen_random_uuid(),
    customer_id     UUID            NOT NULL,
    address_line1   VARCHAR(200)    NOT NULL,
    address_line2   VARCHAR(200),
    address_city    VARCHAR(100)    NOT NULL,
    address_state   VARCHAR(100),
    address_zip     VARCHAR(12)     NOT NULL,
    country_code    CHAR(2)         NOT NULL DEFAULT 'CO',
    is_default      BOOLEAN         NOT NULL DEFAULT FALSE,

    CONSTRAINT pk_addresses PRIMARY KEY (address_id)
);

ALTER TABLE shophub.addresses
    ADD CONSTRAINT fk_addresses_customer_id
        FOREIGN KEY (customer_id)
        REFERENCES shophub.customers (customer_id)
        ON DELETE CASCADE;

-- FK auto-referencial de categories
ALTER TABLE shophub.categories
    ADD CONSTRAINT fk_categories_parent_id
        FOREIGN KEY (parent_id)
        REFERENCES shophub.categories (category_id)
        ON DELETE SET NULL;

-- FK de productos → categorías
ALTER TABLE shophub.products
    ADD CONSTRAINT fk_products_category_id
        FOREIGN KEY (category_id)
        REFERENCES shophub.categories (category_id)
        ON DELETE RESTRICT;

-- Imágenes de producto
CREATE TABLE IF NOT EXISTS shophub.product_images (
    image_id        UUID            NOT NULL DEFAULT gen_random_uuid(),
    product_id      UUID            NOT NULL,
    image_url       TEXT            NOT NULL,
    image_order     SMALLINT        NOT NULL DEFAULT 1,
    is_primary      BOOLEAN         NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_product_images        PRIMARY KEY (image_id),
    CONSTRAINT ck_product_images_order  CHECK (image_order > 0),
    CONSTRAINT fk_product_images_product_id
        FOREIGN KEY (product_id)
        REFERENCES shophub.products (product_id)
        ON DELETE CASCADE
);

-- Pedidos
CREATE TABLE IF NOT EXISTS shophub.orders (
    order_id            UUID            NOT NULL DEFAULT gen_random_uuid(),
    customer_id         UUID            NOT NULL,
    shipping_address_id UUID,
    order_status        VARCHAR(20)     NOT NULL DEFAULT 'pending',
    order_total         NUMERIC(12, 2)  NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_orders                    PRIMARY KEY (order_id),
    CONSTRAINT ck_orders_status             CHECK (order_status IN
        ('pending','confirmed','processing','shipped','delivered','cancelled','refunded')),
    CONSTRAINT ck_orders_total_positive     CHECK (order_total >= 0),
    CONSTRAINT fk_orders_customer_id
        FOREIGN KEY (customer_id)
        REFERENCES shophub.customers (customer_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_orders_shipping_address
        FOREIGN KEY (shipping_address_id)
        REFERENCES shophub.addresses (address_id)
        ON DELETE SET NULL
);

-- Líneas de pedido
CREATE TABLE IF NOT EXISTS shophub.order_items (
    order_item_id       UUID            NOT NULL DEFAULT gen_random_uuid(),
    order_id            UUID            NOT NULL,
    product_id          UUID            NOT NULL,
    order_item_quantity SMALLINT        NOT NULL,
    order_item_price    NUMERIC(10, 2)  NOT NULL,

    CONSTRAINT pk_order_items               PRIMARY KEY (order_item_id),
    CONSTRAINT uq_order_items               UNIQUE (order_id, product_id),
    CONSTRAINT ck_order_items_qty_pos       CHECK (order_item_quantity > 0),
    CONSTRAINT ck_order_items_price_pos     CHECK (order_item_price >= 0),
    CONSTRAINT fk_order_items_order_id
        FOREIGN KEY (order_id)
        REFERENCES shophub.orders (order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product_id
        FOREIGN KEY (product_id)
        REFERENCES shophub.products (product_id)
        ON DELETE RESTRICT
);

-- Reseñas
CREATE TABLE IF NOT EXISTS shophub.reviews (
    review_id       UUID            NOT NULL DEFAULT gen_random_uuid(),
    product_id      UUID            NOT NULL,
    customer_id     UUID            NOT NULL,
    review_rating   SMALLINT        NOT NULL,
    review_body     TEXT,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_reviews               PRIMARY KEY (review_id),
    CONSTRAINT uq_reviews               UNIQUE (product_id, customer_id),
    CONSTRAINT ck_reviews_rating        CHECK (review_rating BETWEEN 1 AND 5),
    CONSTRAINT fk_reviews_product_id
        FOREIGN KEY (product_id)
        REFERENCES shophub.products (product_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_reviews_customer_id
        FOREIGN KEY (customer_id)
        REFERENCES shophub.customers (customer_id)
        ON DELETE RESTRICT
);
```

---

## Paso 5: Crear Índices en Columnas FK

PostgreSQL **no crea índices automáticamente** en las columnas FK. Sin
índices, los JOIN y DELETE en cascada serán lentos:

```sql
-- ============================================================
-- PASO 5: Índices en columnas FK y búsquedas frecuentes
-- ============================================================

-- addresses
CREATE INDEX IF NOT EXISTS ix_addresses_customer_id
    ON shophub.addresses (customer_id);

-- products
CREATE INDEX IF NOT EXISTS ix_products_category_id
    ON shophub.products (category_id);

-- product_images
CREATE INDEX IF NOT EXISTS ix_product_images_product_id
    ON shophub.product_images (product_id);

-- orders — índices frecuentemente consultados
CREATE INDEX IF NOT EXISTS ix_orders_customer_id
    ON shophub.orders (customer_id);

CREATE INDEX IF NOT EXISTS ix_orders_created_at
    ON shophub.orders (created_at DESC);

-- order_items
CREATE INDEX IF NOT EXISTS ix_order_items_order_id
    ON shophub.order_items (order_id);

CREATE INDEX IF NOT EXISTS ix_order_items_product_id
    ON shophub.order_items (product_id);

-- reviews
CREATE INDEX IF NOT EXISTS ix_reviews_product_id
    ON shophub.reviews (product_id);
```

---

## Paso 6: Datos de Prueba

```sql
-- ============================================================
-- PASO 6: Datos de prueba realistas
-- ============================================================

-- Categorías
INSERT INTO shophub.categories (category_name, parent_id) VALUES
    ('Electronics', NULL),
    ('Clothing',    NULL),
    ('Books',       NULL);

INSERT INTO shophub.categories (category_name, parent_id)
    SELECT 'Smartphones', category_id FROM shophub.categories WHERE category_name = 'Electronics';

INSERT INTO shophub.categories (category_name, parent_id)
    SELECT 'Laptops', category_id FROM shophub.categories WHERE category_name = 'Electronics';

-- Clientes
INSERT INTO shophub.customers (customer_name, customer_email, customer_phone) VALUES
    ('Ana García',      'ana.garcia@email.com',      '+573001234567'),
    ('Carlos López',    'carlos.lopez@email.com',    '+573009876543'),
    ('María Hernández', 'maria.h@email.com',         NULL);

-- Productos
INSERT INTO shophub.products
    (product_name, category_id, product_price, product_stock, product_sku)
SELECT
    'iPhone 15 Pro',
    c.category_id,
    4299000.00,
    15,
    'APPL-IPHONE15P-128'
FROM shophub.categories c
WHERE c.category_name = 'Smartphones';

INSERT INTO shophub.products
    (product_name, category_id, product_price, product_stock, product_sku)
SELECT
    'MacBook Air M3',
    c.category_id,
    6499000.00,
    8,
    'APPL-MBA-M3-8GB'
FROM shophub.categories c
WHERE c.category_name = 'Laptops';
```

---

## Paso 7: Verificación

```sql
-- ============================================================
-- PASO 7: Verificar el esquema creado
-- ============================================================

-- Ver todas las tablas del schema:
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'shophub'
  AND table_type   = 'BASE TABLE'
ORDER BY table_name;

-- Verificar que los índices existen:
SELECT indexname, tablename
FROM pg_indexes
WHERE schemaname = 'shophub'
ORDER BY tablename, indexname;

-- Contar objetos por tabla:
SELECT
    'customers'    AS tabla, COUNT(*) FROM shophub.customers
UNION ALL SELECT
    'categories',           COUNT(*) FROM shophub.categories
UNION ALL SELECT
    'products',             COUNT(*) FROM shophub.products;

-- Query de prueba con JOIN:
SELECT
    p.product_name,
    c.category_name,
    p.product_price,
    p.product_stock
FROM shophub.products    AS p
JOIN shophub.categories  AS c ON c.category_id = p.category_id
ORDER BY p.product_name;
```

---

## Reflexión Final

Compara el DDL que escribiste hoy con el `ALTER TABLE` de la semana 09:

- ¿Cuántas decisiones de tipo de dato tuviste que justificar?
- ¿Qué patrón idempotente usaste? ¿Por qué es importante?
- ¿Qué pasaría si ejecutas el script dos veces seguidas?
- ¿En qué orden deben ejecutarse las tablas y por qué?

---

← [README](../README.md) | → [Proyecto: TaskFlow](../3-proyecto/README.md)
