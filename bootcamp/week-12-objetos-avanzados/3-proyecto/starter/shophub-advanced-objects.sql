-- ============================================================
-- PROYECTO SEMANA 12: ShopHub — Capa de Objetos Avanzados
-- Archivo: shophub-advanced-objects.sql
-- Base de datos: PostgreSQL 16+
-- Instrucciones: Lee cada sección, completa los TODOs y
--   ejecuta el script completo en pgAdmin o DBeaver.
-- ============================================================


-- ============================================================
-- PARTE 0: Esquema base ShopHub (referencia semana 10)
-- Descomenta y ejecuta si no tienes el esquema previo
-- ============================================================

-- SET search_path = public;

-- CREATE TABLE IF NOT EXISTS customers (
--     customer_id    UUID         NOT NULL DEFAULT gen_random_uuid(),
--     customer_name  VARCHAR(100) NOT NULL,
--     customer_email VARCHAR(150) NOT NULL,
--     is_active      BOOLEAN      NOT NULL DEFAULT TRUE,
--     created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
--     updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_customers      PRIMARY KEY (customer_id),
--     CONSTRAINT uq_customers_email UNIQUE (customer_email)
-- );

-- CREATE TABLE IF NOT EXISTS categories (
--     category_id   UUID        NOT NULL DEFAULT gen_random_uuid(),
--     category_name VARCHAR(80) NOT NULL,
--     CONSTRAINT pk_categories PRIMARY KEY (category_id)
-- );

-- CREATE TABLE IF NOT EXISTS products (
--     product_id       UUID          NOT NULL DEFAULT gen_random_uuid(),
--     category_id      UUID,
--     product_name     VARCHAR(200)  NOT NULL,
--     product_price    NUMERIC(10,2) NOT NULL CHECK (product_price >= 0),
--     product_stock    INTEGER       NOT NULL DEFAULT 0 CHECK (product_stock >= 0),
--     is_active        BOOLEAN       NOT NULL DEFAULT TRUE,
--     created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
--     updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_products          PRIMARY KEY (product_id),
--     CONSTRAINT fk_products_category FOREIGN KEY (category_id)
--         REFERENCES categories (category_id)
-- );

-- CREATE TABLE IF NOT EXISTS orders (
--     order_id     UUID          NOT NULL DEFAULT gen_random_uuid(),
--     customer_id  UUID          NOT NULL,
--     order_status VARCHAR(20)   NOT NULL DEFAULT 'pending',
--     order_total  NUMERIC(12,2) NOT NULL DEFAULT 0,
--     created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
--     updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_orders             PRIMARY KEY (order_id),
--     CONSTRAINT fk_orders_customer_id FOREIGN KEY (customer_id)
--         REFERENCES customers (customer_id) ON DELETE RESTRICT
-- );

-- CREATE TABLE IF NOT EXISTS order_items (
--     order_item_id       UUID          NOT NULL DEFAULT gen_random_uuid(),
--     order_id            UUID          NOT NULL,
--     product_id          UUID          NOT NULL,
--     order_item_quantity SMALLINT      NOT NULL CHECK (order_item_quantity > 0),
--     order_item_price    NUMERIC(10,2) NOT NULL CHECK (order_item_price >= 0),
--     CONSTRAINT pk_order_items         PRIMARY KEY (order_item_id),
--     CONSTRAINT fk_order_items_order   FOREIGN KEY (order_id)
--         REFERENCES orders (order_id) ON DELETE CASCADE,
--     CONSTRAINT fk_order_items_product FOREIGN KEY (product_id)
--         REFERENCES products (product_id) ON DELETE RESTRICT
-- );


-- ============================================================
-- PARTE 1: Tabla de auditoría (RF-01)
-- ============================================================

