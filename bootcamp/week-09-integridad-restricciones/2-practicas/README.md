# Práctica — ClinicDB: Añadir Constraints al Esquema del Hospital

## Contexto

En la semana 06 transformamos el modelo ER del hospital a tablas relacionales.
Esas tablas tenían columnas y tipos de datos, pero **ninguna restricción de
integridad**. En esta práctica añadiremos constraints completos paso a paso,
verificando que la base de datos rechaza datos incorrectos.

> Esta práctica es **guiada** — el código ya está escrito. Ejecuta cada
> bloque sección por sección y observa los resultados.

---

## Duración estimada: 3 horas

| Paso | Actividad                                | Tiempo |
|------|------------------------------------------|--------|
| 1    | Setup: esquema y tablas sin constraints  | 20 min |
| 2    | PRIMARY KEY constraints                  | 15 min |
| 3    | UNIQUE constraints                       | 15 min |
| 4    | NOT NULL en todas las columnas requeridas| 20 min |
| 5    | FOREIGN KEY con políticas ON DELETE      | 25 min |
| 6    | CHECK constraints de dominio             | 20 min |
| 7    | Datos de prueba: válidos e inválidos     | 25 min |
| 8    | Inspección con pg_constraint             | 20 min |

---

## Paso 1 — Setup: Esquema y Tablas Base (sin constraints)

Primero creamos las tablas **sin ninguna restricción** — solo columnas y tipos.
Esto es el "esquema en bruto" que recibirías de un desarrollador que no conoce
bien el diseño de bases de datos.

```sql
-- ============================================
-- PASO 1: Crear el esquema y tablas base
-- Sin constraints — solo columnas y tipos
-- ============================================

-- DROP SCHEMA IF EXISTS clinicdb CASCADE;
-- CREATE SCHEMA clinicdb;
-- SET search_path = clinicdb;

-- Descomenta y ejecuta este bloque:

-- CREATE SCHEMA IF NOT EXISTS clinicdb;
-- SET search_path = clinicdb;

-- CREATE TABLE specialties (
--     specialty_id   UUID,
--     specialty_name VARCHAR(80)
-- );

-- CREATE TABLE doctors (
--     doctor_id       UUID,
--     specialty_id    UUID,
--     doctor_name     VARCHAR(100),
--     doctor_license  VARCHAR(20),
--     hired_at        DATE
-- );

-- CREATE TABLE patients (
--     patient_id    UUID,
--     patient_name  VARCHAR(100),
--     patient_dob   DATE,
--     patient_email VARCHAR(150),
--     patient_phone VARCHAR(20)
-- );

-- CREATE TABLE appointments (
--     appointment_id     UUID,
--     doctor_id          UUID,
--     patient_id         UUID,
--     appointment_at     TIMESTAMPTZ,
--     appointment_status VARCHAR(20),
--     appointment_notes  TEXT
-- );
```

**Verificar:** `\dt clinicdb.*` debe mostrar las 4 tablas.

---

## Paso 2 — PRIMARY KEY Constraints

Añadimos las PKs con nombres explícitos. Observa cómo PostgreSQL rechaza
insertar dos filas con el mismo `specialty_id`.

```sql
-- ============================================
-- PASO 2: Agregar PRIMARY KEY constraints
-- ============================================

-- ALTER TABLE clinicdb.specialties
--     ADD CONSTRAINT pk_specialties PRIMARY KEY (specialty_id);

-- ALTER TABLE clinicdb.doctors
--     ADD CONSTRAINT pk_doctors PRIMARY KEY (doctor_id);

-- ALTER TABLE clinicdb.patients
--     ADD CONSTRAINT pk_patients PRIMARY KEY (patient_id);

-- ALTER TABLE clinicdb.appointments
--     ADD CONSTRAINT pk_appointments PRIMARY KEY (appointment_id);
```

**Prueba:** Intenta insertar dos filas con el mismo UUID en `specialties`.
¿Qué error muestra PostgreSQL?

```sql
-- Intenta esto y observa el error:

-- INSERT INTO clinicdb.specialties (specialty_id, specialty_name)
-- VALUES ('11111111-1111-1111-1111-111111111111', 'Cardiología');

-- INSERT INTO clinicdb.specialties (specialty_id, specialty_name)
-- VALUES ('11111111-1111-1111-1111-111111111111', 'Neurología');
-- → ERROR: duplicate key value violates unique constraint "pk_specialties"
```

