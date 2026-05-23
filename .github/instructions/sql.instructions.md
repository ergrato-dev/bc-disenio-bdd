---
applyTo: "**/*.sql"
---

# Convenciones SQL — Bootcamp Diseño de Bases de Datos Relacionales

## Sintaxis general

- Usa siempre **PostgreSQL 16+** como dialecto objetivo
- Keywords SQL en **MAYÚSCULAS**: `SELECT`, `CREATE TABLE`, `NOT NULL`, `REFERENCES`, etc.
- Identificadores (tablas, columnas, constraints) en **snake_case minúsculas**
- Indentación: 4 espacios; alinea columnas y constraints verticalmente

## Tablas

```sql
-- ✅ CORRECTO
CREATE TABLE order_items (
    id              BIGINT          GENERATED ALWAYS AS IDENTITY
                                    CONSTRAINT pk_order_items PRIMARY KEY,
    order_id        BIGINT          NOT NULL,
    product_id      BIGINT          NOT NULL,
    quantity        SMALLINT        NOT NULL
                                    CONSTRAINT ck_order_items_quantity_pos CHECK (quantity > 0),
    unit_price      NUMERIC(10, 2)  NOT NULL
                                    CONSTRAINT ck_order_items_price_nneg CHECK (unit_price >= 0),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_order_items_order_id
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product_id
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

-- ❌ INCORRECTO — sin constraints nombrados, tipos inadecuados, sin NOT NULL explícito
CREATE TABLE items (id serial pk, oid int, pid int, qty int, price float);
```

## Tipos de datos — usar siempre el tipo más preciso

| Caso de uso        | ✅ Usar                               | ❌ Evitar                               |
| ------------------ | ------------------------------------- | --------------------------------------- |
| PK autoincremental | `BIGINT GENERATED ALWAYS AS IDENTITY` | `SERIAL`, `INT`                         |
| Texto corto        | `VARCHAR(n)`                          | `TEXT` para campos acotados             |
| Texto libre        | `TEXT`                                | `VARCHAR` sin límite real               |
| Fecha + hora       | `TIMESTAMPTZ`                         | `TIMESTAMP`, `DATETIME`                 |
| Solo fecha         | `DATE`                                | `VARCHAR` para fechas                   |
| Decimal exacto     | `NUMERIC(p, s)`                       | `FLOAT`, `DOUBLE PRECISION` para dinero |
| Entero pequeño     | `SMALLINT`                            | `INTEGER` para contadores < 32k         |
| Booleano           | `BOOLEAN`                             | `SMALLINT`, `CHAR(1)`, `INTEGER`        |
| UUID               | `UUID` con `gen_random_uuid()`        | `VARCHAR(36)`                           |
| JSON estructurado  | `JSONB`                               | `JSON`, `TEXT`                          |

## Naming conventions — obligatorias

| Objeto        | Patrón                       | Ejemplo                             |
| ------------- | ---------------------------- | ----------------------------------- |
| Tabla         | `snake_case` plural inglés   | `order_items`, `product_categories` |
| Columna       | `snake_case` singular inglés | `user_id`, `created_at`             |
| PK            | `pk_tabla`                   | `pk_order_items`                    |
| FK            | `fk_tabla_columna`           | `fk_orders_customer_id`             |
| UNIQUE        | `uq_tabla_columna`           | `uq_users_email`                    |
| CHECK         | `ck_tabla_descripcion`       | `ck_products_price_pos`             |
| Índice        | `ix_tabla_columna`           | `ix_orders_created_at`              |
| Vista         | `vw_nombre`                  | `vw_active_users`                   |
| Función       | `fn_verbo_sustantivo`        | `fn_calculate_total`                |
| Procedimiento | `sp_verbo_sustantivo`        | `sp_create_order`                   |
| Trigger       | `trg_tabla_evento`           | `trg_users_before_update`           |

## Constraints — reglas

- Declarar `NOT NULL` explícitamente en **toda** columna que lo requiera
- Definir **siempre** `ON DELETE` y `ON UPDATE` en FOREIGN KEY
- Nombres de constraints **siempre explícitos** — nunca dejar que PostgreSQL los genere
- Preferir constraints inline para columnas simples, y de tabla para FK o multi-columna

## Comentarios en SQL

```sql
-- Comentarios de bloque: describe QUÉ hace la sección y POR QUÉ
-- ============================================
-- PASO 1: Crear tabla base de usuarios
-- Separamos datos de autenticación de datos de perfil
-- para minimizar la superficie expuesta en consultas públicas
-- ============================================

-- Comentarios de columna: explica decisiones de diseño no obvias
deleted_at  TIMESTAMPTZ  NULL,  -- NULL = activo; NOT NULL = eliminado (soft delete)
```

- Comentarios educativos: **en español**
- Nombre de objetos de BD: **en inglés**
- No comentar lo obvio (`-- Crear tabla` encima de `CREATE TABLE`)

## Estilo de consultas SELECT

```sql
-- ✅ BIEN — legible, alineado, con alias
SELECT
    u.id,
    u.email,
    p.full_name,
    COUNT(o.id)     AS total_orders,
    SUM(o.total)    AS lifetime_value
FROM  users         AS u
JOIN  profiles      AS p  ON p.user_id    = u.id
LEFT JOIN orders    AS o  ON o.customer_id = u.id
WHERE u.is_active = TRUE
  AND u.deleted_at IS NULL
GROUP BY u.id, u.email, p.full_name
ORDER BY lifetime_value DESC NULLS LAST;
```

## Datos de prueba (INSERT)

```sql
-- ✅ BIEN — columnas explícitas siempre, valores realistas
INSERT INTO users (email, full_name, is_active)
VALUES
    ('alice@example.com',  'Alice Johnson', TRUE),
    ('bob@example.com',    'Bob Smith',     TRUE),
    ('carol@example.com',  'Carol White',   FALSE);

-- ❌ MAL — sin columnas explícitas (frágil ante cambios de esquema)
INSERT INTO users VALUES (1, 'alice@example.com', 'Alice Johnson', TRUE, NOW());
```
