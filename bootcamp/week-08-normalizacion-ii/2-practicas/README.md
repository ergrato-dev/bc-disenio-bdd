# Práctica — FacturaPro: De 2FN a 3FN

## Contexto

FacturaPro es un sistema de facturación para una empresa distribuidora. Tras
la normalización a **2FN** de la semana anterior, la tabla `invoices_2fn`
ya no tiene dependencias parciales (su PK es simple — `invoice_id`). Sin
embargo, el equipo sospecha que aún quedan anomalías de actualización.

En esta práctica identificarás las dependencias transitivas, aplicarás el
algoritmo de síntesis a 3FN, y verificarás que la descomposición no pierde
información. Al final evaluarás si el modelo también está en FNBC.

**Duración estimada:** 3 horas  
**Herramienta recomendada:** pgAdmin 4 o DBeaver  
**Base de datos:** PostgreSQL 16+

---

## Paso 1: Crear el Esquema de Trabajo

Crea una base de datos y un esquema dedicados para esta práctica:

```sql
-- ============================================================
-- PASO 1: Preparar el entorno
-- ============================================================

-- CREATE DATABASE facturapro_practica;
-- \c facturapro_practica

-- CREATE SCHEMA normalizacion;
-- SET search_path TO normalizacion;
```

---

## Paso 2: Cargar la Tabla en 2FN (con Violaciones de 3FN)

Ejecuta el siguiente script para crear la tabla que analizarás:

```sql
-- ============================================================
-- PASO 2: Tabla invoices_2fn — en 2FN pero viola 3FN
-- (PK simple: invoice_id. Sin deps. parciales.)
-- Contiene dependencias transitivas intencionales para práctica.
-- ============================================================

-- DROP TABLE IF EXISTS normalizacion.invoices_2fn;

-- CREATE TABLE normalizacion.invoices_2fn (
--     invoice_id       UUID         NOT NULL DEFAULT gen_random_uuid(),
--     customer_id      UUID         NOT NULL,
--     customer_name    VARCHAR(100) NOT NULL,
--     customer_city_id SMALLINT     NOT NULL,
--     city_name        VARCHAR(80)  NOT NULL,
--     salesperson_id   UUID         NOT NULL,
--     salesperson_name VARCHAR(100) NOT NULL,
--     invoice_date     DATE         NOT NULL,
--     invoice_total    NUMERIC(12, 2) NOT NULL,
--     created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
--
--     CONSTRAINT pk_invoices_2fn PRIMARY KEY (invoice_id),
--     CONSTRAINT ck_invoices_2fn_total CHECK (invoice_total >= 0)
-- );
```

---

## Paso 3: Insertar Datos de Prueba

Los datos están diseñados para que las anomalías sean visibles:

```sql
-- ============================================================
-- PASO 3: Datos de prueba — observa los valores redundantes
-- ============================================================

-- INSERT INTO normalizacion.invoices_2fn
--     (customer_id, customer_name, customer_city_id, city_name,
--      salesperson_id, salesperson_name, invoice_date, invoice_total)
-- VALUES
--     -- Cliente Martínez, ciudad 1 = Guadalajara
--     ('a1b2c3d4-0001-0001-0001-000000000001',
--      'Carlos Martínez', 1, 'Guadalajara',
--      'e5f6a7b8-0001-0001-0001-000000000001',
--      'Ana López', '2025-01-10', 1500.00),
--
--     -- Misma ciudad, mismo cliente → customer_name y city_name se repiten
--     ('a1b2c3d4-0001-0001-0001-000000000001',
--      'Carlos Martínez', 1, 'Guadalajara',
--      'e5f6a7b8-0001-0001-0001-000000000002',
--      'Pedro Ruiz', '2025-01-15', 2200.00),
--
--     -- Otro cliente, misma ciudad
--     ('a1b2c3d4-0001-0001-0001-000000000002',
--      'Laura Sánchez', 1, 'Guadalajara',
--      'e5f6a7b8-0001-0001-0001-000000000001',
--      'Ana López', '2025-01-20', 850.00),
--
--     -- Cliente en ciudad 2 = Monterrey
--     ('a1b2c3d4-0001-0001-0001-000000000003',
--      'Ernesto Vega', 2, 'Monterrey',
--      'e5f6a7b8-0001-0001-0001-000000000002',
--      'Pedro Ruiz', '2025-02-05', 3100.00),
--
--     -- Mismo cliente Vega, misma ciudad → redundancia
--     ('a1b2c3d4-0001-0001-0001-000000000003',
--      'Ernesto Vega', 2, 'Monterrey',
--      'e5f6a7b8-0001-0001-0001-000000000001',
--      'Ana López', '2025-02-12', 760.00);
```

---

## Paso 4: Identificar las Dependencias Transitivas

Ejecuta estas consultas diagnóstico para confirmar que las dependencias
existen en los datos (no solo en el modelo):

