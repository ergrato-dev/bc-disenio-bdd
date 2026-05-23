-- ============================================================
-- PROYECTO FINAL — MediSync: Sistema de Gestión Hospitalaria
-- Bootcamp: Diseño de Bases de Datos Relacionales — Zero to Hero
-- Semana 14 de 14 — Capstone
-- ============================================================
-- Instrucciones:
-- 1. Lee el README.md de este proyecto antes de empezar.
-- 2. Completa cada TODO en orden. No adelantes partes si la
--    anterior no está funcionando.
-- 3. Ejecuta tu script sección por sección en pgAdmin o DBeaver.
-- 4. Al final, ejecuta todos los TODOs en orden desde cero para
--    verificar que el script completo es idempotente.
-- ============================================================


-- ============================================================
-- PARTE 0: Schema
-- ============================================================

DROP SCHEMA IF EXISTS medisync CASCADE;
CREATE SCHEMA medisync;
SET search_path TO medisync;


-- ============================================================
-- PARTE 1: Tabla departments (jerarquía con auto-referencia)
-- ============================================================
-- RF-01: Los departamentos tienen jerarquía arbórea indefinida.
-- Un departamento puede tener un padre (parent_id → departments).
-- La raíz del árbol tiene parent_id NULL.
-- ON DELETE RESTRICT: no se puede borrar un departamento con hijos.

-- TODO: Crear la tabla departments con las siguientes columnas:
--   - department_id      UUID, PK, auto-generado
--   - department_name    VARCHAR(100), obligatorio, único
--   - parent_id          UUID, nullable, FK → departments(department_id) ON DELETE RESTRICT
--   - created_at         TIMESTAMPTZ, obligatorio, default NOW()
-- Nombra todos los constraints con la convención del bootcamp.


-- ============================================================
-- PARTE 2: Tabla doctors (médicos con supervisor reflexivo)
-- ============================================================
-- RF-02: Un médico pertenece a un departamento.
-- Un médico puede supervisar a otros médicos (relación reflexiva).
-- Si el supervisor es dado de baja, supervisor_id pasa a NULL (ON DELETE SET NULL).
-- Soft delete: doctors tienen deleted_at para dar de baja sin perder datos.

-- TODO: Crear la tabla doctors con las siguientes columnas:
--   - doctor_id          UUID, PK, auto-generado
--   - department_id      UUID, obligatorio, FK → departments ON DELETE RESTRICT
--   - supervisor_id      UUID, nullable, FK reflexiva → doctors ON DELETE SET NULL
--   - doctor_name        VARCHAR(100), obligatorio
--   - doctor_email       VARCHAR(150), obligatorio, único
--   - doctor_specialty   VARCHAR(100), obligatorio
--   - deleted_at         TIMESTAMPTZ, nullable (soft delete)
--   - created_at         TIMESTAMPTZ, obligatorio, default NOW()
--   - updated_at         TIMESTAMPTZ, obligatorio, default NOW()
-- Nombra todos los constraints con la convención del bootcamp.


-- ============================================================
-- PARTE 3: Tabla patients (pacientes)
-- ============================================================
-- RF-03 (referencia): los pacientes son el otro extremo de la cita.
-- Soft delete: patients tienen deleted_at para anonimizar sin borrar.

-- TODO: Crear la tabla patients con las siguientes columnas:
--   - patient_id         UUID, PK, auto-generado
--   - patient_name       VARCHAR(100), obligatorio
--   - patient_email      VARCHAR(150), obligatorio, único
--   - patient_dob        DATE, obligatorio (fecha de nacimiento)
--   - deleted_at         TIMESTAMPTZ, nullable (soft delete)
--   - created_at         TIMESTAMPTZ, obligatorio, default NOW()
--   - updated_at         TIMESTAMPTZ, obligatorio, default NOW()
-- Nombra todos los constraints con la convención del bootcamp.


-- ============================================================
-- PARTE 4: Tabla appointments (citas con ciclo de vida)
-- ============================================================
-- RF-03: ciclo de vida: scheduled → confirmed → completed | cancelled
-- Soft delete: cancelled_at (no deleted_at, para diferenciar semánticamente).
-- Restricción: un médico no puede tener dos citas activas en el mismo momento
-- (implementar con UNIQUE parcial sobre doctor_id + appointment_date WHERE cancelled_at IS NULL).