---

## Paso 3 — UNIQUE Constraints

El número de licencia de un médico debe ser único en todo el sistema.
El email de un paciente también.

```sql
-- ============================================
-- PASO 3: Agregar UNIQUE constraints
-- ============================================

-- ALTER TABLE clinicdb.doctors
--     ADD CONSTRAINT uq_doctors_license UNIQUE (doctor_license);

-- ALTER TABLE clinicdb.patients
--     ADD CONSTRAINT uq_patients_email UNIQUE (patient_email);
```

**Observa:** ejecuta `\d clinicdb.doctors` en psql. ¿Cuántos índices ves ahora?
Deberías ver el índice implícito de la PK más el de la UNIQUE.

---

## Paso 4 — NOT NULL en Columnas Requeridas

Ahora declaramos qué campos son obligatorios. Primero verifica que no hay
NULLs actuales (las tablas están vacías, así que está bien).

```sql
-- ============================================
-- PASO 4: Agregar NOT NULL a columnas requeridas
-- ============================================

-- specialties: nombre siempre obligatorio
-- ALTER TABLE clinicdb.specialties
--     ALTER COLUMN specialty_id   SET NOT NULL,
--     ALTER COLUMN specialty_name SET NOT NULL;

-- doctors: todos los campos son obligatorios (la especialidad también)
-- ALTER TABLE clinicdb.doctors
--     ALTER COLUMN doctor_id      SET NOT NULL,
--     ALTER COLUMN specialty_id   SET NOT NULL,
--     ALTER COLUMN doctor_name    SET NOT NULL,
--     ALTER COLUMN doctor_license SET NOT NULL,
--     ALTER COLUMN hired_at       SET NOT NULL;

-- patients: nombre y fecha de nacimiento obligatorios; email y phone opcionales
-- ALTER TABLE clinicdb.patients
--     ALTER COLUMN patient_id   SET NOT NULL,
--     ALTER COLUMN patient_name SET NOT NULL,
--     ALTER COLUMN patient_dob  SET NOT NULL;
-- Nota: patient_email y patient_phone quedan nullable (SET NULL si el médico
-- captura a un paciente sin esos datos todavía)

-- appointments: todos los campos excepto notes son obligatorios
-- ALTER TABLE clinicdb.appointments
--     ALTER COLUMN appointment_id     SET NOT NULL,
--     ALTER COLUMN doctor_id          SET NOT NULL,
--     ALTER COLUMN patient_id         SET NOT NULL,
--     ALTER COLUMN appointment_at     SET NOT NULL,
--     ALTER COLUMN appointment_status SET NOT NULL;
-- appointment_notes queda nullable (no siempre hay anotaciones)
```

---

## Paso 5 — FOREIGN KEY con Políticas ON DELETE

Ahora vinculamos las tablas. Piensa en qué política ON DELETE corresponde
a cada relación antes de ejecutar:

| Relación                           | ¿Qué debe pasar si se borra el padre? |
|------------------------------------|---------------------------------------|
| doctor → specialty                 | Bloquear (una especialidad activa no se borra si tiene doctores) |
| appointment → doctor               | Bloquear (no borrar doctor con citas programadas) |
| appointment → patient              | Bloquear (no borrar paciente con citas) |

```sql
-- ============================================
-- PASO 5: Agregar FOREIGN KEY constraints
-- ============================================

-- doctors referencia specialties
-- ALTER TABLE clinicdb.doctors
--     ADD CONSTRAINT fk_doctors_specialty_id
--         FOREIGN KEY (specialty_id)
--         REFERENCES clinicdb.specialties(specialty_id)
--         ON DELETE RESTRICT
--         ON UPDATE RESTRICT;

-- appointments referencia doctors
-- ALTER TABLE clinicdb.appointments
--     ADD CONSTRAINT fk_appointments_doctor_id
--         FOREIGN KEY (doctor_id)
--         REFERENCES clinicdb.doctors(doctor_id)
--         ON DELETE RESTRICT
--         ON UPDATE RESTRICT;

-- appointments referencia patients
-- ALTER TABLE clinicdb.appointments
--     ADD CONSTRAINT fk_appointments_patient_id
--         FOREIGN KEY (patient_id)
--         REFERENCES clinicdb.patients(patient_id)
--         ON DELETE RESTRICT
--         ON UPDATE RESTRICT;
```

