-- ============================================================
-- PROYECTO SEMANA 13 — ContentHub
-- Sistema de gestión de contenido (CMS) multi-tenant
-- con soft delete, auditoría e historial, jerarquías y RLS
--
-- Alumno: _______________________
-- Fecha:  _______________________
--
-- Instrucciones:
--   Lee cada bloque TODO, implementa el código SQL que se pide
--   y ejecuta el script completo en PostgreSQL 16+.
--   Las secciones BASE ya están implementadas para ti.
-- ============================================================

-- ============================================================
-- PARTE 0 — Schema de trabajo
-- ============================================================
DROP SCHEMA IF EXISTS contenthub CASCADE;
CREATE SCHEMA contenthub;
SET search_path = contenthub;

-- ============================================================
-- PARTE 1 — Tablas base (ya implementadas)
-- ============================================================

-- Tabla de tenants (empresas suscritas al SaaS)
CREATE TABLE tenants (
    tenant_id       UUID            NOT NULL DEFAULT gen_random_uuid(),
    tenant_name     VARCHAR(100)    NOT NULL,
    tenant_slug     VARCHAR(60)     NOT NULL,
    tenant_plan     VARCHAR(20)     NOT NULL DEFAULT 'free'
                        CHECK (tenant_plan IN ('free', 'pro', 'enterprise')),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_tenants           PRIMARY KEY (tenant_id),
    CONSTRAINT uq_tenants_slug      UNIQUE (tenant_slug)
);

-- Tabla de autores (usuarios que escriben artículos)
CREATE TABLE authors (
    author_id       UUID            NOT NULL DEFAULT gen_random_uuid(),
    tenant_id       UUID            NOT NULL,
    author_name     VARCHAR(100)    NOT NULL,
    author_email    VARCHAR(150)    NOT NULL,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_authors           PRIMARY KEY (author_id),
    CONSTRAINT fk_authors_tenant    FOREIGN KEY (tenant_id)
        REFERENCES tenants (tenant_id) ON DELETE CASCADE,
    CONSTRAINT uq_authors_email     UNIQUE (author_id, author_email)
);

-- Insertar tenants y autores de prueba (datos base)
INSERT INTO tenants (tenant_id, tenant_name, tenant_slug, tenant_plan) VALUES
    ('10000000-0000-0000-0000-000000000001', 'TechBlog S.A.',   'techblog',  'pro'),
    ('10000000-0000-0000-0000-000000000002', 'Noticias Digital', 'noticiasdigital', 'enterprise');