```sql
-- ============================================================
-- PASO 4a: Verificar customer_id → customer_name (transitiva)
-- Si customer_id tiene siempre el mismo customer_name, la FD existe.
-- ============================================================

-- SELECT customer_id,
--        COUNT(DISTINCT customer_name) AS nombres_distintos
-- FROM normalizacion.invoices_2fn
-- GROUP BY customer_id
-- HAVING COUNT(DISTINCT customer_name) > 1;
-- → Resultado esperado: 0 filas (la FD se respeta en datos correctos)

-- ============================================================
-- PASO 4b: Verificar customer_city_id → city_name (transitiva doble)
-- ============================================================

-- SELECT customer_city_id,
--        COUNT(DISTINCT city_name) AS ciudades_distintas
-- FROM normalizacion.invoices_2fn
-- GROUP BY customer_city_id
-- HAVING COUNT(DISTINCT city_name) > 1;
-- → Resultado esperado: 0 filas

-- ============================================================
-- PASO 4c: Verificar salesperson_id → salesperson_name (transitiva)
-- ============================================================

-- SELECT salesperson_id,
--        COUNT(DISTINCT salesperson_name) AS nombres_distintos
-- FROM normalizacion.invoices_2fn
-- GROUP BY salesperson_id
-- HAVING COUNT(DISTINCT salesperson_name) > 1;
-- → Resultado esperado: 0 filas
```

> Si alguna consulta retorna filas, los datos contienen **inconsistencias**
> que violan la FD — exactamente el tipo de anomalía que queremos eliminar.

---

## Paso 5: Extraer la Tabla `cities`

Primera extracción: la cadena más profunda
`invoice_id → customer_id → customer_city_id → city_name`:

```sql
-- ============================================================
-- PASO 5: Crear tabla cities y migrar datos
-- ============================================================

-- CREATE TABLE normalizacion.cities (
--     city_id      SMALLINT     NOT NULL GENERATED ALWAYS AS IDENTITY,
--     city_name    VARCHAR(80)  NOT NULL,
--     city_country CHAR(2)      NOT NULL DEFAULT 'MX',
--
--     CONSTRAINT pk_cities PRIMARY KEY (city_id),
--     CONSTRAINT uq_cities_name UNIQUE (city_name)
-- );

-- Migrar datos únicos desde invoices_2fn:
-- INSERT INTO normalizacion.cities (city_id, city_name)
-- OVERRIDING SYSTEM VALUE
-- SELECT DISTINCT customer_city_id, city_name
-- FROM normalizacion.invoices_2fn
-- ORDER BY customer_city_id;

-- Verificar:
-- SELECT * FROM normalizacion.cities;
```

---

## Paso 6: Extraer la Tabla `customers`

Segunda extracción: la cadena
`invoice_id → customer_id → customer_name, customer_city_id`:

```sql
-- ============================================================
-- PASO 6: Crear tabla customers y migrar datos
-- ============================================================

-- CREATE TABLE normalizacion.customers (
--     customer_id      UUID         NOT NULL DEFAULT gen_random_uuid(),
--     customer_name    VARCHAR(100) NOT NULL,
--     customer_city_id SMALLINT     NOT NULL,
--     created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
--
--     CONSTRAINT pk_customers       PRIMARY KEY (customer_id),
--     CONSTRAINT fk_customers_city
--         FOREIGN KEY (customer_city_id) REFERENCES normalizacion.cities(city_id)
-- );

-- Migrar datos únicos:
-- INSERT INTO normalizacion.customers (customer_id, customer_name, customer_city_id)
-- SELECT DISTINCT customer_id, customer_name, customer_city_id
-- FROM normalizacion.invoices_2fn;

-- Verificar:
-- SELECT c.customer_id, c.customer_name, ct.city_name
-- FROM normalizacion.customers  c
-- JOIN normalizacion.cities      ct ON ct.city_id = c.customer_city_id;
```

---

## Paso 7: Extraer la Tabla `salespersons`

Tercera extracción: `invoice_id → salesperson_id → salesperson_name`:

```sql
-- ============================================================
-- PASO 7: Crear tabla salespersons y migrar datos
-- ============================================================

-- CREATE TABLE normalizacion.salespersons (
--     salesperson_id   UUID         NOT NULL DEFAULT gen_random_uuid(),
--     salesperson_name VARCHAR(100) NOT NULL,
--     created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
--
--     CONSTRAINT pk_salespersons PRIMARY KEY (salesperson_id)
-- );

-- Migrar:
-- INSERT INTO normalizacion.salespersons (salesperson_id, salesperson_name)
-- SELECT DISTINCT salesperson_id, salesperson_name
-- FROM normalizacion.invoices_2fn;

-- Verificar:
-- SELECT * FROM normalizacion.salespersons;
```

---

## Paso 8: Crear la Tabla `invoices` Normalizada

La tabla final solo contiene las FDs directas sobre `invoice_id`:

