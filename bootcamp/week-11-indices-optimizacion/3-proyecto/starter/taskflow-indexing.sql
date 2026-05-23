-- ============================================================
-- PROYECTO SEMANA 11: Estrategia de Indexación para TaskFlow
-- Sistema de gestión de proyectos y tareas
-- PostgreSQL 16+
-- ============================================================


-- ============================================================
-- PARTE 1: ESQUEMA COMPLETO DE TASKFLOW
-- ============================================================

DROP SCHEMA IF EXISTS taskflow CASCADE;
CREATE SCHEMA taskflow;
SET search_path = taskflow;

-- Organizaciones
CREATE TABLE organizations (
    organization_id   UUID          NOT NULL DEFAULT gen_random_uuid(),
    organization_name VARCHAR(120)  NOT NULL,
    organization_slug VARCHAR(80)   NOT NULL,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_organizations  PRIMARY KEY (organization_id),
    CONSTRAINT uq_organizations_slug UNIQUE (organization_slug)
);

-- Miembros (usuarios)
CREATE TABLE members (
    member_id    UUID         NOT NULL DEFAULT gen_random_uuid(),
    member_email VARCHAR(150) NOT NULL,
    member_name  VARCHAR(100) NOT NULL,
    is_active    BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_members  PRIMARY KEY (member_id),
    CONSTRAINT uq_members_email UNIQUE (member_email)
);

-- Proyectos
CREATE TABLE projects (
    project_id       UUID         NOT NULL DEFAULT gen_random_uuid(),
    organization_id  UUID         NOT NULL,
    project_name     VARCHAR(120) NOT NULL,
    project_status   VARCHAR(20)  NOT NULL DEFAULT 'active'
        CHECK (project_status IN ('active', 'archived', 'deleted')),
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_projects        PRIMARY KEY (project_id),
    CONSTRAINT fk_projects_org_id FOREIGN KEY (organization_id)
        REFERENCES organizations (organization_id) ON DELETE CASCADE
);

-- Miembros de proyectos
CREATE TABLE project_members (
    project_id UUID        NOT NULL,
    member_id  UUID        NOT NULL,
    role       VARCHAR(20) NOT NULL DEFAULT 'member'
        CHECK (role IN ('owner', 'admin', 'member', 'viewer')),
    joined_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_project_members             PRIMARY KEY (project_id, member_id),
    CONSTRAINT fk_project_members_project_id  FOREIGN KEY (project_id)
        REFERENCES projects (project_id) ON DELETE CASCADE,
    CONSTRAINT fk_project_members_member_id   FOREIGN KEY (member_id)
        REFERENCES members (member_id) ON DELETE CASCADE
);

-- Etiquetas
CREATE TABLE labels (
    label_id    UUID        NOT NULL DEFAULT gen_random_uuid(),
    project_id  UUID        NOT NULL,
    label_name  VARCHAR(50) NOT NULL,
    label_color VARCHAR(7)  NOT NULL DEFAULT '#89b4fa',
    CONSTRAINT pk_labels            PRIMARY KEY (label_id),
    CONSTRAINT fk_labels_project_id FOREIGN KEY (project_id)
        REFERENCES projects (project_id) ON DELETE CASCADE
);

-- Tareas
CREATE TABLE tasks (
    task_id       UUID         NOT NULL DEFAULT gen_random_uuid(),
    project_id    UUID         NOT NULL,
    assignee_id   UUID,
    task_title    VARCHAR(200) NOT NULL,
    task_status   VARCHAR(20)  NOT NULL DEFAULT 'backlog'
        CHECK (task_status IN ('backlog', 'todo', 'in_progress', 'review', 'done', 'cancelled')),
    task_priority SMALLINT     NOT NULL DEFAULT 3
        CHECK (task_priority BETWEEN 1 AND 5),
    due_date      DATE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_tasks             PRIMARY KEY (task_id),
    CONSTRAINT fk_tasks_project_id  FOREIGN KEY (project_id)
        REFERENCES projects (project_id) ON DELETE CASCADE,
    CONSTRAINT fk_tasks_assignee_id FOREIGN KEY (assignee_id)
        REFERENCES members (member_id) ON DELETE SET NULL
);