-- TODO: Crear la tabla appointments con las siguientes columnas:
--   - appointment_id     UUID, PK, auto-generado
--   - patient_id         UUID, obligatorio, FK → patients ON DELETE RESTRICT
--   - doctor_id          UUID, obligatorio, FK → doctors ON DELETE RESTRICT
--   - appointment_date   TIMESTAMPTZ, obligatorio
--   - appointment_status VARCHAR(20), obligatorio, default 'scheduled'
--                        CHECK: solo 'scheduled', 'confirmed', 'completed', 'cancelled'
--   - cancelled_at       TIMESTAMPTZ, nullable (soft delete de citas canceladas)
--   - created_at         TIMESTAMPTZ, obligatorio, default NOW()
--   - updated_at         TIMESTAMPTZ, obligatorio, default NOW()
-- Nombra todos los constraints con la convención del bootcamp.
-- Crea también el UNIQUE parcial para evitar doble reserva de médico.


-- ============================================================
-- PARTE 5: Tablas medical_records y medical_records_history
-- ============================================================
-- RF-04: cada cita completada puede generar un registro médico.
-- Toda edición a medical_records se captura en medical_records_history
-- con la versión anterior, el doctor que la modificó y el timestamp.

-- TODO: Crear la tabla medical_records con las siguientes columnas:
--   - medical_record_id      UUID, PK, auto-generado
--   - appointment_id         UUID, obligatorio, único, FK → appointments ON DELETE RESTRICT
--   - doctor_id              UUID, obligatorio, FK → doctors ON DELETE RESTRICT
--   - patient_id             UUID, obligatorio, FK → patients ON DELETE RESTRICT
--   - record_diagnosis       TEXT, obligatorio
--   - record_notes           TEXT, nullable
--   - created_at             TIMESTAMPTZ, obligatorio, default NOW()
--   - updated_at             TIMESTAMPTZ, obligatorio, default NOW()

-- TODO: Crear la tabla medical_records_history con las siguientes columnas:
--   - history_id             UUID, PK, auto-generado
--   - medical_record_id      UUID, obligatorio, FK → medical_records ON DELETE CASCADE
--   - changed_by_doctor_id   UUID, obligatorio, FK → doctors ON DELETE RESTRICT
--   - old_diagnosis          TEXT, nullable (valor anterior)
--   - old_notes              TEXT, nullable (valor anterior)
--   - changed_at             TIMESTAMPTZ, obligatorio, default NOW()
-- Nombra todos los constraints con la convención del bootcamp.


-- ============================================================
-- PARTE 6: Tablas drugs y prescriptions
-- ============================================================
-- RF-05: después de cada cita, el médico puede prescribir medicamentos.
-- drugs: catálogo de medicamentos (normalizado para evitar redundancia).
-- prescriptions: una prescripción por cita con uno o más ítems.
-- prescription_items: cada fila = un medicamento de la prescripción.

-- TODO: Crear la tabla drugs con las siguientes columnas:
--   - drug_id            UUID, PK, auto-generado
--   - drug_name          VARCHAR(200), obligatorio, único
--   - drug_description   TEXT, nullable
--   - created_at         TIMESTAMPTZ, obligatorio, default NOW()

-- TODO: Crear la tabla prescriptions con las siguientes columnas:
--   - prescription_id    UUID, PK, auto-generado
--   - appointment_id     UUID, obligatorio, único, FK → appointments ON DELETE RESTRICT
--   - doctor_id          UUID, obligatorio, FK → doctors ON DELETE RESTRICT
--   - created_at         TIMESTAMPTZ, obligatorio, default NOW()

-- TODO: Crear la tabla prescription_items con las siguientes columnas:
--   - prescription_item_id   UUID, PK, auto-generado
--   - prescription_id        UUID, obligatorio, FK → prescriptions ON DELETE CASCADE
--   - drug_id                UUID, obligatorio, FK → drugs ON DELETE RESTRICT
--   - item_dosage            VARCHAR(100), obligatorio (ej: "500mg cada 8h")
--   - item_duration_days     SMALLINT, obligatorio, CHECK > 0
-- Nombra todos los constraints con la convención del bootcamp.


-- ============================================================
-- PARTE 7: Índices
-- ============================================================
-- RF-06: indexar todas las FKs y columnas de búsqueda frecuente.
-- Documenta cada índice con un comentario que explique el query que beneficia.

