# Práctica — Design Review: GymPro

## Contexto

GymPro es un sistema de gestión de un gimnasio. El equipo de desarrollo
entregó el siguiente esquema inicial, pero fue rechazado en la revisión
técnica por múltiples problemas de diseño.

Tu tarea es actuar como **DBA revisor**: aplica el checklist de calidad
de la semana 14, identifica todos los problemas y refactoriza el esquema
paso a paso hasta que supere todos los criterios.

---

## Esquema Inicial (Deficiente)

Ejecuta este bloque para crear el esquema que vas a auditar:

```sql
-- ============================================================
-- ESQUEMA INICIAL DE GYMPRO (con problemas de diseño)
-- Ejecuta este bloque para crear el estado inicial que revisarás
-- ============================================================

-- CREATE SCHEMA IF NOT EXISTS gympro;
-- SET search_path TO gympro;

-- -- Tabla de socios
-- -- Problemas: id genérico, nombres sin prefijo, TIMESTAMP, sin NOT NULL
-- CREATE TABLE socios (
--     id         SERIAL PRIMARY KEY,
--     nombre     VARCHAR(100),
--     email      VARCHAR(150) UNIQUE,
--     fecha_alta TIMESTAMP DEFAULT NOW()
-- );

-- -- Tabla de entrenadores
-- -- Problemas: FK sin ON DELETE, sin relación supervisor explícita
-- CREATE TABLE entrenadores (
--     id         SERIAL PRIMARY KEY,
--     nombre     VARCHAR(100),
--     email      VARCHAR(150),
--     jefe_id    INT REFERENCES entrenadores(id)
-- );

-- -- Tabla de clases
-- -- Problemas: FK sin ON DELETE, capacidad sin CHECK, nombre en español
-- CREATE TABLE clases (
--     id            SERIAL PRIMARY KEY,
--     nombre        VARCHAR(80),
--     instructor_id INT REFERENCES entrenadores(id),
--     capacidad     INT
-- );

-- -- Tabla de inscripciones
-- -- Problemas: sin timestamps, sin soft delete, FK sin ON DELETE
-- CREATE TABLE inscripciones (
--     id       SERIAL PRIMARY KEY,
--     socio_id INT REFERENCES socios(id),
--     clase_id INT REFERENCES clases(id),
--     fecha    DATE
-- );
```

---

## Paso 1 — Auditoría: Identifica los Problemas

Antes de refactorizar, documenta los problemas que encuentras. Usa el
checklist de calidad como guía:

```sql
-- ============================================================
-- AUDITORÍA INICIAL
-- Lista los problemas detectados en el esquema anterior:
-- ============================================================

-- NOMENCLATURA:
-- □ Las tablas están en español (socios, entrenadores, clases)
-- □ Los PKs se llaman "id" — no son auto-documentados
-- □ Las columnas no tienen prefijo de entidad (nombre, email)
-- □ No hay constraints nombradas explícitamente
-- □ Los objetos deben estar en inglés

-- TIPOS DE DATOS:
-- □ SERIAL en vez de UUID para PKs
-- □ TIMESTAMP en vez de TIMESTAMPTZ en fecha_alta
-- □ capacidad INT sin CHECK (podría ser 0 o negativo)

-- INTEGRIDAD:
-- □ Las columnas nombre y email no tienen NOT NULL
-- □ Las FKs no tienen ON DELETE explícito
-- □ La relación reflexiva jefe_id en entrenadores no tiene ON DELETE RESTRICT

-- PATRONES AVANZADOS:
-- □ No hay soft delete en inscripciones (los retiros deberían conservarse)
-- □ No hay timestamps de auditoría (created_at, updated_at)
-- □ No hay índices en las columnas FK
```

---

## Paso 2 — Refactorización: Nomenclatura y Tipos

Crea el esquema corregido con nombres en inglés y tipos de datos correctos:

