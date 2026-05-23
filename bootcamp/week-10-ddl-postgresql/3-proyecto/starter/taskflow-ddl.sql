-- ============================================================
-- PROYECTO SEMANA 10: TaskFlow — Sistema de Gestión de Proyectos
-- Bootcamp: Diseño de Bases de Datos Relacionales — Zero to Hero
-- ============================================================
--
-- INSTRUCCIONES:
--   1. Lee cada TODO y completa el código correspondiente.
--   2. Elige los tipos de datos aplicando la guía de la teoría.
--   3. Nombra todas las constraints con la convención del bootcamp:
--        PK: pk_{tabla}
--        FK: fk_{tabla}_{columna}
--        UQ: uq_{tabla}_{columna}
--        CK: ck_{tabla}_{descripcion}
--        IX: ix_{tabla}_{columna}
--   4. El script debe ser idempotente (CREATE ... IF NOT EXISTS).
--   5. Responde las 5 preguntas de diseño al inicio del script.
--
-- PREGUNTAS DE DISEÑO (responde aquí antes de escribir el DDL):
-- 1. ¿Qué tipo para task_priority? ¿Por qué no VARCHAR?
--    RESPUESTA: TODO
--
-- 2. ¿Por qué task_number usa GENERATED ALWAYS AS IDENTITY?
--    RESPUESTA: TODO
--
-- 3. ¿Qué tipo para label_color? ¿Cómo validas #RRGGBB?
--    RESPUESTA: TODO
--
-- 4. ON DELETE en task_labels.task_id y task_labels.label_id?
--    RESPUESTA: TODO
--
-- 5. ¿Por qué project_members tiene PK UUID propia?
--    RESPUESTA: TODO
-- ============================================================

BEGIN;

-- ============================================================
-- SCHEMA
-- ============================================================

-- TODO: Crear el schema 'taskflow' con IF NOT EXISTS
-- TODO: Establecer search_path a 'taskflow'



-- ============================================================
-- TABLA: organizations
-- Columnas: organization_id, org_name, org_slug, created_at
-- Hints:
--   - organization_id: PK, no predecible, generado por la BD
--   - org_name: texto con longitud máxima razonable, obligatorio
--   - org_slug: URL-friendly, máx. 50 chars, único, obligatorio
--   - created_at: momento del registro, con zona horaria
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para organizations
-- con las columnas, tipos y constraints correctos



-- ============================================================
-- TABLA: members
-- Columnas: member_id, organization_id (FK), member_name,
--           member_email, member_role, joined_at
-- Hints:
--   - member_role acepta solo: 'admin', 'manager', 'developer', 'viewer'
--   - email único dentro de cada organización (no globalmente)
--   - joined_at: timestamptz con default NOW()
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para members



-- ============================================================
-- TABLA: projects
-- Columnas: project_id, organization_id (FK), project_name,
--           project_key, project_status, owner_id (FK nullable),
--           starts_on, ends_on, created_at
-- Hints:
--   - project_key: código corto, máx. 10 chars, único por organización
--   - project_status: solo 'active', 'on_hold', 'completed', 'archived'
--   - starts_on, ends_on: solo fecha (sin hora)
--   - ends_on debe ser mayor que starts_on cuando ambos no son NULL
--   - owner_id: FK a members, puede ser NULL (SET NULL si miembro es borrado)
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para projects
-- Incluir CHECK para que ends_on > starts_on



-- ============================================================
-- TABLA: project_members
-- Columnas: project_member_id, project_id (FK), member_id (FK),
--           pm_role, joined_at
-- Hints:
--   - pm_role acepta: 'lead', 'developer', 'reviewer', 'observer'
--   - Un miembro no puede estar dos veces en el mismo proyecto (UNIQUE)
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para project_members



-- ============================================================
-- TABLA: labels
-- Columnas: label_id, project_id (FK), label_name, label_color
-- Hints:
--   - label_color: formato exacto '#RRGGBB' (7 caracteres fijos)
--   - Validar con regex: '^#[0-9A-Fa-f]{6}$'
--   - Un proyecto no puede tener dos etiquetas con el mismo nombre
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para labels
-- Incluir CHECK para validar formato hexadecimal del color



-- ============================================================
-- TABLA: tasks
-- Columnas: task_id, project_id (FK), task_number, task_title,
--           task_description, task_status, task_priority,
--           assignee_id (FK nullable), reporter_id (FK),
--           due_date, created_at, updated_at
-- Hints:
--   - task_id: UUID (identificador interno de API)
--   - task_number: entero secuencial VISIBLE al usuario
--     → usar BIGINT GENERATED ALWAYS AS IDENTITY
--   - task_title: texto, obligatorio, máx. 200 chars
--   - task_description: texto largo, opcional
--   - task_status: 'backlog', 'in_progress', 'in_review', 'done', 'cancelled'
--   - task_priority: número del 1 (crítica) al 4 (baja) — tipo entero pequeño
--   - assignee_id: FK a members, puede ser NULL (SET NULL si miembro borrado)
--   - reporter_id: FK a members, obligatorio (RESTRICT)
--   - due_date: solo fecha
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para tasks
-- Incluir CHECKs para status, priority (BETWEEN 1 AND 4)



-- ============================================================
-- TABLA: task_labels (N:M entre tasks y labels)
-- Columnas: task_id (FK), label_id (FK)
-- PK compuesta: (task_id, label_id)
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para task_labels
-- La PK es compuesta — no necesita columna id propia



-- ============================================================
-- TABLA: comments
-- Columnas: comment_id, task_id (FK), author_id (FK),
--           comment_body, created_at
-- Hints:
--   - comment_body: texto largo, obligatorio
--   - Si la tarea se borra, borrar también sus comentarios
--   - Si el autor se borra, NO permitir borrar (RESTRICT)
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para comments



-- ============================================================
-- TABLA: attachments
-- Columnas: attachment_id, task_id (FK), attachment_name,
--           attachment_size_bytes, uploaded_by (FK), uploaded_at
-- Hints:
--   - attachment_size_bytes: puede ser muy grande (archivos de GB)
--   - El tamaño debe ser mayor que 0
-- ============================================================

-- TODO: Escribir CREATE TABLE IF NOT EXISTS para attachments



-- ============================================================
-- ÍNDICES EN COLUMNAS FK
-- ============================================================

-- TODO: Crear un índice ix_{tabla}_{columna} para CADA columna FK
-- Usar CREATE INDEX IF NOT EXISTS
-- Tablas a indexar:
--   members.organization_id
--   projects.organization_id
--   projects.owner_id
--   project_members.project_id
--   project_members.member_id
--   labels.project_id
--   tasks.project_id
--   tasks.assignee_id
--   tasks.reporter_id
--   task_labels.task_id
--   task_labels.label_id
--   comments.task_id
--   comments.author_id
--   attachments.task_id
--   attachments.uploaded_by



-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

-- TODO: Insertar al menos 2 filas en cada tabla
-- Los datos deben ser coherentes y respetar todas las constraints
-- Sugerencia: usar CTEs o variables para reutilizar UUIDs



-- ============================================================
COMMIT;
-- ============================================================