**Crear índices en columnas FK** (PostgreSQL no los crea automáticamente):

```sql
-- CREATE INDEX ix_doctors_specialty_id
--     ON clinicdb.doctors (specialty_id);

-- CREATE INDEX ix_appointments_doctor_id
--     ON clinicdb.appointments (doctor_id);

-- CREATE INDEX ix_appointments_patient_id
--     ON clinicdb.appointments (patient_id);
```

---

## Paso 6 — CHECK Constraints de Dominio

Validamos los valores permitidos en columnas críticas:

```sql
-- ============================================
-- PASO 6: Agregar CHECK constraints
-- ============================================

-- El estado de una cita solo puede ser uno de estos valores:
-- ALTER TABLE clinicdb.appointments
--     ADD CONSTRAINT ck_appointments_status
--         CHECK (appointment_status IN (
--             'scheduled', 'confirmed', 'completed', 'cancelled', 'no_show'
--         ));

-- La fecha de nacimiento del paciente debe ser en el pasado:
-- ALTER TABLE clinicdb.patients
--     ADD CONSTRAINT ck_patients_dob
--         CHECK (patient_dob < CURRENT_DATE);

-- El nombre de la especialidad debe tener al menos 3 caracteres:
-- ALTER TABLE clinicdb.specialties
--     ADD CONSTRAINT ck_specialties_name_length
--         CHECK (LENGTH(specialty_name) >= 3);

-- La fecha de la cita debe ser razonable (no en el pasado lejano):
-- ALTER TABLE clinicdb.appointments
--     ADD CONSTRAINT ck_appointments_at_future
--         CHECK (appointment_at >= '2020-01-01'::TIMESTAMPTZ);
```

---

## Paso 7 — Datos de Prueba: Válidos e Inválidos

Inserta datos válidos primero, luego prueba que cada constraint funciona:

```sql
-- ============================================
-- PASO 7A: Insertar datos válidos
-- ============================================

-- INSERT INTO clinicdb.specialties (specialty_id, specialty_name) VALUES
--     ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Cardiología'),
--     ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Neurología'),
--     ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Pediatría');

-- INSERT INTO clinicdb.doctors (doctor_id, specialty_id, doctor_name, doctor_license, hired_at) VALUES
--     ('dddddddd-dddd-dddd-dddd-dddddddddddd',
--      'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
--      'Dra. Ana García', 'MED-001', '2018-03-15');

-- INSERT INTO clinicdb.patients (patient_id, patient_name, patient_dob, patient_email) VALUES
--     ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
--      'Carlos López', '1985-07-22', 'carlos@email.com');

-- INSERT INTO clinicdb.appointments
--     (appointment_id, doctor_id, patient_id, appointment_at, appointment_status)
-- VALUES
--     ('ffffffff-ffff-ffff-ffff-ffffffffffff',
--      'dddddddd-dddd-dddd-dddd-dddddddddddd',
--      'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
--      NOW() + INTERVAL '1 day',
--      'scheduled');
```

