# Práctica 11: Comparativa de Rendimiento con y sin Índices

## Objetivo

Medir empíricamente la diferencia de rendimiento entre consultas con y sin
índices sobre un conjunto de 100 000 filas, usando `EXPLAIN ANALYZE` para
comparar los planes de ejecución antes y después de crear los índices.

**Duración estimada:** 3 horas  
**Nivel:** Intermedio  
**Herramienta:** pgAdmin 4 o DBeaver con PostgreSQL 16+

---

## Contexto

Trabajaremos con el esquema **ShopHub** de la semana 10. Si no lo tienes
instalado, ejecuta el script completo del proyecto de esa semana antes de
continuar.

---

## Paso 1: Generar 100 000 Pedidos de Prueba

Ejecuta el siguiente bloque completo. Genera órdenes con fechas
distribuidas en el último año y estados aleatorios.

```sql
-- ============================================================
-- GENERAR 100 000 ÓRDENES DE PRUEBA
-- Tiempo estimado: ~10 segundos
-- ============================================================

INSERT INTO orders (
    order_id,
    customer_id,
    order_status,
    order_total,
    created_at
)
SELECT
    gen_random_uuid(),
    (SELECT customer_id FROM customers ORDER BY random() LIMIT 1),
    (ARRAY['pending', 'confirmed', 'shipped', 'delivered', 'cancelled'])[
        floor(random() * 5 + 1)::int
    ],
    (random() * 5000 + 10)::NUMERIC(10, 2),
    NOW() - (random() * INTERVAL '365 days')
FROM generate_series(1, 100000);

-- Verificar la cantidad:
SELECT COUNT(*) AS total_orders FROM orders;
```

Verás `100000` (más los pedidos de las prácticas anteriores si existen).

---

## Paso 2: Consultas SIN Índices — Medir el Costo Base

Ejecuta cada una de las siguientes consultas y **copia el plan de
ejecución completo** para compararlo luego. Observa la línea de `Seq Scan`.

### Consulta Q1: Pedidos de un cliente específico

```sql
-- ============================================================
-- Q1: Buscar pedidos por customer_id (FK sin índice)
-- ============================================================

-- Primero obtén un customer_id real de la base de datos:
-- SELECT customer_id FROM customers LIMIT 1;
-- Luego sustitúyelo abajo:

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    order_id,
    order_status,
    order_total,
    created_at
FROM orders
WHERE customer_id = '00000000-0000-0000-0000-000000000000';  -- reemplaza con un UUID real

-- Observa:
-- 1. ¿Es Seq Scan o Index Scan?
-- 2. ¿Cuántas filas se estimaron vs. cuántas se devolvieron?
-- 3. ¿Cuánto tiempo real tomó? (actual time=X..Y)
-- 4. ¿Cuántos buffers se leyeron?
```

### Consulta Q2: Pedidos pendientes de la última semana

```sql
-- ============================================================
-- Q2: Pedidos con status 'pending' en los últimos 7 días
-- ============================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    order_id,
    customer_id,
    order_total,
    created_at
FROM orders
WHERE order_status = 'pending'
  AND created_at >= NOW() - INTERVAL '7 days';

-- Observa si el planificador aplica un Seq Scan
-- con dos condiciones de filtro
```

### Consulta Q3: Paginación por fecha

```sql
-- ============================================================
-- Q3: Últimos 20 pedidos (paginación)
-- ============================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    order_id,
    customer_id,
    order_status,
    order_total,
    created_at
FROM orders
ORDER BY created_at DESC
LIMIT 20;

-- Observa si aparece un nodo "Sort" y el Sort Method
-- (quicksort = en memoria, external merge = volcó a disco)
```

### Consulta Q4: JOIN entre órdenes, ítems y productos

