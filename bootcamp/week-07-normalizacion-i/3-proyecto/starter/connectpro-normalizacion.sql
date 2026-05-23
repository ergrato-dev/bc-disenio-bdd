-- ============================================================
-- PROYECTO SEMANA 07: ConnectPro — Normalización 1FN y 2FN
-- ============================================================
-- Instrucciones:
--   1. Lee el README del proyecto antes de empezar
--   2. Completa cada sección marcada con -- TODO:
--   3. Ejecuta el script completo sin errores en PostgreSQL 16+
--   4. Responde las preguntas de reflexión al final del archivo
-- ============================================================

-- ============================================================
-- SECCIÓN 0: Mapa de dependencias funcionales (COMPLETA ESTO)
-- ============================================================
-- Documenta aquí las FDs que identificas antes y después:
--
-- ANTES (violaciones):
-- TODO: listar todas las FDs de la tabla users
--   Ej: user_id → user_name, user_email, user_skills_text
--
-- TODO: listar todas las FDs de la tabla job_applications
--   Ej: {user_id, job_posting_id} → applied_at  (COMPLETA)
--        job_posting_id → company_name           (PARCIAL ❌)
--
-- DESPUÉS (modelo corregido):
-- TODO: listar las FDs de cada tabla del modelo final
-- ============================================================


-- ============================================================
-- SECCIÓN 1: Setup inicial — esquema con violaciones
-- ============================================================
-- Ejecuta este bloque tal como está. NO lo modifiques.
-- Representa el estado actual de la base de datos de ConnectPro.

DROP TABLE IF EXISTS job_applications CASCADE;
DROP TABLE IF EXISTS job_postings      CASCADE;
DROP TABLE IF EXISTS users             CASCADE;

CREATE TABLE users (
    user_id          UUID         NOT NULL DEFAULT gen_random_uuid(),
    user_name        VARCHAR(100) NOT NULL,
    user_email       VARCHAR(150) NOT NULL,
    user_skills_text TEXT,          -- "SQL, Python, PostgreSQL, Docker"  ← viola 1FN
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_users       PRIMARY KEY (user_id),
    CONSTRAINT uq_users_email UNIQUE (user_email)
);

CREATE TABLE job_postings (
    job_posting_id   UUID         NOT NULL DEFAULT gen_random_uuid(),
    job_title        VARCHAR(150) NOT NULL,
    job_description  TEXT,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_job_postings PRIMARY KEY (job_posting_id)
);

-- PK compuesta con dependencia PARCIAL: company_name depende solo de job_posting_id
CREATE TABLE job_applications (
    user_id         UUID         NOT NULL,
    job_posting_id  UUID         NOT NULL,
    company_name    VARCHAR(100),  -- depende solo de job_posting_id ← viola 2FN
    applied_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_job_applications
        PRIMARY KEY (user_id, job_posting_id),
    CONSTRAINT fk_job_applications_user_id
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_job_applications_job_posting_id
        FOREIGN KEY (job_posting_id) REFERENCES job_postings(job_posting_id)
        ON DELETE CASCADE
);

-- Datos de prueba
INSERT INTO users (user_id, user_name, user_email, user_skills_text) VALUES
    ('11111111-0000-0000-0000-000000000001', 'Ana López',  'ana@connectpro.com',   'SQL, Python, PostgreSQL'),
    ('11111111-0000-0000-0000-000000000002', 'Beto Ruiz',  'beto@connectpro.com',  'Docker, Kubernetes, Linux'),
    ('11111111-0000-0000-0000-000000000003', 'Carla Vega', 'carla@connectpro.com', 'Python, Machine Learning, SQL');

INSERT INTO job_postings (job_posting_id, job_title) VALUES
    ('22222222-0000-0000-0000-000000000001', 'Data Engineer'),
    ('22222222-0000-0000-0000-000000000002', 'Backend Developer'),
    ('22222222-0000-0000-0000-000000000003', 'DevOps Engineer');

INSERT INTO job_applications (user_id, job_posting_id, company_name) VALUES
    ('11111111-0000-0000-0000-000000000001', '22222222-0000-0000-0000-000000000001', 'TechCorp SA'),
    ('11111111-0000-0000-0000-000000000001', '22222222-0000-0000-0000-000000000002', 'StartupXYZ'),
    ('11111111-0000-0000-0000-000000000002', '22222222-0000-0000-0000-000000000002', 'StartupXYZ'),
    ('11111111-0000-0000-0000-000000000003', '22222222-0000-0000-0000-000000000001', 'TechCorp SA'),
    ('11111111-0000-0000-0000-000000000003', '22222222-0000-0000-0000-000000000003', 'InfraCloud');


-- ============================================================
-- DIAGNÓSTICO: ejecuta estas consultas ANTES de corregir
-- ============================================================

-- ¿Cuántos usuarios tienen más de una habilidad en user_skills_text?
-- SELECT user_id, user_name, user_skills_text
-- FROM users
-- WHERE user_skills_text LIKE '%,%';