```sql
-- ============================================================
-- PASO 8: Crear invoices en 3FN y migrar datos
-- ============================================================

-- CREATE TABLE normalizacion.invoices (
--     invoice_id       UUID           NOT NULL DEFAULT gen_random_uuid(),
--     customer_id      UUID           NOT NULL,
--     salesperson_id   UUID           NOT NULL,
--     invoice_date     DATE           NOT NULL,
--     invoice_total    NUMERIC(12, 2) NOT NULL,
--     created_at       TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
--
--     CONSTRAINT pk_invoices              PRIMARY KEY (invoice_id),
--     CONSTRAINT fk_invoices_customer
--         FOREIGN KEY (customer_id)     REFERENCES normalizacion.customers(customer_id),
--     CONSTRAINT fk_invoices_salesperson
--         FOREIGN KEY (salesperson_id)  REFERENCES normalizacion.salespersons(salesperson_id),
--     CONSTRAINT ck_invoices_total        CHECK (invoice_total >= 0)
-- );

-- Migrar desde la tabla original:
-- INSERT INTO normalizacion.invoices
--     (invoice_id, customer_id, salesperson_id, invoice_date, invoice_total, created_at)
-- SELECT invoice_id, customer_id, salesperson_id, invoice_date, invoice_total, created_at
-- FROM normalizacion.invoices_2fn;
```

---

## Paso 9: Verificar — Reconstruir los Datos Originales

La descomposición es válida si el JOIN entre las 4 tablas reproduce
exactamente los datos de `invoices_2fn`:

```sql
-- ============================================================
-- PASO 9: Verificación de descomposición sin pérdida (lossless join)
-- ============================================================

-- SELECT
--     i.invoice_id,
--     c.customer_name,
--     ct.city_name,
--     s.salesperson_name,
--     i.invoice_date,
--     i.invoice_total
-- FROM      normalizacion.invoices     i
-- JOIN      normalizacion.customers    c   ON c.customer_id    = i.customer_id
-- JOIN      normalizacion.cities       ct  ON ct.city_id       = c.customer_city_id
-- JOIN      normalizacion.salespersons s   ON s.salesperson_id = i.salesperson_id
-- ORDER BY  i.invoice_date;

-- ¿Los resultados coinciden exactamente con invoices_2fn?
-- SELECT * FROM normalizacion.invoices_2fn ORDER BY invoice_date;
```

---

## Paso 10: Evaluar si el Modelo Está en FNBC

```sql
-- ============================================================
-- PASO 10: ¿El modelo final está en FNBC?
-- Analiza cada tabla:
-- ============================================================

-- cities (city_id PK → city_name, city_country)
-- → city_id es superclave. ✅ FNBC

-- customers (customer_id PK → customer_name, customer_city_id)
-- → customer_id es superclave. ✅ FNBC

-- salespersons (salesperson_id PK → salesperson_name)
-- → salesperson_id es superclave. ✅ FNBC

-- invoices (invoice_id PK → customer_id, salesperson_id, invoice_date, invoice_total)
-- → invoice_id es superclave. ✅ FNBC

-- Conclusión: cuando todas las tablas tienen PK simple (una sola columna),
-- 3FN implica automáticamente FNBC.
-- La diferencia entre 3FN y FNBC solo aparece con múltiples CKs solapadas.
```

---

## Paso 11: Desnormalización Documentada (Opcional)

El negocio pide mostrar `invoice_total` en el listado sin calcular la suma
de líneas (que se añadirán en semanas futuras). Documenta la decisión:

```sql
-- ============================================================
-- PASO 11 (OPCIONAL): Decisión de desnormalización — invoice_total
-- ============================================================
-- JUSTIFICACIÓN:
--   invoice_total es un agregado que en el futuro se calculará
--   a partir de invoice_lines. Se mantiene pre-calculado porque
--   el listado de facturas se ejecuta ~10,000 veces/día.
--
-- TRADE-OFF:
--   Puede quedar desincronizado si invoice_lines se modifica
--   sin pasar por el trigger correspondiente.
--
-- MECANISMO DE SINCRONIZACIÓN:
--   Trigger AFTER INSERT/UPDATE/DELETE ON invoice_lines
--   (se implementará en la semana 12 — Objetos Avanzados).
--
-- invoice_total ya existe en la tabla invoices normalizada.
-- Documentar la decisión es suficiente en esta etapa.
-- ============================================================

-- SELECT 'Decisión documentada. invoice_total se mantiene como columna
-- pre-calculada con sincronización diferida.' AS nota;
```

---

## Preguntas de Reflexión

Responde en tu cuaderno o en comentarios SQL al finalizar la práctica:

1. ¿Por qué la tabla `invoices_2fn` estaba en 2FN pero no en 3FN?
   ¿Cuál es la diferencia estructural entre ambas formas normales?

2. Si la ciudad "Guadalajara" cambiara de nombre a "GDL Metropolitan Area",
   ¿cuántas filas tendría que actualizar en `invoices_2fn` vs el modelo 3FN?

3. Las tablas del modelo final en 3FN tienen todas PK simple. ¿Por qué
   esto garantiza automáticamente que también están en FNBC?

4. Si `customers` necesitara registrar que un cliente puede tener múltiples
   correos electrónicos, ¿qué cambio habría que hacer en el modelo?

5. ¿En qué circunstancias sería aceptable no normalizar a 3FN? Da un ejemplo
   concreto del mundo real.

---

← [README](../README.md) | → [Proyecto](../3-proyecto/README.md)
