# Práctica — Refactorizar ShopHub con Patrones de Diseño Avanzados

## Contexto

Tienes el sistema ShopHub (e-commerce) que has modelado en semanas anteriores.
Esta práctica te guía para aplicar los tres patrones clave de la semana:
**soft delete**, **auditoría con tabla de historia** y **jerarquías con lista de
adyacencia**. El objetivo es observar cómo cada patrón cambia el comportamiento
del sistema sin romper el modelo existente.

**Tiempo estimado:** 3 horas  
**Herramienta recomendada:** pgAdmin 4 o DBeaver

---

## Paso 0 — Preparar el Entorno

Crea un schema de trabajo para no afectar datos previos. Ejecuta este bloque
completo y observa cómo PostgreSQL crea el schema y lo establece como activo:

```sql
-- Crear schema de práctica para esta semana
-- CREATE SCHEMA IF NOT EXISTS shophub_patterns;
-- SET search_path = shophub_patterns;

-- Crear tablas base del e-commerce (versión simplificada para la práctica)
-- CREATE TABLE customers (
--     customer_id     UUID            NOT NULL DEFAULT gen_random_uuid(),
--     customer_email  VARCHAR(150)    NOT NULL,
--     customer_name   VARCHAR(100)    NOT NULL,
--     created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_customers     PRIMARY KEY (customer_id),
--     CONSTRAINT uq_customers_email UNIQUE (customer_email)
-- );
--
-- CREATE TABLE categories (
--     category_id     UUID            NOT NULL DEFAULT gen_random_uuid(),
--     parent_id       UUID,
--     category_name   VARCHAR(80)     NOT NULL,
--     created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_categories        PRIMARY KEY (category_id),
--     CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id)
--         REFERENCES categories (category_id) ON DELETE RESTRICT
-- );
--
-- CREATE TABLE products (
--     product_id      UUID            NOT NULL DEFAULT gen_random_uuid(),
--     category_id     UUID            NOT NULL,
--     product_name    VARCHAR(200)    NOT NULL,
--     product_price   NUMERIC(10, 2)  NOT NULL CHECK (product_price >= 0),
--     product_stock   INTEGER         NOT NULL DEFAULT 0,
--     created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_products          PRIMARY KEY (product_id),
--     CONSTRAINT fk_products_category FOREIGN KEY (category_id)
--         REFERENCES categories (category_id)
-- );

-- Insertar categorías de prueba (estructura sin jerarquía aún):
-- INSERT INTO categories (category_id, category_name) VALUES
--     ('11111111-0000-0000-0000-000000000001', 'Electrónicos'),
--     ('11111111-0000-0000-0000-000000000002', 'Laptops'),
--     ('11111111-0000-0000-0000-000000000003', 'Gaming'),
--     ('11111111-0000-0000-0000-000000000004', 'Celulares');

-- Insertar productos de prueba:
-- INSERT INTO products (product_id, category_id, product_name, product_price, product_stock) VALUES
--     ('aaaaaaaa-0000-0000-0000-000000000001', '11111111-0000-0000-0000-000000000002', 'Laptop Pro 15"', 999.00, 12),
--     ('aaaaaaaa-0000-0000-0000-000000000002', '11111111-0000-0000-0000-000000000002', 'Laptop Básica', 449.00, 30),
--     ('aaaaaaaa-0000-0000-0000-000000000003', '11111111-0000-0000-0000-000000000003', 'Mouse Gamer', 59.00, 85),
--     ('aaaaaaaa-0000-0000-0000-000000000004', '11111111-0000-0000-0000-000000000004', 'Smartphone Pro', 799.00, 20);

-- Verificar:
-- SELECT * FROM products;
-- SELECT * FROM categories;
```

---

## Paso 1 — Agregar Soft Delete a Productos y Clientes

Agrega la columna `deleted_at` a las tablas existentes. Observa que
`ALTER TABLE ... ADD COLUMN` no rompe datos existentes:

```sql
-- Agregar soft delete a products y customers:
-- ALTER TABLE products  ADD COLUMN deleted_at TIMESTAMPTZ;
-- ALTER TABLE customers ADD COLUMN deleted_at TIMESTAMPTZ;

-- Verificar que la columna existe y todos los registros tienen NULL:
-- SELECT product_id, product_name, deleted_at FROM products;
-- -- Todos deben mostrar deleted_at = NULL (activos)
```