```sql
-- ============================================================
-- PASO 2: Esquema corregido — nomenclatura y tipos
-- ============================================================

-- CREATE SCHEMA IF NOT EXISTS gympro_v2;
-- SET search_path TO gympro_v2;

-- -- Tabla de socios (members) con UUID y columnas auto-documentadas
-- CREATE TABLE members (
--     member_id       UUID            NOT NULL DEFAULT gen_random_uuid(),
--     member_name     VARCHAR(100)    NOT NULL,
--     member_email    VARCHAR(150)    NOT NULL,
--     created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     updated_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_members          PRIMARY KEY (member_id),
--     CONSTRAINT uq_members_email    UNIQUE (member_email)
-- );

-- -- Tabla de entrenadores (trainers) con auto-referencia supervisora
-- CREATE TABLE trainers (
--     trainer_id      UUID            NOT NULL DEFAULT gen_random_uuid(),
--     trainer_name    VARCHAR(100)    NOT NULL,
--     trainer_email   VARCHAR(150)    NOT NULL,
--     supervisor_id   UUID,
--     created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_trainers              PRIMARY KEY (trainer_id),
--     CONSTRAINT uq_trainers_email        UNIQUE (trainer_email),
--     CONSTRAINT fk_trainers_supervisor   FOREIGN KEY (supervisor_id)
--         REFERENCES trainers (trainer_id) ON DELETE RESTRICT
-- );
```

---

## Paso 3 — Refactorización: Integridad y FKs

Agrega las políticas `ON DELETE` y los `CHECK` constraints faltantes:

```sql
-- ============================================================
-- PASO 3: Clases e inscripciones con integridad completa
-- ============================================================

-- CREATE TABLE classes (
--     class_id        UUID            NOT NULL DEFAULT gen_random_uuid(),
--     class_name      VARCHAR(80)     NOT NULL,
--     trainer_id      UUID            NOT NULL,
--     class_capacity  SMALLINT        NOT NULL CHECK (class_capacity > 0),
--     created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_classes           PRIMARY KEY (class_id),
--     CONSTRAINT fk_classes_trainer   FOREIGN KEY (trainer_id)
--         REFERENCES trainers (trainer_id) ON DELETE RESTRICT
-- );

-- -- Inscripciones con soft delete: los retiros conservan el historial
-- CREATE TABLE enrollments (
--     enrollment_id       UUID            NOT NULL DEFAULT gen_random_uuid(),
--     member_id           UUID            NOT NULL,
--     class_id            UUID            NOT NULL,
--     enrollment_date     DATE            NOT NULL DEFAULT CURRENT_DATE,
--     cancelled_at        TIMESTAMPTZ,   -- soft delete
--     created_at          TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
--     CONSTRAINT pk_enrollments               PRIMARY KEY (enrollment_id),
--     CONSTRAINT fk_enrollments_member_id     FOREIGN KEY (member_id)
--         REFERENCES members (member_id) ON DELETE RESTRICT,
--     CONSTRAINT fk_enrollments_class_id      FOREIGN KEY (class_id)
--         REFERENCES classes (class_id) ON DELETE RESTRICT,
--     -- Un socio no puede estar inscrito dos veces en la misma clase activa
--     CONSTRAINT uq_enrollments_active        UNIQUE (member_id, class_id)
--         -- Nota: en producción esto sería un índice parcial, ver Paso 5
-- );
```

---

## Paso 4 — Índices

Agrega los índices justificados:

```sql
-- ============================================================
-- PASO 4: Índices — todas las FKs y columnas frecuentemente filtradas
-- ============================================================

-- -- Índices en FKs (obligatorios)
-- CREATE INDEX ix_classes_trainer_id       ON classes    (trainer_id);
-- CREATE INDEX ix_enrollments_member_id    ON enrollments (member_id);
-- CREATE INDEX ix_enrollments_class_id     ON enrollments (class_id);
-- CREATE INDEX ix_trainers_supervisor_id   ON trainers   (supervisor_id);

-- -- Índice parcial para inscripciones activas (soft delete)
-- CREATE INDEX ix_enrollments_active       ON enrollments (member_id, class_id)
--     WHERE cancelled_at IS NULL;

-- -- UNIQUE parcial: un socio no puede estar en la misma clase activa dos veces
-- CREATE UNIQUE INDEX uq_enrollments_active_unique ON enrollments (member_id, class_id)
--     WHERE cancelled_at IS NULL;
```

---

## Paso 5 — Vista de Miembros Activos

```sql
-- ============================================================
-- PASO 5: Vista para miembros activos
-- ============================================================

-- CREATE VIEW vw_active_members AS
--     SELECT
--         m.member_id,
--         m.member_name,
--         m.member_email,
--         COUNT(e.enrollment_id) AS active_classes
--     FROM members AS m
--     LEFT JOIN enrollments AS e
--         ON e.member_id = m.member_id AND e.cancelled_at IS NULL
--     GROUP BY m.member_id, m.member_name, m.member_email;

-- -- Consulta la vista:
-- SELECT * FROM vw_active_members ORDER BY active_classes DESC;
```