-- ¿Se repite company_name para el mismo job_posting_id?
-- SELECT job_posting_id, COUNT(DISTINCT company_name) AS empresas
-- FROM job_applications
-- GROUP BY job_posting_id
-- HAVING COUNT(DISTINCT company_name) > 1;


-- ============================================================
-- SECCIÓN 2: Corregir violación 1FN — extraer user_skills
-- ============================================================

-- TODO: Crear la tabla user_skills
-- Debe cumplir:
--   - PK: user_skill_id UUID
--   - FK: user_id referencia a users(user_id) ON DELETE CASCADE
--   - Columna: user_skill_name VARCHAR(80) NOT NULL
--   - Columna: created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
--   - Constraint de nombre: pk_user_skills, fk_user_skills_user_id

-- CREATE TABLE user_skills (
--     ...
-- );


-- TODO: Migrar los datos desde users.user_skills_text
-- Pista: usa regexp_split_to_table(user_skills_text, ',\s*')
-- para separar las habilidades en filas individuales

-- INSERT INTO user_skills (user_id, user_skill_name)
-- SELECT
--     user_id,
--     TRIM(skill) AS user_skill_name
-- FROM users,
--      regexp_split_to_table(user_skills_text, ',\s*') AS skill
-- WHERE user_skills_text IS NOT NULL;


-- TODO: Verificar la migración
-- La consulta siguiente debe devolver los mismos datos que la
-- columna user_skills_text, pero en formato normalizado (1 fila = 1 skill)

-- SELECT u.user_name, s.user_skill_name
-- FROM users u
-- JOIN user_skills s ON s.user_id = u.user_id
-- ORDER BY u.user_name, s.user_skill_name;


-- TODO: (Opcional) Eliminar la columna user_skills_text de users
-- una vez verificada la migración

-- ALTER TABLE users DROP COLUMN user_skills_text;


-- ============================================================
-- SECCIÓN 3: Corregir violación 2FN — extraer company a su tabla
-- ============================================================

-- TODO: Crear la tabla companies
-- Debe cumplir:
--   - PK: company_id UUID
--   - Columna: company_name VARCHAR(100) NOT NULL UNIQUE
--   - Columna: created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

-- CREATE TABLE companies (
--     ...
-- );


-- TODO: Agregar columna company_id a job_postings y job_applications
-- Luego migrar los datos desde job_applications.company_name

-- ALTER TABLE job_postings ADD COLUMN company_id UUID;
-- ALTER TABLE job_applications ADD COLUMN company_id UUID;


-- TODO: Migrar los datos de company_name → companies
-- Cada empresa única debe ser 1 fila en companies

-- INSERT INTO companies (company_name)
-- SELECT DISTINCT company_name
-- FROM job_applications
-- WHERE company_name IS NOT NULL;


-- TODO: Actualizar job_postings.company_id y job_applications.company_id
-- con el UUID de la empresa correspondiente

-- UPDATE job_postings jp
-- SET company_id = c.company_id
-- FROM job_applications ja
-- JOIN companies c ON c.company_name = ja.company_name
-- WHERE jp.job_posting_id = ja.job_posting_id;

-- UPDATE job_applications ja
-- SET company_id = c.company_id
-- FROM companies c
-- WHERE ja.company_name = c.company_name;


-- TODO: Agregar la FK de job_postings → companies

-- ALTER TABLE job_postings
--     ADD CONSTRAINT fk_job_postings_company_id
--         FOREIGN KEY (company_id) REFERENCES companies(company_id);


-- TODO: Eliminar la columna company_name de job_applications
-- una vez verificada la migración

-- ALTER TABLE job_applications DROP COLUMN company_name;


-- ============================================================
-- SECCIÓN 4: Verificación final
-- ============================================================

-- TODO: Escribe una consulta que reconstruya la vista original:
-- user_name | user_email | job_title | company_name | applied_at
-- usando las tablas del modelo corregido (sin usar la columna eliminada)

-- SELECT
--     u.user_name,
--     u.user_email,
--     jp.job_title,
--     c.company_name,
--     ja.applied_at
-- FROM job_applications ja
-- JOIN ...


-- TODO: Consulta que cuente cuántos usuarios tienen cada habilidad
-- (imposible de hacer eficientemente en el modelo violado)

-- SELECT ...


-- ============================================================
-- PREGUNTAS DE REFLEXIÓN (responde en comentarios SQL)
-- ============================================================

-- 1. ¿Qué anomalía ocurría si "TechCorp SA" cambia su nombre en el
--    modelo original con job_applications.company_name?

-- 2. ¿Por qué almacenar habilidades como "SQL, Python" en un TEXT viola
--    el principio de atomicidad de la 1FN? ¿Qué operaciones se vuelven
--    imposibles o muy costosas?

-- 3. En el modelo corregido, ¿es job_postings.company_id una FD completa
--    o parcial respecto a la PK de job_postings?

-- 4. ¿El modelo final está en 3FN? ¿Existe alguna dependencia transitiva
--    visible? Justifica tu respuesta.
