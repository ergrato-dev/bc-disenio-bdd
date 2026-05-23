# Práctica — Del ER al Modelo Relacional: Hospital Salud+

> **Duración estimada:** ~3 horas
> **Herramientas:** dbdiagram.io + pgAdmin 4 / DBeaver
> **Prerequisito:** haber completado la Práctica de la Semana 05 (Hospital Salud+)

En la Semana 05 diseñaste el diagrama ER del **Hospital Salud+** con jerarquías IS-A.
En esta práctica aplicarás las **7 reglas de transformación** para convertir ese diagrama
en un modelo relacional completo con DBML y DDL PostgreSQL.

---

## El diagrama ER de partida (Semana 05)

Trabajarás con el siguiente modelo conceptual:

```
STAFF (supertipo) — jerarquía IS-A: Total + Exclusiva
  ├── DOCTOR     (staff_id, doctor_medical_number, doctor_specialty)
  ├── NURSE      (staff_id, nurse_shift, nurse_unit)
  └── ADMIN_STAFF (staff_id, admin_department, admin_salary_level)

PATIENT        (patient_id, patient_record_number, patient_name, patient_dob,
                patient_blood_type, patient_country)

APPOINTMENT    (appointment_id, appointment_date, appointment_time,
                appointment_reason, appointment_status)
  Relaciones:
  - PATIENT    (1,1) ← HAS_APPOINTMENT → (0,N) APPOINTMENT
  - DOCTOR     (1,1) ← CONDUCTS       → (0,N) APPOINTMENT

DIAGNOSIS      (diagnosis_id, diagnosis_cie10_code, diagnosis_description,
                diagnosis_date, diagnosis_notes)
  Relaciones:
  - APPOINTMENT (1,1) ← RESULTS_IN → (0,N) DIAGNOSIS

PRESCRIPTION   (prescription_id, prescription_drug_name, prescription_dose,
                prescription_duration, prescription_start_date)
  Relaciones:
  - DIAGNOSIS   (1,1) ← GENERATES  → (0,N) PRESCRIPTION
```

---

## Paso 1 — Aplicar R1: Entidades Fuertes

Identifica todas las entidades fuertes y aplica la Regla 1.

**Entidades fuertes del modelo:**

| Entidad | ¿Es fuerte? | Tabla resultante |
|---|---|---|
| STAFF | ✅ Sí (supertipo) | `staff` |
| PATIENT | ✅ Sí | `patients` |
| APPOINTMENT | ✅ Sí | `appointments` |
| DIAGNOSIS | ✅ Sí | `diagnoses` |
| PRESCRIPTION | ✅ Sí | `prescriptions` |
| DOCTOR | Subtipo (R7) | `doctors` |
| NURSE | Subtipo (R7) | `nurses` |
| ADMIN_STAFF | Subtipo (R7) | `admin_staff` |

Ejecuta las primeras tablas en psql o DBeaver:

```sql
-- ============================================
-- PASO 1: Entidades fuertes (R1)
-- ============================================

-- Supertipo del personal
CREATE TABLE staff (
    staff_id        UUID         DEFAULT gen_random_uuid() PRIMARY KEY,
    staff_type      VARCHAR(10)  NOT NULL
        CONSTRAINT ck_staff_type CHECK (staff_type IN ('doctor', 'nurse', 'admin')),
    staff_name      VARCHAR(100) NOT NULL,
    staff_email     VARCHAR(150) NOT NULL,
    staff_phone     VARCHAR(20),          -- atributo opcional → NULL
    staff_hire_date DATE         NOT NULL,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_staff_email UNIQUE (staff_email)
);

-- Pacientes: entidad independiente (no IS-A del personal)
CREATE TABLE patients (
    patient_id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    patient_record_number VARCHAR(20) NOT NULL,
    patient_name          VARCHAR(100) NOT NULL,
    patient_dob           DATE,                  -- opcional en el ER
    patient_blood_type    VARCHAR(5),            -- opcional
    patient_country       VARCHAR(60) NOT NULL,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_patients_record_number UNIQUE (patient_record_number)
);
```

---

## Paso 2 — Aplicar R7: Jerarquía IS-A con CTI

La jerarquía STAFF → {DOCTOR, NURSE, ADMIN} usa **CTI** (decisión de la Semana 05).
La restricción era **Total + Exclusiva**.