-- TODO: Crear índices para:
--   1. appointments.doctor_id        (query: citas del médico)
--   2. appointments.patient_id       (query: citas del paciente)
--   3. appointments.appointment_date (query: agenda del día)
--   4. appointments activas (parcial WHERE cancelled_at IS NULL)
--   5. medical_records.patient_id    (query: historial del paciente)
--   6. medical_records.appointment_id
--   7. medical_records_history.medical_record_id
--   8. prescriptions.appointment_id
--   9. prescription_items.prescription_id
--  10. prescription_items.drug_id
--  11. doctors.department_id
--  12. doctors.supervisor_id


-- ============================================================
-- PARTE 8: Vista vw_upcoming_appointments
-- ============================================================
-- RF-07: citas confirmadas o agendadas en los próximos 7 días
-- con nombre del médico y nombre del paciente.

-- TODO: Crear la vista vw_upcoming_appointments que incluya:
--   - appointment_id, appointment_date, appointment_status
--   - doctor_name, doctor_specialty
--   - patient_name
-- Filtro: appointment_date BETWEEN NOW() AND NOW() + INTERVAL '7 days'
--         AND appointment_status IN ('scheduled', 'confirmed')
--         AND cancelled_at IS NULL


-- ============================================================
-- PARTE 9: Función fn_get_patient_history(p_patient_id UUID)
-- ============================================================
-- RF-07: devuelve todo el historial médico de un paciente,
-- ordenado por fecha de la cita (más reciente primero).
-- Incluye: fecha de cita, nombre del médico, diagnóstico, notas.

-- TODO: Crear la función fn_get_patient_history con:
--   - LANGUAGE plpgsql, RETURNS TABLE(...)
--   - JOIN con appointments y doctors para obtener nombres
--   - ORDER BY appointment_date DESC
--   - Ejemplo de uso: SELECT * FROM fn_get_patient_history('uuid-del-paciente');


-- ============================================================
-- PARTE 10: Trigger de auditoría en medical_records
-- ============================================================
-- RF-07 + RF-04: cada UPDATE en medical_records debe insertar
-- en medical_records_history los valores ANTERIORES (OLD.*)
-- junto con el médico que los modificó.

-- TODO: Crear la función trg_fn_medical_records_audit() RETURNS TRIGGER
-- que inserte en medical_records_history:
--   - medical_record_id = OLD.medical_record_id
--   - changed_by_doctor_id = OLD.doctor_id
--   - old_diagnosis = OLD.record_diagnosis
--   - old_notes = OLD.record_notes
--   - changed_at = NOW()

-- TODO: Crear el trigger trg_medical_records_audit
--   AFTER UPDATE ON medical_records
--   FOR EACH ROW EXECUTE FUNCTION trg_fn_medical_records_audit();


-- ============================================================
-- PARTE 11: WITH RECURSIVE — árbol de departamentos
-- ============================================================
-- RF-01: consultar el árbol completo de departamentos mostrando
-- el nivel y el camino desde la raíz (path).

-- TODO: Escribir una CTE recursiva que:
--   - Caso base: departamentos sin parent_id (level = 1, path = department_name)
--   - Paso recursivo: agrega hijos con level + 1 y path = path || ' > ' || name
--   - Resultado ordenado por path
-- Ejemplo de output esperado:
--   level | path                                      | department_name
--   1     | Medicina General                          | Medicina General
--   2     | Medicina General > Cardiología            | Cardiología
--   3     | Medicina General > Cardiología > Congénita | Congénita


-- ============================================================
-- PARTE 12: Datos de prueba
-- ============================================================
-- Inserta datos suficientes para validar todas las constraints
-- y demostrar que los objetos avanzados funcionan correctamente.

-- TODO: Insertar al menos:
--   - 3 departamentos con jerarquía (padre → hijo → nieto)
--   - 3 médicos (uno supervisor de otro, uno sin supervisor)
--   - 3 pacientes
--   - 4 citas (2 completed, 1 confirmed, 1 cancelled)
--   - 2 registros médicos (uno editado para activar el trigger)
--   - 1 prescripción con 2 medicamentos


-- ============================================================
-- PARTE 13: Consultas de demostración
-- ============================================================
-- Escribe 5 queries que demuestren que el sistema funciona:

-- TODO: Query 1 — Usa la vista vw_upcoming_appointments

-- TODO: Query 2 — Usa la función fn_get_patient_history para un paciente

-- TODO: Query 3 — Usa la CTE recursiva para ver el árbol de departamentos

-- TODO: Query 4 — Muestra el historial de auditoría de un registro médico
--                 (medical_records JOIN medical_records_history)

-- TODO: Query 5 — Prescripciones de una cita con nombres de medicamentos
--                 (prescription_items JOIN drugs JOIN appointments)