-- TODO: Crear la tabla `audit_log` con las siguientes columnas:
--   - audit_log_id    UUID PK con gen_random_uuid()
--   - audit_table     TEXT NOT NULL  (nombre de la tabla afectada)
--   - audit_operation TEXT NOT NULL  con CHECK IN ('INSERT','UPDATE','DELETE')
--   - audit_old_data  JSONB          (estado anterior — NULL en INSERT)
--   - audit_new_data  JSONB          (estado nuevo   — NULL en DELETE)
--   - audit_user      TEXT NOT NULL DEFAULT current_user
--   - audit_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()

-- TODO: Crear el índice ix_audit_log_table_at sobre (audit_table, audit_at DESC)


-- ============================================================
-- PARTE 2: Función trigger de auditoría (RF-01)
-- ============================================================

-- TODO: Crear la función fn_trg_generic_audit()
--   RETURNS TRIGGER, LANGUAGE plpgsql
--   Lógica:
--     - Insertar en audit_log con TG_TABLE_NAME, TG_OP
--     - audit_old_data = row_to_json(OLD) cuando TG_OP != 'INSERT', NULL en INSERT
--     - audit_new_data = row_to_json(NEW) cuando TG_OP != 'DELETE', NULL en DELETE
--     - Retornar NEW

-- TODO: Crear los triggers:
--   trg_orders_after_dml  → AFTER INSERT OR UPDATE OR DELETE ON orders    FOR EACH ROW
--   trg_products_after_update → AFTER UPDATE ON products FOR EACH ROW


-- ============================================================
-- PARTE 3: Vistas simples (RF-02)
-- ============================================================

-- TODO: Crear la vista vw_product_catalog
--   Muestra: product_id, product_name, category_name (JOIN categories, puede ser NULL),
--            product_price, product_stock, is_active
--   Filtro: solo productos activos (is_active = TRUE)

-- TODO: Crear la vista vw_customer_order_summary
--   Por cada customer_id muestra:
--     customer_name, customer_email,
--     total_orders (COUNT), total_spent (SUM order_total),
--     avg_order_value (AVG), last_order_at (MAX created_at)
--   Pista: JOIN customers con orders (LEFT JOIN para incluir clientes sin órdenes)

-- TODO: Crear la vista vw_low_stock
--   Muestra productos con product_stock < 10 que tengan al menos una orden
--   Columnas: product_id, product_name, product_stock, total_units_sold
--   Pista: JOIN products → order_items para obtener total_units_sold (SUM quantity)


-- ============================================================
-- PARTE 4: Vista materializada (RF-02)
-- ============================================================

-- TODO: Crear la vista materializada mvw_monthly_revenue
--   Agrupa las órdenes en estado 'delivered' por mes:
--     sale_month (DATE_TRUNC 'month'), total_orders (COUNT),
--     unique_customers (COUNT DISTINCT), total_revenue (SUM), avg_order_value (AVG)
--   Ordenar por sale_month DESC
--   Crear con WITH DATA

-- TODO: Crear el índice UNIQUE uq_mvw_monthly_revenue_month sobre (sale_month)
--   Este índice es necesario para poder usar REFRESH MATERIALIZED VIEW CONCURRENTLY

-- TODO: Ejecutar REFRESH MATERIALIZED VIEW CONCURRENTLY mvw_monthly_revenue


-- ============================================================
-- PARTE 5: Funciones de negocio (RF-03)
-- ============================================================

-- TODO: Crear la función fn_apply_discount(p_product_id UUID, p_pct NUMERIC)
--   RETURNS NUMERIC(10,2), LANGUAGE plpgsql, STABLE
--   Lógica:
--     - Obtener product_price del producto
--     - Si el producto no existe → RAISE EXCEPTION 'Producto % no existe'
--     - Si p_pct no está entre 0 y 100 → RAISE EXCEPTION 'Porcentaje inválido: %'
--     - Retornar: product_price * (1 - p_pct / 100)