---

## Paso 2 — Índice Parcial para UNIQUE con Soft Delete

Antes de crear las vistas, resuelve el problema de unicidad. Observa
la diferencia entre un UNIQUE normal y un índice parcial:

```sql
-- Primero: intenta crear un UNIQUE normal en customer_email
-- (ya existe la constraint del paso 0, así que la eliminamos para demostrar):
-- ALTER TABLE customers DROP CONSTRAINT IF EXISTS uq_customers_email;

-- Crear índice parcial que aplica unicidad SOLO a filas activas:
-- CREATE UNIQUE INDEX uq_customers_active_email
--     ON customers (customer_email)
--     WHERE deleted_at IS NULL;

-- Prueba: insertar dos clientes con el mismo email (activo vs. eliminado)
-- INSERT INTO customers (customer_email, customer_name) VALUES
--     ('test@example.com', 'Cliente Activo');

-- Simula eliminación del primer cliente:
-- UPDATE customers SET deleted_at = NOW() WHERE customer_email = 'test@example.com';

-- Ahora puedes reusar el mismo email (índice parcial lo permite):
-- INSERT INTO customers (customer_email, customer_name) VALUES
--     ('test@example.com', 'Cliente Nuevo');
-- -- ¡Funciona! El índice parcial ignora las filas con deleted_at IS NOT NULL

-- Verificar ambos registros:
-- SELECT customer_name, customer_email, deleted_at FROM customers
-- WHERE customer_email = 'test@example.com';
```

---

## Paso 3 — Crear Vistas para Registros Activos

Las vistas actúan como filtros automáticos. La aplicación consulta
la vista en lugar de la tabla directamente:

```sql
-- Vista de productos activos:
-- CREATE OR REPLACE VIEW vw_active_products AS
--     SELECT
--         product_id,
--         category_id,
--         product_name,
--         product_price,
--         product_stock,
--         created_at,
--         updated_at
--     FROM products
--     WHERE deleted_at IS NULL;

-- Vista de clientes activos:
-- CREATE OR REPLACE VIEW vw_active_customers AS
--     SELECT
--         customer_id,
--         customer_email,
--         customer_name,
--         created_at,
--         updated_at
--     FROM customers
--     WHERE deleted_at IS NULL;

-- Verificar: la vista oculta automáticamente los eliminados:
-- SELECT COUNT(*) FROM products;           -- incluye eliminados
-- SELECT COUNT(*) FROM vw_active_products; -- solo activos
```

---

## Paso 4 — Funciones de Soft Delete y Restauración

Encapsula las operaciones de soft delete en funciones para mantener
la lógica centralizada:

```sql
-- Función para eliminar lógicamente un producto:
-- CREATE OR REPLACE FUNCTION fn_soft_delete_product(
--     p_product_id UUID
-- ) RETURNS VOID
-- LANGUAGE plpgsql AS $$
-- BEGIN
--     UPDATE products
--     SET deleted_at = NOW()
--     WHERE product_id = p_product_id
--       AND deleted_at IS NULL;  -- Solo elimina si está activo
--
--     IF NOT FOUND THEN
--         RAISE NOTICE 'Producto % no encontrado o ya está eliminado', p_product_id;
--     END IF;
-- END;
-- $$;

-- Función para restaurar un producto eliminado:
-- CREATE OR REPLACE FUNCTION fn_restore_product(
--     p_product_id UUID
-- ) RETURNS VOID
-- LANGUAGE plpgsql AS $$
-- BEGIN
--     UPDATE products
--     SET deleted_at = NULL
--     WHERE product_id = p_product_id
--       AND deleted_at IS NOT NULL;  -- Solo restaura si está eliminado
--
--     IF NOT FOUND THEN
--         RAISE NOTICE 'Producto % no encontrado o ya está activo', p_product_id;
--     END IF;
-- END;
-- $$;

-- Probar el ciclo completo:
-- SELECT fn_soft_delete_product('aaaaaaaa-0000-0000-0000-000000000003');  -- elimina Mouse Gamer
-- SELECT product_name, deleted_at FROM products WHERE product_name = 'Mouse Gamer';

-- SELECT fn_restore_product('aaaaaaaa-0000-0000-0000-000000000003');      -- restaura
-- SELECT product_name, deleted_at FROM products WHERE product_name = 'Mouse Gamer';
```

---