```sql
-- ============================================================
-- Q4: JOIN órdenes + order_items + products
-- ============================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    o.order_id,
    o.order_status,
    p.product_name,
    oi.order_item_quantity,
    oi.order_item_price
FROM orders             AS o
JOIN order_items        AS oi  ON oi.order_id    = o.order_id
JOIN products           AS p   ON p.product_id   = oi.product_id
WHERE o.order_status = 'shipped'
LIMIT 50;

-- Observa la estrategia de JOIN elegida por el planificador
-- y el nodo con mayor costo
```

---

## Paso 3: Registrar los Resultados sin Índices

Completa la tabla con los datos de cada plan:

```sql
-- ============================================================
-- TABLA DE RESULTADOS — COMPLETAR MANUALMENTE
-- Copia y edita los valores reales que obtuviste
-- ============================================================

-- | Consulta | Nodo principal | Costo estimado | Tiempo real (ms) |
-- |----------|---------------|----------------|------------------|
-- | Q1       |               |                |                  |
-- | Q2       |               |                |                  |
-- | Q3       |               |                |                  |
-- | Q4       |               |                |                  |
```

---

## Paso 4: Crear los Índices Justificados

Ejecuta cada índice y lee el comentario que explica **por qué** se crea.

```sql
-- ============================================================
-- ÍNDICE 1: FK customer_id en orders
-- Por qué: toda FK debe estar indexada. Q1 hace filter por
-- customer_id. Sin índice → Seq Scan de 100K filas.
-- ============================================================
CREATE INDEX ix_orders_customer_id
    ON orders (customer_id);

-- ============================================================
-- ÍNDICE 2: Compuesto (status, created_at) en orders
-- Por qué: Q2 filtra por status Y por created_at juntos.
-- El prefijo izquierdo es status (menos selectivo) pero combinado
-- con created_at el índice cubre ambas condiciones eficientemente.
-- Nota: si invirtiéramos el orden → ix_orders_created_at_status
-- sería mejor para Q3 pero peor para Q2 con solo status.
-- ============================================================
CREATE INDEX ix_orders_status_created_at
    ON orders (order_status, created_at DESC);

-- ============================================================
-- ÍNDICE 3: created_at para ORDER BY y paginación
-- Por qué: Q3 hace ORDER BY created_at DESC LIMIT 20.
-- Con este índice el planificador puede hacer Index Scan en lugar
-- de Sort + Seq Scan.
-- ============================================================
CREATE INDEX ix_orders_created_at
    ON orders (created_at DESC);

-- ============================================================
-- ÍNDICE 4: FK order_id en order_items
-- Por qué: Q4 hace JOIN ON order_items.order_id = orders.order_id.
-- Sin índice en la FK → Seq Scan de toda la tabla order_items.
-- ============================================================
CREATE INDEX ix_order_items_order_id
    ON order_items (order_id);

-- ============================================================
-- ÍNDICE 5: FK product_id en order_items
-- Por qué: Q4 también hace JOIN ON order_items.product_id.
-- ============================================================
CREATE INDEX ix_order_items_product_id
    ON order_items (product_id);
```

---

## Paso 5: Consultas CON Índices — Comparar el Costo

Vuelve a ejecutar las mismas 4 consultas con `EXPLAIN (ANALYZE, BUFFERS)`.
No las modifiques — deben ser idénticas a las del Paso 2.

```sql
-- Ejecuta Q1, Q2, Q3 y Q4 del Paso 2 sin cambios.
-- Esta vez observa:
-- 1. ¿Cambió Seq Scan a Index Scan?
-- 2. ¿Cuánto bajó el tiempo real?
-- 3. ¿Cambió el número de buffers leídos?
```

Actualiza la tabla del Paso 3 con los nuevos tiempos.

---

## Paso 6: Índice Parcial — Solo Pedidos Activos