INSERT INTO authors (author_id, tenant_id, author_name, author_email) VALUES
    ('20000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'Ana García',    'ana@techblog.com'),
    ('20000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', 'Carlos López',  'carlos@techblog.com'),
    ('20000000-0000-0000-0000-000000000003', '10000000-0000-0000-0000-000000000002', 'María Pérez',   'maria@noticias.com');

-- ============================================================
-- PARTE 2 — Tabla categories con jerarquía (adjacency list)
-- ============================================================

-- TODO: Crear la tabla categories con las siguientes columnas:
--   - category_id  UUID PK DEFAULT gen_random_uuid()
--   - tenant_id    UUID NOT NULL FK → tenants(tenant_id) ON DELETE CASCADE
--   - parent_id    UUID FK → categories(category_id) ON DELETE RESTRICT (puede ser NULL)
--   - category_name VARCHAR(80) NOT NULL
--   - created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
--   Nombres de constraints: pk_categories, fk_categories_tenant, fk_categories_parent
--   Agregar un índice: ix_categories_tenant_id para eficiencia en queries de tenant



-- TODO: Insertar las siguientes categorías para el tenant 'TechBlog' (tenant_id 10000000-...001):
--   Raíz:          Tecnología           (id: 30000000-...001, parent_id: NULL)
--   Hijos de Tecnología:
--                  Software             (id: 30000000-...002, parent: ...001)
--                  Hardware             (id: 30000000-...003, parent: ...001)
--   Hijo de Software:
--                  Bases de Datos       (id: 30000000-...004, parent: ...002)
--                  Programación         (id: 30000000-...005, parent: ...002)



-- ============================================================
-- PARTE 3 — Tabla articles con soft delete y auditoría
-- ============================================================

-- TODO: Crear la tabla articles con las siguientes columnas:
--   - article_id       UUID PK DEFAULT gen_random_uuid()
--   - tenant_id        UUID NOT NULL FK → tenants(tenant_id) ON DELETE CASCADE
--   - author_id        UUID NOT NULL FK → authors(author_id) ON DELETE RESTRICT
--   - category_id      UUID NOT NULL FK → categories(category_id) ON DELETE RESTRICT
--   - article_title    VARCHAR(300) NOT NULL
--   - article_slug     VARCHAR(200) NOT NULL
--   - article_content  TEXT
--   - article_status   VARCHAR(20) NOT NULL DEFAULT 'draft'
--                      CHECK: 'draft', 'published', 'archived'
--   - published_at     TIMESTAMPTZ (puede ser NULL)
--   - created_by       UUID FK → authors(author_id) ON DELETE SET NULL
--   - updated_by       UUID FK → authors(author_id) ON DELETE SET NULL
--   - created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
--   - updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
--   - deleted_at       TIMESTAMPTZ (NULL = activo, NOT NULL = eliminado lógicamente)
--   Constraints nombradas: pk_articles, fk_articles_tenant, fk_articles_author,
--                          fk_articles_category, fk_articles_created_by, fk_articles_updated_by



-- TODO: Crear un índice parcial que garantice que article_slug
--   sea único POR TENANT pero solo entre artículos ACTIVOS (deleted_at IS NULL).
--   Nombre del índice: uq_articles_active_slug
--   Hint: CREATE UNIQUE INDEX ... ON articles (tenant_id, article_slug) WHERE deleted_at IS NULL;



-- ============================================================
-- PARTE 4 — Vista de artículos activos
-- ============================================================

-- TODO: Crear la vista vw_active_articles que muestre todos los artículos
--   donde deleted_at IS NULL. Incluir todas las columnas de articles
--   EXCEPTO deleted_at (la vista no debe exponer esa columna).



-- ============================================================
-- PARTE 5 — Trigger de auditoría (updated_at y updated_by)
-- ============================================================

-- TODO: Crear la función fn_trg_set_audit() que:
--   1. Asigne NEW.updated_at = NOW()
--   2. Intente leer current_setting('app.current_user_id', true)::UUID
--      y lo asigne a NEW.updated_by (si el setting existe y no está vacío)
--   3. Retorne NEW
--   Usar LANGUAGE plpgsql. El segundo argumento 'true' en current_setting
--   hace que no falle si el setting no existe (retorna NULL en su lugar).



-- TODO: Crear el trigger trg_articles_audit como BEFORE UPDATE en articles
--   que ejecute fn_trg_set_audit() FOR EACH ROW.



-- ============================================================
-- PARTE 6 — Tabla y trigger de historial de artículos
-- ============================================================

-- TODO: Crear la tabla articles_history con:
--   - history_id           UUID PK DEFAULT gen_random_uuid()
--   - history_operation    TEXT NOT NULL CHECK ('INSERT','UPDATE','DELETE')
--   - history_changed_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
--   - history_changed_by   TEXT NOT NULL DEFAULT current_user
--   - TODAS las columnas de articles (con los mismos tipos, sin constraints)
--   Nombre del PK: pk_articles_history



-- TODO: Crear la función fn_trg_articles_history() que:
--   - En DELETE: inserta en articles_history con los valores de OLD y operation='DELETE'
--   - En INSERT/UPDATE: inserta en articles_history con los valores de NEW y TG_OP
--   - Retorna NULL (trigger AFTER)



-- TODO: Crear el trigger trg_articles_history como AFTER INSERT OR UPDATE OR DELETE
--   en articles que ejecute fn_trg_articles_history() FOR EACH ROW.



-- ============================================================
-- PARTE 7 — Row Level Security (multi-tenancy)
-- ============================================================

-- TODO: Habilitar Row Level Security en las tablas articles y categories.
--   Hint: ALTER TABLE articles ENABLE ROW LEVEL SECURITY;



-- TODO: Crear las políticas RLS para articles y categories que filtren
--   filas donde tenant_id = current_setting('app.tenant_id')::UUID
--   Nombres: policy_articles_tenant, policy_categories_tenant
--   Hint: CREATE POLICY ... ON articles USING (tenant_id = current_setting('app.tenant_id')::UUID);



-- ============================================================
-- PARTE 8 — Datos de prueba
-- ============================================================

-- TODO: Insertar al menos 3 artículos para el tenant TechBlog:
--   - Artículo 1: "Introducción a PostgreSQL 16" en categoría Bases de Datos, status='published'
--   - Artículo 2: "Soft Delete: el patrón imprescindible" en categoría Software, status='published'
--   - Artículo 3: "Guía de compra de laptops 2026" en categoría Hardware, status='draft'
--   Usa author_id = 20000000-...001 (Ana García)
--   Recuerda asignar created_by y updated_by también.



-- ============================================================
-- PARTE 9 — Consultas de verificación y requerimientos
-- ============================================================

-- TODO: Escribir la consulta WITH RECURSIVE que devuelva el breadcrumb
--   completo (ruta de categorías) para el artículo "Soft Delete: el patrón imprescindible".
--   El resultado debe mostrar algo como:
--   Tecnología → Software
--   Hint: navega categories desde la categoría del artículo hasta la raíz.



-- TODO: Demostrar el soft delete:
--   1. Elimina lógicamente el artículo "Guía de compra de laptops 2026"
--      (UPDATE articles SET deleted_at = NOW() WHERE ...)
--   2. Verifica que vw_active_articles ya no lo muestra
--   3. Verifica que el artículo sigue en la tabla articles
--   4. Verifica que articles_history registró el UPDATE



-- TODO: Demostrar la reutilización de slug con índice parcial:
--   1. Toma nota del slug del artículo recién eliminado
--   2. Inserta un NUEVO artículo con el MISMO tenant_id y el MISMO slug
--   3. El insert debe funcionar (el índice parcial ignora los eliminados)



-- TODO: Demostrar la política RLS:
--   1. Configura el tenant activo: SET LOCAL app.tenant_id = '10000000-...001';
--   2. Consulta SELECT * FROM articles; — debe mostrar solo artículos de TechBlog
--   3. Cambia a: SET LOCAL app.tenant_id = '10000000-...002';
--   4. Consulta SELECT * FROM articles; — debe mostrar 0 artículos (tenant sin datos)



-- TODO: Consulta point-in-time:
--   Recupera el título del primer artículo tal como estaba hace 1 minuto.
--   Hint: SELECT * FROM articles_history WHERE article_id = '...'
--         AND history_changed_at <= NOW() - INTERVAL '1 minute'
--         ORDER BY history_changed_at DESC LIMIT 1;



-- ============================================================
-- FIN DEL SCRIPT — Verificación general
-- ============================================================

-- Resumen de objetos creados:
SELECT
    schemaname,
    tablename   AS object_name,
    'TABLE'     AS object_type
FROM pg_tables
WHERE schemaname = 'contenthub'
UNION ALL
SELECT
    schemaname,
    viewname,
    'VIEW'
FROM pg_views
WHERE schemaname = 'contenthub'
ORDER BY object_type, object_name;