```sql
-- ============================================
-- PASO 2: Jerarquía IS-A (R7 — CTI)
-- La PK de cada subtipo = FK al supertipo
-- ============================================

-- Subtipo DOCTOR
CREATE TABLE doctors (
    staff_id              UUID        PRIMARY KEY
        REFERENCES staff(staff_id) ON DELETE CASCADE,
    doctor_medical_number VARCHAR(20) NOT NULL,
    doctor_specialty      VARCHAR(80) NOT NULL,

    CONSTRAINT uq_doctors_medical_number UNIQUE (doctor_medical_number)
);

-- Subtipo NURSE
CREATE TABLE nurses (
    staff_id    UUID        PRIMARY KEY
        REFERENCES staff(staff_id) ON DELETE CASCADE,
    nurse_shift VARCHAR(10) NOT NULL
        CONSTRAINT ck_nurses_shift CHECK (nurse_shift IN ('morning', 'afternoon', 'night')),
    nurse_unit  VARCHAR(80) NOT NULL
);

-- Subtipo ADMIN_STAFF
CREATE TABLE admin_staff (
    staff_id            UUID     PRIMARY KEY
        REFERENCES staff(staff_id) ON DELETE CASCADE,
    admin_department    VARCHAR(80) NOT NULL,
    admin_salary_level  SMALLINT    NOT NULL DEFAULT 1
        CONSTRAINT ck_admin_salary_level CHECK (admin_salary_level BETWEEN 1 AND 5)
);
```

> **Observa:** ¿Por qué `ON DELETE CASCADE` en los subtipos?
> Si se elimina un registro de `staff`, los registros vinculados en `doctors`,
> `nurses` y `admin_staff` deben eliminarse también — son el mismo empleado.

---

## Paso 3 — Aplicar R4: Relaciones 1:N

Las relaciones con `APPOINTMENT` son 1:N:
- `PATIENT (1) → (N) APPOINTMENT`: un paciente tiene muchas citas
- `DOCTOR  (1) → (N) APPOINTMENT`: un médico atiende muchas citas

Las FK van en la tabla `appointments` (lado N).

```sql
-- ============================================
-- PASO 3: Relaciones 1:N (R4)
-- FK en el lado N (appointments)
-- ============================================

CREATE TABLE appointments (
    appointment_id     UUID        DEFAULT gen_random_uuid() PRIMARY KEY,

    -- R4: FK hacia patients (1:N — side N = appointments)
    patient_id         UUID        NOT NULL    -- participación total: toda cita tiene paciente
        REFERENCES patients(patient_id)
        ON DELETE RESTRICT,

    -- R4: FK hacia doctors (1:N — side N = appointments)
    -- Nótese: la FK apunta a doctors, no a staff
    doctor_staff_id    UUID        NOT NULL    -- participación total: toda cita tiene médico
        REFERENCES doctors(staff_id)
        ON DELETE RESTRICT,

    appointment_date   DATE        NOT NULL,
    appointment_time   TIME        NOT NULL,
    appointment_reason TEXT,                  -- opcional
    appointment_status VARCHAR(15) NOT NULL DEFAULT 'scheduled'
        CONSTRAINT ck_appointment_status
            CHECK (appointment_status IN ('scheduled', 'attended', 'cancelled')),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

Verifica las cardinalidades:

```sql
-- ¿Puede un paciente tener 0 citas? Sí → patient_id en patients no tiene restricción
-- ¿Puede existir una cita sin paciente? No → NOT NULL en patient_id en appointments
-- ¿Puede un médico tener 0 citas? Sí → doctor_staff_id en doctors no tiene restricción
-- ¿Puede existir una cita sin médico? No → NOT NULL en doctor_staff_id en appointments
```

---

## Paso 4 — Aplicar R4 nuevamente: Diagnósticos y Prescripciones

Las relaciones APPOINTMENT → DIAGNOSIS → PRESCRIPTION son también 1:N.

```sql
-- ============================================
-- PASO 4: Relaciones 1:N encadenadas (R4)
-- ============================================

-- APPOINTMENT (1) → (N) DIAGNOSIS
CREATE TABLE diagnoses (
    diagnosis_id          UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    appointment_id        UUID        NOT NULL
        REFERENCES appointments(appointment_id)
        ON DELETE RESTRICT,  -- no borrar cita si tiene diagnóstico
    diagnosis_cie10_code  VARCHAR(10) NOT NULL,
    diagnosis_description TEXT        NOT NULL,
    diagnosis_date        DATE        NOT NULL,
    diagnosis_notes       TEXT
);