-- Etiquetas de tareas (tabla de unión)
CREATE TABLE task_labels (
    task_id  UUID NOT NULL,
    label_id UUID NOT NULL,
    CONSTRAINT pk_task_labels             PRIMARY KEY (task_id, label_id),
    CONSTRAINT fk_task_labels_task_id     FOREIGN KEY (task_id)
        REFERENCES tasks (task_id) ON DELETE CASCADE,
    CONSTRAINT fk_task_labels_label_id    FOREIGN KEY (label_id)
        REFERENCES labels (label_id) ON DELETE CASCADE
);

-- Comentarios de tareas
CREATE TABLE task_comments (
    comment_id   UUID  NOT NULL DEFAULT gen_random_uuid(),
    task_id      UUID  NOT NULL,
    author_id    UUID  NOT NULL,
    comment_body TEXT  NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_task_comments            PRIMARY KEY (comment_id),
    CONSTRAINT fk_task_comments_task_id    FOREIGN KEY (task_id)
        REFERENCES tasks (task_id) ON DELETE CASCADE,
    CONSTRAINT fk_task_comments_author_id  FOREIGN KEY (author_id)
        REFERENCES members (member_id) ON DELETE CASCADE
);


-- ============================================================
-- PARTE 2: DATOS DE PRUEBA — 50 000 TAREAS
-- Tiempo estimado: ~15 segundos
-- ============================================================

-- Insertar 1 organización
INSERT INTO organizations (organization_name, organization_slug)
VALUES ('Acme Corp', 'acme-corp');

-- Insertar 100 miembros
INSERT INTO members (member_email, member_name)
SELECT
    'user' || n || '@acme.test',
    'User ' || n
FROM generate_series(1, 100) AS n;

-- Insertar 20 proyectos
INSERT INTO projects (organization_id, project_name)
SELECT
    (SELECT organization_id FROM organizations LIMIT 1),
    'Project ' || n
FROM generate_series(1, 20) AS n;

-- Insertar miembros en proyectos (todos los miembros en todos los proyectos)
INSERT INTO project_members (project_id, member_id, role)
SELECT
    p.project_id,
    m.member_id,
    'member'
FROM projects AS p
CROSS JOIN members AS m;

-- Insertar 5 etiquetas por proyecto
INSERT INTO labels (project_id, label_name, label_color)
SELECT
    p.project_id,
    label_name,
    label_color
FROM projects AS p
CROSS JOIN (
    VALUES
        ('bug',      '#f38ba8'),
        ('feature',  '#a6e3a1'),
        ('docs',     '#89b4fa'),
        ('chore',    '#f9e2af'),
        ('question', '#cba6f7')
) AS l(label_name, label_color);

-- Insertar 50 000 tareas
INSERT INTO tasks (
    project_id,
    assignee_id,
    task_title,
    task_status,
    task_priority,
    due_date,
    created_at
)
SELECT
    (
        SELECT project_id FROM projects
        ORDER BY random() LIMIT 1
    ),
    CASE WHEN random() > 0.1
        THEN (SELECT member_id FROM members ORDER BY random() LIMIT 1)
        ELSE NULL
    END,
    'Task #' || n || ' — ' || (
        ARRAY['Implement', 'Fix', 'Review', 'Document', 'Test']
    )[floor(random() * 5 + 1)::int] || ' ' ||
    (
        ARRAY['login', 'dashboard', 'API', 'export', 'search', 'notifications', 'settings']
    )[floor(random() * 7 + 1)::int],
    (ARRAY['backlog', 'todo', 'in_progress', 'review', 'done', 'cancelled'])[
        floor(random() * 6 + 1)::int
    ],
    floor(random() * 5 + 1)::SMALLINT,
    CASE WHEN random() > 0.3
        THEN CURRENT_DATE + (random() * 60 - 30)::INT
        ELSE NULL
    END,
    NOW() - (random() * INTERVAL '180 days')
