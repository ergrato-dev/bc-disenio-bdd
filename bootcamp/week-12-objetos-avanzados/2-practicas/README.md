# Práctica: Auditoría Automática con Triggers

## Objetivos

Al finalizar esta práctica serás capaz de:

- Diseñar e implementar una tabla de auditoría genérica con `JSONB`
- Crear funciones PL/pgSQL que operan como triggers de auditoría
- Crear vistas simples y materializadas sobre un esquema existente
- Escribir funciones y procedimientos para encapsular lógica de negocio
- Usar `SAVEPOINT` para gestionar rollbacks parciales dentro de una transacción

**Tiempo estimado:** 3 horas  
**Herramienta:** pgAdmin 4, DBeaver o psql  
**Base de datos:** Usa la misma que creaste en la práctica de la Semana 10

---

## Esquema de Referencia

Trabajaremos con el esquema `shophub` de la Semana 10. Si no tienes la base
de datos disponible, ejecuta primero este bloque para crear las tablas mínimas:

```sql
-- ============================================================
-- ESQUEMA BASE: ShopHub (referencia semana 10)
-- Ejecuta este bloque solo si no tienes el esquema previo
-- ============================================================

-- CREATE SCHEMA IF NOT EXISTS shophub;
-- SET search_path = shophub;

-- CREATE TABLE IF NOT EXISTS customers (
--     customer_id    UUID         NOT NULL DEFAULT gen_random_uuid(),
--     customer_name  VARCHAR(100) NOT NULL,
--     customer_email VARCHAR(150) NOT NULL,
--     is_active      BOOLEAN      NOT NULL DEFAULT TRUE,
--     created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
--     updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_customers PRIMARY KEY (customer_id),
--     CONSTRAINT uq_customers_email UNIQUE (customer_email)
-- );

-- CREATE TABLE IF NOT EXISTS products (
--     product_id     UUID          NOT NULL DEFAULT gen_random_uuid(),
--     product_name   VARCHAR(200)  NOT NULL,
--     product_price  NUMERIC(10,2) NOT NULL CHECK (product_price >= 0),
--     product_stock  INTEGER       NOT NULL DEFAULT 0 CHECK (product_stock >= 0),
--     is_active      BOOLEAN       NOT NULL DEFAULT TRUE,
--     created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
--     updated_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_products PRIMARY KEY (product_id)
-- );

-- CREATE TABLE IF NOT EXISTS orders (
--     order_id     UUID          NOT NULL DEFAULT gen_random_uuid(),
--     customer_id  UUID          NOT NULL,
--     order_status VARCHAR(20)   NOT NULL DEFAULT 'pending',
--     order_total  NUMERIC(12,2) NOT NULL DEFAULT 0,
--     created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
--     updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_orders      PRIMARY KEY (order_id),
--     CONSTRAINT fk_orders_customer_id FOREIGN KEY (customer_id)
--         REFERENCES customers (customer_id) ON DELETE RESTRICT
-- );

-- CREATE TABLE IF NOT EXISTS order_items (
--     order_item_id       UUID          NOT NULL DEFAULT gen_random_uuid(),
--     order_id            UUID          NOT NULL,
--     product_id          UUID          NOT NULL,
--     order_item_quantity SMALLINT      NOT NULL CHECK (order_item_quantity > 0),
--     order_item_price    NUMERIC(10,2) NOT NULL CHECK (order_item_price >= 0),
--     CONSTRAINT pk_order_items  PRIMARY KEY (order_item_id),
--     CONSTRAINT fk_order_items_order   FOREIGN KEY (order_id)
--         REFERENCES orders (order_id) ON DELETE CASCADE,
--     CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
--         REFERENCES products (product_id) ON DELETE RESTRICT
-- );
```

---

## Paso 1 — Tabla de Auditoría Genérica

Creamos una tabla que registrará cambios de cualquier tabla del esquema.
El campo `JSONB` permite guardar el estado completo de la fila antes y
después de la operación.

```sql
-- ============================================================
-- PASO 1: Crear la tabla de auditoría
-- ============================================================

-- CREATE TABLE audit_log (
--     audit_log_id    UUID        NOT NULL DEFAULT gen_random_uuid(),
--     audit_table     TEXT        NOT NULL,
--     audit_operation TEXT        NOT NULL
--         CHECK (audit_operation IN ('INSERT', 'UPDATE', 'DELETE')),
--     audit_old_data  JSONB,
--     audit_new_data  JSONB,
--     audit_user      TEXT        NOT NULL DEFAULT current_user,
--     audit_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_audit_log PRIMARY KEY (audit_log_id)
-- );

-- CREATE INDEX ix_audit_log_table_at
--     ON audit_log (audit_table, audit_at DESC);
```