-- DIAGNOSIS (1) → (N) PRESCRIPTION
CREATE TABLE prescriptions (
    prescription_id         UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    diagnosis_id            UUID        NOT NULL
        REFERENCES diagnoses(diagnosis_id)
        ON DELETE CASCADE,  -- si se borra el diagnóstico, se borran sus prescripciones
    prescription_drug_name  VARCHAR(150) NOT NULL,
    prescription_dose       VARCHAR(80)  NOT NULL,
    prescription_duration   VARCHAR(80),          -- opcional: "7 días", "1 mes"
    prescription_start_date DATE         NOT NULL
);
```

---

## Paso 5 — Agregar índices

Los índices no son parte de las reglas de transformación ER, pero son esenciales
para el modelo físico. Agrega índices en las FK más consultadas:

```sql
-- ============================================
-- PASO 5: Índices en FK (buena práctica)
-- ============================================

-- Índices en appointments (tabla más consultada)
CREATE INDEX ix_appointments_patient_id      ON appointments(patient_id);
CREATE INDEX ix_appointments_doctor_staff_id ON appointments(doctor_staff_id);
CREATE INDEX ix_appointments_date            ON appointments(appointment_date);

-- Índices en diagnoses
CREATE INDEX ix_diagnoses_appointment_id     ON diagnoses(appointment_id);

-- Índices en prescriptions
CREATE INDEX ix_prescriptions_diagnosis_id   ON prescriptions(diagnosis_id);

-- Índices en staff (búsquedas frecuentes por tipo y email)
CREATE INDEX ix_staff_type                   ON staff(staff_type);
```

---

## Paso 6 — Verificación: consultas de prueba

Ejecuta las siguientes consultas para verificar que el modelo funciona:

```sql
-- 6.1: Insertar datos de prueba
INSERT INTO staff (staff_type, staff_name, staff_email, staff_hire_date)
VALUES ('doctor', 'Dra. Ana Pérez', 'a.perez@hospital.com', '2020-03-15');

-- Recuperar el UUID insertado
-- (en psql puedes usar: INSERT ... RETURNING staff_id)

-- 6.2: Insertar en el subtipo correspondiente
-- (reemplaza el UUID con el obtenido en el paso anterior)
INSERT INTO doctors (staff_id, doctor_medical_number, doctor_specialty)
VALUES ('<UUID-de-ana>', 'COL-00234', 'Cardiología');

-- 6.3: Consulta de un médico completo (JOIN supertipo + subtipo CTI)
SELECT
    s.staff_name,
    s.staff_email,
    d.doctor_specialty,
    d.doctor_medical_number
FROM staff   AS s
JOIN doctors AS d ON d.staff_id = s.staff_id
WHERE s.staff_type = 'doctor';

-- 6.4: Intentar violar la restricción IS-A (debe fallar)
-- Un médico con staff_type 'nurse' debe fallar por el CHECK
INSERT INTO staff (staff_type, staff_name, staff_email, staff_hire_date)
VALUES ('pediatra', 'Dr. X', 'x@hospital.com', '2024-01-01');
-- ERROR: new row for relation "staff" violates check constraint "ck_staff_type"
```

---

## Paso 7 — Tabla de decisiones de transformación

Completa la siguiente tabla con las decisiones tomadas en esta práctica:

| Elemento ER | Regla | Decisión | Justificación |
|---|---|---|---|
| STAFF | R1 | Tabla `staff` | Entidad fuerte con atributos comunes |
| DOCTOR/NURSE/ADMIN | R7 — CTI | Tablas `doctors`, `nurses`, `admin_staff` | Múltiples atributos exclusivos por subtipo; integridad garantizada |
| PATIENT | R1 | Tabla `patients` | Entidad fuerte independiente |
| APPOINTMENT | R1 + R4 | Tabla `appointments` con FK `patient_id` y `doctor_staff_id` | Relaciones 1:N en ambos lados |
| DIAGNOSIS | R1 + R4 | Tabla `diagnoses` con FK `appointment_id` | 1:N; `ON DELETE RESTRICT` porque no queremos perder diagnósticos |
| PRESCRIPTION | R1 + R4 | Tabla `prescriptions` con FK `diagnosis_id` | 1:N; `ON DELETE CASCADE` porque prescripción depende del diagnóstico |

---

## Preguntas de reflexión

1. ¿Por qué la FK en `appointments.doctor_staff_id` apunta a `doctors.staff_id`
   y no a `staff.staff_id`?
2. Si un médico fuera eliminado del sistema, ¿qué pasaría con sus citas según
   el `ON DELETE RESTRICT`? ¿Sería ese el comportamiento correcto?
3. ¿Qué tabla agregarías si el hospital quisiera gestionar un catálogo de medicamentos
   aprobados? ¿Cambiaría la tabla `prescriptions`?
4. ¿Debería `DIAGNOSIS` tener su propia tabla de `attachments` (imágenes, PDFs)?
   ¿Cómo aplicarías R5 o R6 para eso?

---

← [README](../README.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Proyecto Semana 06 →](../3-proyecto/README.md)