FROM generate_series(1, 50000) AS n;

-- Insertar comentarios (2 por tarea en promedio, para 10 000 tareas)
INSERT INTO task_comments (task_id, author_id, comment_body, created_at)
SELECT
    t.task_id,
    (SELECT member_id FROM members ORDER BY random() LIMIT 1),
    'Comentario de prueba para análisis de rendimiento ' || generate_series,
    NOW() - (random() * INTERVAL '90 days')
FROM (
    SELECT task_id FROM tasks ORDER BY random() LIMIT 10000
) AS t
CROSS JOIN generate_series(1, 2);

-- Asignar etiquetas aleatorias a tareas (1 por tarea al azar)
INSERT INTO task_labels (task_id, label_id)
SELECT DISTINCT ON (t.task_id)
    t.task_id,
    l.label_id
FROM tasks AS t
JOIN labels AS l ON l.project_id = t.project_id
ORDER BY t.task_id, random();

-- Actualizar estadísticas
ANALYZE;


-- ============================================================
-- PARTE 3: CONSULTAS SIN ÍNDICES — MEDIR EL COSTO BASE
-- Ejecuta cada bloque y anota el plan de ejecución completo.
-- ============================================================

-- Q1: Tareas asignadas a un miembro
-- (sustituye el UUID por uno real de la tabla members)
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    task_id, task_title, task_status, task_priority, due_date
FROM tasks
WHERE assignee_id = (SELECT member_id FROM members LIMIT 1);

-- Q2: Tareas activas de un proyecto ordenadas por prioridad
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    task_id, task_title, task_priority, due_date
FROM tasks
WHERE project_id = (SELECT project_id FROM projects LIMIT 1)
  AND task_status = 'in_progress'
ORDER BY task_priority;

-- Q3: Comentarios recientes de una tarea
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    comment_id, author_id, comment_body, created_at
FROM task_comments
WHERE task_id = (SELECT task_id FROM tasks LIMIT 1)
ORDER BY created_at DESC;

-- Q4: Proyectos de una organización
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    project_id, project_name, project_status, created_at
FROM projects
WHERE organization_id = (SELECT organization_id FROM organizations LIMIT 1);

-- Q5: Tareas con status 'backlog' en toda la base de datos (baja selectividad)
EXPLAIN (ANALYZE, BUFFERS)
SELECT task_id, project_id, task_title
FROM tasks
WHERE task_status = 'backlog';

-- Q6: Miembros de un proyecto
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    m.member_id, m.member_name, m.member_email, pm.role
FROM project_members AS pm
JOIN members          AS m ON m.member_id = pm.member_id
WHERE pm.project_id = (SELECT project_id FROM projects LIMIT 1);

-- Q7: Tareas con una etiqueta específica
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    t.task_id, t.task_title, t.task_status
FROM task_labels  AS tl
JOIN tasks        AS t ON t.task_id  = tl.task_id
WHERE tl.label_id = (SELECT label_id FROM labels LIMIT 1);

-- Q8: Tareas vencidas que siguen activas
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    task_id, project_id, assignee_id, task_title, due_date
FROM tasks
WHERE due_date < CURRENT_DATE
  AND task_status NOT IN ('done', 'cancelled');


-- ============================================================
-- PARTE 4: CREAR LOS ÍNDICES JUSTIFICADOS
-- ============================================================
-- Instrucciones:
-- 1. Analiza el plan de cada consulta en la PARTE 3.
-- 2. Crea los índices necesarios con la nomenclatura: ix_tabla_columna
-- 3. Añade un comentario por cada índice explicando qué consulta mejora
--    y por qué ese tipo de índice es el correcto.
-- 4. Para Q8, usa un índice PARCIAL con cláusula WHERE.
-- 5. Para Q5, NO crees un índice — explica por qué en un comentario.