---

## Paso 6 — Trigger para updated_at

```sql
-- ============================================================
-- PASO 6: Trigger para mantener updated_at actualizado
-- ============================================================

-- -- Función reutilizable para cualquier tabla
-- CREATE OR REPLACE FUNCTION fn_set_updated_at()
-- RETURNS TRIGGER
-- LANGUAGE plpgsql AS $$
-- BEGIN
--     NEW.updated_at = NOW();
--     RETURN NEW;
-- END;
-- $$;

-- -- Aplicar en members
-- CREATE TRIGGER trg_members_set_updated_at
--     BEFORE UPDATE ON members
--     FOR EACH ROW
--     EXECUTE FUNCTION fn_set_updated_at();
```

---

## Paso 7 — Jerarquía de Entrenadores con WITH RECURSIVE

Consulta todos los entrenadores y su posición en la jerarquía supervisora:

```sql
-- ============================================================
-- PASO 7: Árbol de supervisión con WITH RECURSIVE
-- ============================================================

-- -- Primero inserta datos de prueba:
-- INSERT INTO trainers (trainer_id, trainer_name, trainer_email)
-- VALUES
--     ('00000000-0000-0000-0000-000000000001', 'Ana Directora',   'ana@gym.com'),
--     ('00000000-0000-0000-0000-000000000002', 'Bob Supervisor',  'bob@gym.com'),
--     ('00000000-0000-0000-0000-000000000003', 'Carlos Trainer',  'carlos@gym.com');

-- UPDATE trainers SET supervisor_id = '00000000-0000-0000-0000-000000000001'
--     WHERE trainer_id = '00000000-0000-0000-0000-000000000002';
-- UPDATE trainers SET supervisor_id = '00000000-0000-0000-0000-000000000002'
--     WHERE trainer_id = '00000000-0000-0000-0000-000000000003';

-- -- Consulta recursiva: árbol completo desde la raíz
-- WITH RECURSIVE trainer_tree AS (
--     -- Caso base: entrenadores sin supervisor (raíz del árbol)
--     SELECT
--         trainer_id,
--         trainer_name,
--         supervisor_id,
--         1 AS level,
--         trainer_name AS path
--     FROM trainers
--     WHERE supervisor_id IS NULL

--     UNION ALL

--     -- Paso recursivo: agrega el nivel siguiente
--     SELECT
--         t.trainer_id,
--         t.trainer_name,
--         t.supervisor_id,
--         tt.level + 1,
--         tt.path || ' → ' || t.trainer_name
--     FROM trainers          AS t
--     JOIN trainer_tree      AS tt ON tt.trainer_id = t.supervisor_id
-- )
-- SELECT level, path, trainer_name
-- FROM trainer_tree
-- ORDER BY path;
```

---

## Paso 8 — Verificar con EXPLAIN ANALYZE

Comprueba que los índices se usan en las queries reales:

```sql
-- ============================================================
-- PASO 8: Verificar planes de ejecución
-- ============================================================

-- -- Query 1: buscar clases de un entrenador específico
-- EXPLAIN ANALYZE
-- SELECT c.class_name, c.class_capacity
-- FROM classes AS c
-- WHERE c.trainer_id = '00000000-0000-0000-0000-000000000002';
-- -- Esperado: "Index Scan using ix_classes_trainer_id"

-- -- Query 2: inscripciones activas de un socio
-- EXPLAIN ANALYZE
-- SELECT e.enrollment_id, e.enrollment_date
-- FROM enrollments AS e
-- WHERE e.member_id = '...'
--   AND e.cancelled_at IS NULL;
-- -- Esperado: "Index Scan using ix_enrollments_active"
```

---

## Resultado Final Esperado

Después de completar todos los pasos, tu esquema GymPro v2 debe cumplir:

| Categoría | Antes | Después |
|-----------|-------|---------|
| Nomenclatura | español, `id` genérico | inglés, UUID, prefijos |
| Tipos de datos | SERIAL, TIMESTAMP | UUID, TIMESTAMPTZ |
| Integridad | sin NOT NULL, sin ON DELETE | completo |
| Soft delete | DELETE físico | `cancelled_at` + índice parcial |
| Índices | ninguno | 5 índices justificados |
| Objetos avanzados | ninguno | vista + trigger + WITH RECURSIVE |

---

← [Teoría — Presentación de Diseños](../1-teoria/03-presentacion-disenos.md) | → [Proyecto Final](../3-proyecto/README.md)