## Paso 5 — Tabla de Historia para Auditoría Completa

Crea la tabla que almacena cada versión anterior de un producto.
Observa la estructura espejo con columnas adicionales de metadata:

```sql
-- Tabla de historia — copia la estructura de products más metadata:
-- CREATE TABLE products_history (
--     history_id          UUID        NOT NULL DEFAULT gen_random_uuid(),
--     history_operation   TEXT        NOT NULL CHECK (history_operation IN ('INSERT', 'UPDATE', 'DELETE')),
--     history_changed_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
--     history_changed_by  TEXT        NOT NULL DEFAULT current_user,
--     -- Copia de todas las columnas de products:
--     product_id          UUID,
--     category_id         UUID,
--     product_name        VARCHAR(200),
--     product_price       NUMERIC(10, 2),
--     product_stock       INTEGER,
--     created_at          TIMESTAMPTZ,
--     updated_at          TIMESTAMPTZ,
--     deleted_at          TIMESTAMPTZ,
--     CONSTRAINT pk_products_history PRIMARY KEY (history_id)
-- );

-- Verificar que la tabla está vacía y lista:
-- SELECT COUNT(*) FROM products_history;
```

---

## Paso 6 — Trigger para Capturar el Historial

Este trigger se dispara automáticamente después de cada INSERT, UPDATE o DELETE
en products. Observa cómo usa `OLD` para capturar el estado anterior:

```sql
-- Función trigger que inserta en products_history:
-- CREATE OR REPLACE FUNCTION fn_trg_products_history()
-- RETURNS TRIGGER
-- LANGUAGE plpgsql AS $$
-- BEGIN
--     IF TG_OP = 'DELETE' THEN
--         INSERT INTO products_history (
--             history_operation,
--             product_id, category_id, product_name,
--             product_price, product_stock,
--             created_at, updated_at, deleted_at
--         ) VALUES (
--             'DELETE',
--             OLD.product_id, OLD.category_id, OLD.product_name,
--             OLD.product_price, OLD.product_stock,
--             OLD.created_at, OLD.updated_at, OLD.deleted_at
--         );
--     ELSE
--         -- Para INSERT y UPDATE captura el estado NUEVO (NEW):
--         INSERT INTO products_history (
--             history_operation,
--             product_id, category_id, product_name,
--             product_price, product_stock,
--             created_at, updated_at, deleted_at
--         ) VALUES (
--             TG_OP,
--             NEW.product_id, NEW.category_id, NEW.product_name,
--             NEW.product_price, NEW.product_stock,
--             NEW.created_at, NEW.updated_at, NEW.deleted_at
--         );
--     END IF;
--     RETURN NULL;
-- END;
-- $$;

-- Crear el trigger AFTER en la tabla products:
-- CREATE TRIGGER trg_products_history
-- AFTER INSERT OR UPDATE OR DELETE ON products
-- FOR EACH ROW EXECUTE FUNCTION fn_trg_products_history();

-- Probar: actualiza el precio de un producto y verifica que queda en el historial:
-- UPDATE products SET product_price = 879.00
-- WHERE product_id = 'aaaaaaaa-0000-0000-0000-000000000001';

-- UPDATE products SET product_price = 799.00
-- WHERE product_id = 'aaaaaaaa-0000-0000-0000-000000000001';

-- Ver el historial de cambios de precio:
-- SELECT history_operation, history_changed_at, product_price
-- FROM products_history
-- WHERE product_id = 'aaaaaaaa-0000-0000-0000-000000000001'
-- ORDER BY history_changed_at;
```

---

## Paso 7 — Point-in-Time Query

Una de las ventajas clave del historial: podemos recuperar el estado
exacto de un producto en cualquier momento pasado:

```sql
-- ¿Cuál era el precio del producto a las 12:00 del día de hoy?
-- SELECT product_name, product_price, history_changed_at
-- FROM products_history
-- WHERE product_id = 'aaaaaaaa-0000-0000-0000-000000000001'
--   AND history_changed_at <= NOW() - INTERVAL '1 hour'
-- ORDER BY history_changed_at DESC
-- LIMIT 1;

-- Ver todos los cambios con el precio anterior usando LAG():
-- SELECT
--     history_operation,
--     history_changed_at,
--     product_price                                       AS precio_nuevo,
--     LAG(product_price) OVER (ORDER BY history_changed_at) AS precio_anterior
-- FROM products_history
-- WHERE product_id = 'aaaaaaaa-0000-0000-0000-000000000001'
-- ORDER BY history_changed_at;
```