-- TODO: Crea aquí tus índices. Ejemplo de estructura esperada:

-- CREATE INDEX ix_tasks_assignee_id
--     ON tasks (assignee_id);
-- -- Por qué: Q1 filtra por assignee_id. Es FK y tiene alta selectividad.

-- TODO: índice para Q2 (compuesto project_id + status + prioridad)

-- TODO: índice para Q3 (task_id en task_comments + created_at DESC)

-- TODO: índice para Q4 (organization_id en projects)

-- TODO: comentario justificando POR QUÉ no crear índice para Q5

-- TODO: índice para Q6 (project_id en project_members, si no está cubierto por PK)

-- TODO: índice para Q7 (label_id en task_labels, si no está cubierto por PK)

-- TODO: índice PARCIAL para Q8 (due_date WHERE task_status NOT IN (...))


-- ============================================================
-- PARTE 5: CONSULTAS CON ÍNDICES — COMPARAR EL COSTO
-- Ejecuta las mismas consultas del PARTE 3 sin modificarlas.
-- ============================================================

-- Q1: (idéntica a la de PARTE 3)
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    task_id, task_title, task_status, task_priority, due_date
FROM tasks
WHERE assignee_id = (SELECT member_id FROM members LIMIT 1);

-- Q2:
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    task_id, task_title, task_priority, due_date
FROM tasks
WHERE project_id = (SELECT project_id FROM projects LIMIT 1)
  AND task_status = 'in_progress'
ORDER BY task_priority;

-- Q3:
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    comment_id, author_id, comment_body, created_at
FROM task_comments
WHERE task_id = (SELECT task_id FROM tasks LIMIT 1)
ORDER BY created_at DESC;

-- Q4:
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    project_id, project_name, project_status, created_at
FROM projects
WHERE organization_id = (SELECT organization_id FROM organizations LIMIT 1);

-- Q5:
EXPLAIN (ANALYZE, BUFFERS)
SELECT task_id, project_id, task_title
FROM tasks
WHERE task_status = 'backlog';

-- Q6:
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    m.member_id, m.member_name, m.member_email, pm.role
FROM project_members AS pm
JOIN members          AS m ON m.member_id = pm.member_id
WHERE pm.project_id = (SELECT project_id FROM projects LIMIT 1);

-- Q7:
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    t.task_id, t.task_title, t.task_status
FROM task_labels  AS tl
JOIN tasks        AS t ON t.task_id  = tl.task_id
WHERE tl.label_id = (SELECT label_id FROM labels LIMIT 1);

-- Q8:
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    task_id, project_id, assignee_id, task_title, due_date
FROM tasks
WHERE due_date < CURRENT_DATE
  AND task_status NOT IN ('done', 'cancelled');


-- ============================================================
-- TODO: TABLA DE RESULTADOS
-- Completa los valores con los tiempos reales que obtuviste.
-- ============================================================

-- | Q# | Nodo antes       | ms antes | Nodo después       | ms después | Mejora |
-- |----|------------------|----------|--------------------|------------|--------|
-- | Q1 |                  |          |                    |            |        |
-- | Q2 |                  |          |                    |            |        |
-- | Q3 |                  |          |                    |            |        |
-- | Q4 |                  |          |                    |            |        |
-- | Q5 |                  |          | (sin cambio)       |            | N/A    |
-- | Q6 |                  |          |                    |            |        |
-- | Q7 |                  |          |                    |            |        |
-- | Q8 |                  |          |                    |            |        |


-- ============================================================
-- VERIFICACIÓN FINAL: uso de índices
-- ============================================================
SELECT
    indexrelname                                AS indice,
    idx_scan                                    AS veces_usado,
    pg_size_pretty(pg_relation_size(indexrelid)) AS tamanio
FROM pg_stat_user_indexes
WHERE schemaname = 'taskflow'
ORDER BY idx_scan DESC, pg_relation_size(indexrelid) DESC;