Observa que:
- `audit_old_data` puede ser `NULL` (en un `INSERT` no hay estado previo)
- `audit_new_data` puede ser `NULL` (en un `DELETE` no hay estado nuevo)
- El índice compuesto `(audit_table, audit_at DESC)` acelera consultas como
  "todos los cambios en `orders` de los últimos 7 días"

---

## Paso 2 — Función Trigger de Auditoría

Una sola función trigger puede utilizarse en múltiples tablas gracias a las
variables especiales `TG_TABLE_NAME` y `TG_OP` que PostgreSQL inyecta
automáticamente:

```sql
-- ============================================================
-- PASO 2: Función trigger genérica
-- ============================================================

-- CREATE OR REPLACE FUNCTION fn_trg_generic_audit()
-- RETURNS TRIGGER
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
--     INSERT INTO audit_log (
--         audit_table,
--         audit_operation,
--         audit_old_data,
--         audit_new_data
--     ) VALUES (
--         TG_TABLE_NAME,
--         TG_OP,
--         CASE WHEN TG_OP = 'INSERT' THEN NULL ELSE row_to_json(OLD) END,
--         CASE WHEN TG_OP = 'DELETE' THEN NULL ELSE row_to_json(NEW) END
--     );
--
--     -- En triggers AFTER:
--     --  INSERT / UPDATE → retornar NEW
--     --  DELETE          → retornar OLD
--     RETURN NEW;
-- END;
-- $$;
```

---

## Paso 3 — Crear Triggers en orders y products

```sql
-- ============================================================
-- PASO 3: Adjuntar el trigger a las tablas
-- ============================================================

-- Trigger en orders (INSERT, UPDATE, DELETE):
-- CREATE TRIGGER trg_orders_after_dml
--     AFTER INSERT OR UPDATE OR DELETE
--     ON orders
--     FOR EACH ROW
--     EXECUTE FUNCTION fn_trg_generic_audit();

-- Trigger en products (solo UPDATE):
-- CREATE TRIGGER trg_products_after_update
--     AFTER UPDATE
--     ON products
--     FOR EACH ROW
--     EXECUTE FUNCTION fn_trg_generic_audit();
```

Prueba el trigger insertando y actualizando una orden. Luego consulta
`audit_log` para verificar que los registros se crearon:

```sql
-- Verificar los registros de auditoría:

-- SELECT
--     audit_table,
--     audit_operation,
--     audit_old_data,
--     audit_new_data,
--     audit_user,
--     audit_at
-- FROM audit_log
-- ORDER BY audit_at DESC
-- LIMIT 10;
```

---

## Paso 4 — Vista Simple: Órdenes por Estado

Creamos una vista que resumen las métricas de órdenes agrupadas por estado:

```sql
-- ============================================================
-- PASO 4: Vista simple vw_orders_by_status
-- ============================================================

-- CREATE OR REPLACE VIEW vw_orders_by_status AS
-- SELECT
--     o.order_status,
--     COUNT(*)          AS total_orders,
--     SUM(o.order_total) AS total_revenue,
--     AVG(o.order_total) AS avg_order_value,
--     MIN(o.created_at)  AS oldest_order,
--     MAX(o.created_at)  AS newest_order
-- FROM orders AS o
-- GROUP BY o.order_status
-- ORDER BY total_orders DESC;

-- Consultar la vista:
-- SELECT * FROM vw_orders_by_status;
```

---

## Paso 5 — Vista Materializada: Ventas Mensuales

```sql
-- ============================================================
-- PASO 5: Vista materializada mvw_monthly_sales
-- ============================================================

-- CREATE MATERIALIZED VIEW mvw_monthly_sales AS
-- SELECT
--     DATE_TRUNC('month', o.created_at)   AS sale_month,
--     COUNT(*)                             AS total_orders,
--     COUNT(DISTINCT o.customer_id)        AS unique_customers,
--     SUM(o.order_total)                   AS total_revenue,
--     AVG(o.order_total)                   AS avg_order_value
-- FROM orders AS o
-- WHERE o.order_status = 'delivered'
-- GROUP BY DATE_TRUNC('month', o.created_at)
-- ORDER BY sale_month DESC
-- WITH DATA;

-- Crear el índice UNIQUE necesario para REFRESH CONCURRENTLY:
-- CREATE UNIQUE INDEX uq_mvw_monthly_sales_month
--     ON mvw_monthly_sales (sale_month);

-- Refrescar sin bloquear:
-- REFRESH MATERIALIZED VIEW CONCURRENTLY mvw_monthly_sales;

-- Consultar:
-- SELECT * FROM mvw_monthly_sales LIMIT 12;
```

---

## Paso 6 — Función: Calcular Total de Orden