---

## Paso 8 — Jerarquía en Categorías con Adjacency List

Actualmente las categorías no tienen relación padre-hijo. Agrega la
jerarquía: Electrónicos → Laptops, Gaming · Electrónicos → Celulares:

```sql
-- La columna parent_id ya existe (la creamos en el paso 0).
-- Establece las relaciones padre-hijo con UPDATE:
-- UPDATE categories SET parent_id = '11111111-0000-0000-0000-000000000001'
-- WHERE category_id IN (
--     '11111111-0000-0000-0000-000000000002',  -- Laptops
--     '11111111-0000-0000-0000-000000000004'   -- Celulares
-- );

-- UPDATE categories SET parent_id = '11111111-0000-0000-0000-000000000002'
-- WHERE category_id = '11111111-0000-0000-0000-000000000003';  -- Gaming → hijo de Laptops

-- Verificar estructura:
-- SELECT category_id, category_name, parent_id FROM categories ORDER BY parent_id NULLS FIRST;
```

---

## Paso 9 — Consultar el Árbol con WITH RECURSIVE

Ahora navega la jerarquía completa desde la raíz con una CTE recursiva.
Observa cómo se calcula el nivel de profundidad y el path:

```sql
-- Árbol completo de categorías con profundidad y ruta:
-- WITH RECURSIVE category_tree AS (
--     -- Caso base: nodos raíz (sin padre)
--     SELECT
--         category_id,
--         parent_id,
--         category_name,
--         0               AS depth,
--         category_name   AS full_path
--     FROM categories
--     WHERE parent_id IS NULL
--
--     UNION ALL
--
--     -- Caso recursivo: hijos del nodo actual
--     SELECT
--         c.category_id,
--         c.parent_id,
--         c.category_name,
--         ct.depth + 1,
--         ct.full_path || ' → ' || c.category_name
--     FROM categories      AS c
--     JOIN category_tree   AS ct ON ct.category_id = c.parent_id
-- )
-- SELECT
--     depth,
--     REPEAT('  ', depth) || category_name  AS category_indented,
--     full_path
-- FROM category_tree
-- ORDER BY full_path;

-- Resultado esperado:
-- depth=0  Electrónicos
-- depth=1    Celulares      → Electrónicos → Celulares
-- depth=1    Laptops        → Electrónicos → Laptops
-- depth=2      Gaming       → Electrónicos → Laptops → Gaming
```

---

## Paso 10 — Verificación Final

Confirma que todos los patrones están funcionando juntos de forma coherente:

```sql
-- Resumen de objetos creados:
-- SELECT table_name  FROM information_schema.tables
-- WHERE table_schema = 'shophub_patterns'
-- ORDER BY table_name;

-- SELECT routine_name FROM information_schema.routines
-- WHERE routine_schema = 'shophub_patterns'
-- ORDER BY routine_name;

-- SELECT trigger_name, event_manipulation, event_object_table
-- FROM information_schema.triggers
-- WHERE trigger_schema = 'shophub_patterns'
-- ORDER BY trigger_name;

-- Conteo de registros por tabla:
-- SELECT 'products'         AS tabla, COUNT(*) FROM products
-- UNION ALL
-- SELECT 'products_history' AS tabla, COUNT(*) FROM products_history
-- UNION ALL
-- SELECT 'categories'       AS tabla, COUNT(*) FROM categories
-- UNION ALL
-- SELECT 'customers'        AS tabla, COUNT(*) FROM customers;
```

---

## Reflexión Final

Al terminar esta práctica deberías poder responder:

1. ¿Por qué `WHERE deleted_at IS NULL` en la vista es más seguro que depender de la aplicación?
2. ¿Qué pasa si un producto con soft delete tiene el mismo nombre que uno activo — es un problema?
3. ¿En qué situación usarías `products_history` vs. una tabla genérica `audit_log`?
4. ¿Cuántas filas inserta el trigger `trg_products_history` cuando haces un `UPDATE`? ¿Por qué?
5. ¿Cómo modificarías la CTE recursiva para obtener solo los ancestros de `Gaming`?

---

← [README de la Semana](../README.md) | → [Proyecto — ContentHub](../3-proyecto/README.md)