```sql
-- ============================================================
-- ÍNDICE PARCIAL: solo pedidos pendientes o confirmados
-- Por qué: en la mayoría de los sistemas, los pedidos
-- "terminados" (delivered, cancelled) ya no se consultan
-- frecuentemente. El índice parcial es más pequeño y rápido.
-- ============================================================
CREATE INDEX ix_orders_active_created_at
    ON orders (created_at DESC)
    WHERE order_status IN ('pending', 'confirmed');

-- Compara el tamaño:
SELECT
    indexrelname,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
WHERE relname = 'orders'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Consulta que usa el índice parcial:
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_id, customer_id, order_total
FROM orders
WHERE order_status = 'pending'
  AND created_at >= NOW() - INTERVAL '30 days'
ORDER BY created_at DESC
LIMIT 100;
```

---

## Paso 7: Índice GIN sobre JSONB

Si la tabla `products` tiene una columna `product_metadata` de tipo JSONB,
ejecuta esto. Si no existe, agrégala primero.

```sql
-- Si product_metadata no existe, agrégala:
-- ALTER TABLE products ADD COLUMN product_metadata JSONB DEFAULT '{}';

-- ============================================================
-- ÍNDICE GIN: búsqueda por contenido en JSONB
-- ============================================================
CREATE INDEX ix_products_metadata_gin
    ON products USING GIN (product_metadata);

-- Buscar productos de una categoría específica en metadata:
EXPLAIN (ANALYZE, BUFFERS)
SELECT product_id, product_name
FROM products
WHERE product_metadata @> '{"brand": "TestBrand"}';

-- Observa: antes Seq Scan, después Bitmap Index Scan (GIN)
```

---

## Paso 8: Identificar un Índice Que NO Ayuda

La columna `order_status` tiene muy baja selectividad (solo 5 valores
distintos en 100K filas, ~20% de las filas por valor).

```sql
-- ============================================================
-- CASO DE BAJA SELECTIVIDAD — el índice no ayuda
-- ============================================================

-- Crear un índice solo en order_status:
CREATE INDEX ix_orders_status_solo
    ON orders (order_status);

-- Consulta con baja selectividad:
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) FROM orders WHERE order_status = 'shipped';

-- Observa: PostgreSQL probablemente IGONRA el índice y hace Seq Scan
-- porque sería más caro leer el índice + heap para el 20% de la tabla
-- que simplemente escanear toda la tabla de corrido.

-- Confirmar con esta variante que fuerza el índice (¡solo para prueba!):
SET enable_seqscan = OFF;
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) FROM orders WHERE order_status = 'shipped';
SET enable_seqscan = ON;  -- ¡no olvidar reactivar!

-- Compara los tiempos: el Seq Scan suele ser más rápido aquí.
```

---

## Paso 9: Verificar Uso de Índices en Producción

```sql
-- ============================================================
-- ¿Qué índices se están usando realmente?
-- ============================================================
SELECT
    i.indexrelname                                  AS indice,
    t.relname                                       AS tabla,
    i.idx_scan                                      AS veces_usado,
    pg_size_pretty(pg_relation_size(i.indexrelid))  AS tamanio
FROM pg_stat_user_indexes    AS i
JOIN pg_stat_user_tables     AS t  USING (relid)
WHERE t.relname = 'orders'
ORDER BY i.idx_scan DESC;

-- Un índice con idx_scan = 0 después de muchas consultas
-- es candidato para eliminar:
-- DROP INDEX CONCURRENTLY ix_orders_status_solo;
```

---

## Reflexión Final

Responde en tu cuaderno o en los comentarios del script:

1. ¿En cuánto se redujo el tiempo de Q1 al agregar el índice en `customer_id`?
2. ¿El índice `ix_orders_status_solo` fue usado por el planificador? ¿Por qué no?
3. ¿Qué diferencia hay entre el plan de Q3 antes y después del índice en `created_at`?
4. ¿Qué ocurrió con la estrategia de JOIN en Q4 al agregar los índices en `order_items`?
5. ¿Cuándo preferirías un índice parcial sobre un índice completo?