```sql
-- ============================================================
-- PASO 6: Función fn_calculate_order_total
-- ============================================================

-- CREATE OR REPLACE FUNCTION fn_calculate_order_total(
--     p_order_id UUID
-- )
-- RETURNS NUMERIC(12,2)
-- LANGUAGE plpgsql STABLE
-- AS $$
-- DECLARE
--     v_total NUMERIC(12,2);
-- BEGIN
--     SELECT COALESCE(SUM(oi.order_item_price * oi.order_item_quantity), 0)
--       INTO v_total
--       FROM order_items AS oi
--      WHERE oi.order_id = p_order_id;
--
--     RETURN v_total;
-- END;
-- $$;

-- Probar la función:
-- SELECT
--     o.order_id,
--     o.order_total                        AS total_guardado,
--     fn_calculate_order_total(o.order_id) AS total_calculado
-- FROM orders AS o
-- LIMIT 5;
```

---

## Paso 7 — Procedimiento: Cancelar Orden

```sql
-- ============================================================
-- PASO 7: Procedimiento sp_cancel_order
-- ============================================================

-- CREATE OR REPLACE PROCEDURE sp_cancel_order(
--     p_order_id UUID,
--     p_reason   TEXT DEFAULT 'Cancelación solicitada por el sistema'
-- )
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
--     v_status VARCHAR(20);
-- BEGIN
--     SELECT order_status INTO v_status
--     FROM   orders
--     WHERE  order_id = p_order_id
--     FOR UPDATE;
--
--     IF v_status IS NULL THEN
--         RAISE EXCEPTION 'Orden % no existe', p_order_id;
--     END IF;
--
--     IF v_status IN ('delivered', 'cancelled') THEN
--         RAISE EXCEPTION 'No se puede cancelar orden con estado "%"', v_status;
--     END IF;
--
--     UPDATE orders
--        SET order_status = 'cancelled',
--            updated_at   = NOW()
--      WHERE order_id     = p_order_id;
--
--     RAISE NOTICE 'Orden % cancelada. Razón: %', p_order_id, p_reason;
--     COMMIT;
-- END;
-- $$;

-- Ejecutar con CALL:
-- CALL sp_cancel_order('...uuid...', 'Cliente solicitó reembolso');
```

---

## Paso 8 — Transacción con SAVEPOINT

Este paso demuestra el uso de `SAVEPOINT` para hacer rollback parcial
dentro de una transacción. Ejecuta cada sección de forma secuencial
y observa el estado de la base de datos en cada paso:

```sql
-- ============================================================
-- PASO 8: Transacción con SAVEPOINT
-- ============================================================

-- -- Preparar datos de prueba:
-- INSERT INTO customers (customer_name, customer_email)
-- VALUES ('Test SAVEPOINTs', 'savepoint@test.com');

-- -- Guardar el UUID del cliente:
-- -- (reemplaza el UUID en los pasos siguientes)
-- SELECT customer_id FROM customers WHERE customer_email = 'savepoint@test.com';


-- BEGIN;

--     -- Insertar la orden
--     INSERT INTO orders (customer_id, order_status, order_total)
--     VALUES ('...uuid_customer...', 'pending', 0);

--     -- Guardar el UUID de la orden:
--     -- SELECT order_id FROM orders WHERE customer_id = '...uuid_customer...'
--     --   ORDER BY created_at DESC LIMIT 1;

--     SAVEPOINT sp_order_created;

--     -- Intentar insertar ítems (si alguno falla, solo deshacemos desde sp_order_created)
--     INSERT INTO order_items (order_id, product_id, order_item_quantity, order_item_price)
--     VALUES ('...uuid_order...', '...uuid_product...', 2, 49.99);

--     SAVEPOINT sp_items_inserted;

--     -- Simular un error: producto con UUID inválido
--     -- INSERT INTO order_items (order_id, product_id, order_item_quantity, order_item_price)
--     -- VALUES ('...uuid_order...', '00000000-0000-0000-0000-000000000000', 1, 9.99);

--     -- Si el paso anterior falla, hacer rollback solo de los ítems:
--     -- ROLLBACK TO SAVEPOINT sp_order_created;

--     -- Actualizar el total de la orden
--     UPDATE orders SET order_total = fn_calculate_order_total('...uuid_order...')
--     WHERE order_id = '...uuid_order...';

-- COMMIT;


-- Verificar el resultado:
-- SELECT * FROM orders    WHERE customer_id = '...uuid_customer...';
-- SELECT * FROM order_items WHERE order_id  = '...uuid_order...';
-- SELECT * FROM audit_log  ORDER BY audit_at DESC LIMIT 5;
```

---

← [README de la semana](../README.md) | → [Proyecto](../3-proyecto/README.md)