```sql
-- ============================================
-- PASO 7B: Pruebas de violación de constraints
-- Cada INSERT debe fallar con el error indicado
-- ============================================

-- 1. Violar PK: duplicar specialty_id
-- INSERT INTO clinicdb.specialties (specialty_id, specialty_name)
-- VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Duplicado');
-- → ERROR: duplicate key value violates unique constraint "pk_specialties"

-- 2. Violar FK: doctor con especialidad inexistente
-- INSERT INTO clinicdb.doctors (doctor_id, specialty_id, doctor_name, doctor_license, hired_at)
-- VALUES (gen_random_uuid(), '99999999-9999-9999-9999-999999999999',
--         'Dr. Fantasma', 'MED-999', NOW());
-- → ERROR: insert or update on table "doctors" violates foreign key constraint "fk_doctors_specialty_id"

-- 3. Violar UNIQUE: mismo número de licencia
-- INSERT INTO clinicdb.doctors (doctor_id, specialty_id, doctor_name, doctor_license, hired_at)
-- VALUES (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
--         'Otro Doctor', 'MED-001', NOW());
-- → ERROR: duplicate key value violates unique constraint "uq_doctors_license"

-- 4. Violar CHECK: estado inválido en appointment
-- INSERT INTO clinicdb.appointments
--     (appointment_id, doctor_id, patient_id, appointment_at, appointment_status)
-- VALUES (gen_random_uuid(),
--         'dddddddd-dddd-dddd-dddd-dddddddddddd',
--         'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
--         NOW(), 'pendiente');
-- → ERROR: new row for relation "appointments" violates check constraint "ck_appointments_status"

-- 5. Violar NOT NULL: appointment_status nulo
-- INSERT INTO clinicdb.appointments
--     (appointment_id, doctor_id, patient_id, appointment_at, appointment_status)
-- VALUES (gen_random_uuid(),
--         'dddddddd-dddd-dddd-dddd-dddddddddddd',
--         'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
--         NOW(), NULL);
-- → ERROR: null value in column "appointment_status" of relation "appointments"
--          violates not-null constraint

-- 6. Violar RESTRICT: intentar borrar doctor con citas
-- DELETE FROM clinicdb.doctors
-- WHERE doctor_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd';
-- → ERROR: update or delete on table "doctors" violates foreign key constraint
--          "fk_appointments_doctor_id" on table "appointments"
```

---

## Paso 8 — Inspección con pg_constraint

PostgreSQL almacena todos los constraints en el catálogo del sistema.
Puedes consultarlo para verificar que todo está correcto:

```sql
-- ============================================
-- PASO 8: Inspeccionar constraints registrados
-- ============================================

-- Ver todos los constraints de appointments:
-- SELECT
--     conname                           AS constraint_name,
--     CASE contype
--         WHEN 'p' THEN 'PRIMARY KEY'
--         WHEN 'u' THEN 'UNIQUE'
--         WHEN 'f' THEN 'FOREIGN KEY'
--         WHEN 'c' THEN 'CHECK'
--         WHEN 'n' THEN 'NOT NULL'
--     END                               AS constraint_type,
--     pg_get_constraintdef(oid)         AS definition
-- FROM pg_constraint
-- WHERE conrelid = 'clinicdb.appointments'::regclass
-- ORDER BY contype, conname;

-- Ver índices del esquema clinicdb:
-- SELECT tablename, indexname, indexdef
-- FROM pg_indexes
-- WHERE schemaname = 'clinicdb'
-- ORDER BY tablename, indexname;
```

**Reflexiona:** La consulta anterior muestra los constraints declarados.
¿Cuántos constraints tiene la tabla `appointments` después de todos los pasos?
¿Puedes identificar cuáles son PK, FK, CHECK y NOT NULL en el resultado?

---

## Resumen de lo Practicado

| Constraint    | Tabla         | Nombre                           | Propósito                         |
|---------------|---------------|----------------------------------|-----------------------------------|
| PRIMARY KEY   | specialties   | `pk_specialties`                 | Identidad de especialidad         |
| PRIMARY KEY   | doctors       | `pk_doctors`                     | Identidad de médico               |
| PRIMARY KEY   | patients      | `pk_patients`                    | Identidad de paciente             |
| PRIMARY KEY   | appointments  | `pk_appointments`                | Identidad de cita                 |
| UNIQUE        | doctors       | `uq_doctors_license`             | Licencia médica única             |
| UNIQUE        | patients      | `uq_patients_email`              | Email de paciente único           |
| FOREIGN KEY   | doctors       | `fk_doctors_specialty_id`        | Especialidad existe → RESTRICT    |
| FOREIGN KEY   | appointments  | `fk_appointments_doctor_id`      | Doctor existe → RESTRICT          |
| FOREIGN KEY   | appointments  | `fk_appointments_patient_id`     | Paciente existe → RESTRICT        |
| CHECK         | appointments  | `ck_appointments_status`         | Estado en conjunto válido         |
| CHECK         | patients      | `ck_patients_dob`                | Fecha de nacimiento en el pasado  |
| CHECK         | specialties   | `ck_specialties_name_length`     | Nombre al menos 3 caracteres      |

---

← [README](../README.md) | → [Proyecto Semana 09](../3-proyecto/README.md)