-- TODO: Crear la función fn_get_customer_stats(p_customer_id UUID)
--   RETURNS TABLE (total_orders BIGINT, total_spent NUMERIC, avg_order_value NUMERIC,
--                  first_order_at TIMESTAMPTZ, last_order_at TIMESTAMPTZ)
--   LANGUAGE plpgsql, STABLE
--   Usa RETURN QUERY con SELECT sobre orders filtrando por customer_id

-- TODO: Crear la función fn_validate_stock(p_product_id UUID, p_qty INT)
--   RETURNS BOOLEAN, LANGUAGE plpgsql, STABLE
--   Retorna TRUE si product_stock >= p_qty, FALSE en caso contrario


-- ============================================================
-- PARTE 6: Triggers de integridad (RF-04)
-- ============================================================

-- TODO: Crear la función fn_trg_prevent_negative_price()
--   RETURNS TRIGGER, LANGUAGE plpgsql
--   Si NEW.product_price < 0 → RAISE EXCEPTION 'El precio no puede ser negativo: %'
--   Si no → RETURN NEW

-- TODO: Crear el trigger trg_products_before_update
--   BEFORE UPDATE OF product_price ON products FOR EACH ROW
--   EXECUTE FUNCTION fn_trg_prevent_negative_price()


-- ============================================================
-- PARTE 7: Procedimiento sp_complete_order (RF-05)
-- ============================================================

-- TODO: Crear el procedimiento sp_complete_order(p_order_id UUID)
--   LANGUAGE plpgsql
--   Lógica (todo en una misma transacción):
--   1. Verificar que la orden existe y tiene status 'pending' o 'confirmed'
--      Si no existe → RAISE EXCEPTION; si el status no es válido → RAISE EXCEPTION
--   2. Para cada fila en order_items de esa orden:
--      a. Verificar que hay stock suficiente con fn_validate_stock
--      b. Si no hay stock → RAISE EXCEPTION 'Stock insuficiente para producto %'
--      c. Descontar stock: UPDATE products SET product_stock = product_stock - qty
--   3. Actualizar order_status a 'delivered' y recalcular order_total
--   4. COMMIT (es un PROCEDURE, puede hacer COMMIT)


-- ============================================================
-- PARTE 8: Test de transacción con SAVEPOINT (RF-06)
-- ============================================================

-- TODO: Insertar datos de prueba: 1 cliente, 2 productos, stock >= 5

-- TODO: Escribir la transacción de prueba:
--   BEGIN;
--     INSERT INTO orders ... → guardar order_id
--     SAVEPOINT sp_order_created;
--     INSERT INTO order_items ... (producto 1, cantidad 2)
--     SAVEPOINT sp_items_ok;
--     -- Simular fallo: intentar insertar item con UUID de producto inválido
--     -- Si falla: ROLLBACK TO SAVEPOINT sp_order_created
--     -- Si todo bien: RELEASE SAVEPOINT sp_items_ok
--     UPDATE orders SET order_total = fn_calculate_order_total(order_id) ...
--   COMMIT;


-- ============================================================
-- VERIFICACIÓN FINAL
-- ============================================================

-- Descomenta y ejecuta para verificar todos los objetos creados:

-- -- Vistas:
-- SELECT * FROM vw_product_catalog          LIMIT 5;
-- SELECT * FROM vw_customer_order_summary   LIMIT 5;
-- SELECT * FROM vw_low_stock                LIMIT 5;
-- SELECT * FROM mvw_monthly_revenue         LIMIT 12;

-- -- Funciones:
-- SELECT fn_apply_discount('...uuid...', 10);
-- SELECT * FROM fn_get_customer_stats('...uuid...');
-- SELECT fn_validate_stock('...uuid...', 3);

-- -- Auditoría:
-- SELECT audit_table, audit_operation, audit_user, audit_at
-- FROM   audit_log
-- ORDER BY audit_at DESC
-- LIMIT 10;

-- -- Objetos creados en el catálogo:
-- SELECT routine_name, routine_type
-- FROM   information_schema.routines
-- WHERE  routine_schema = current_schema()
-- ORDER BY routine_type, routine_name;
