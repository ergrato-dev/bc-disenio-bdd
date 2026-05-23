# Práctica — Modelado ER Avanzado: Hospital Salud+

> **Duración estimada:** ~3 horas
> **Herramientas:** draw.io (app.diagrams.net) + dbdiagram.io + este documento
> **Entregable:** Diagrama ER con jerarquías IS-A + modelo DBML equivalente

**Hospital Salud+** es un hospital de especialidades que necesita un sistema para
gestionar su personal, pacientes, citas médicas y diagnósticos.
En esta práctica aplicarás los tres conceptos de la semana: especialización/generalización,
restricciones de cobertura y disyunción, y representación en DBML.

---

## Descripción del negocio

> El **Hospital Salud+** gestiona dos grandes grupos de personas: el **personal del hospital**
> y los **pacientes**.
>
> El personal está compuesto por **médicos**, **enfermeros** y **administrativos**. Todo
> miembro del personal tiene número de empleado, nombre completo, email, teléfono y fecha
> de contratación. Los **médicos** tienen además número de colegiado y especialidad
> (p. ej. Cardiología, Pediatría). Los **enfermeros** tienen turno (mañana, tarde, noche)
> y unidad de trabajo. Los **administrativos** tienen departamento y nivel salarial.
> **Todo miembro del personal pertenece a exactamente un tipo** — no existen empleados
> sin clasificar.
>
> Los **pacientes** tienen número de historia clínica, nombre, fecha de nacimiento,
> grupo sanguíneo y país de residencia. Un paciente puede no estar asignado a ningún
> médico responsable, o puede tener uno.
>
> El hospital registra **citas médicas**: cada cita tiene fecha, hora, motivo y estado
> (programada, atendida, cancelada). Una cita involucra exactamente un paciente y
> exactamente un médico. Un médico puede atender muchas citas; un paciente puede tener
> muchas citas.
>
> Después de una cita se pueden registrar **diagnósticos**: cada diagnóstico tiene código
> CIE-10, descripción, fecha y observaciones. Un diagnóstico pertenece a una sola cita
> y una cita puede tener cero o más diagnósticos.
>
> Cada diagnóstico puede derivar en una o más **prescripciones** de medicamentos.
> Una prescripción tiene el nombre del medicamento, dosis, duración y fecha de inicio.

---

## Paso 1 — Identificar entidades y la jerarquía IS-A

Lee el texto y completa el análisis:

| Sustantivo | ¿Entidad? | Justificación |
|---|---|---|
| Persona | ⚖️ Supertipo implícito | Personal y pacientes comparten nombre, email — pero son roles distintos |
| Personal del hospital | ✅ Sí — supertipo de staff | Tiene atributos propios (num_empleado, contratación) |
| Médico | ✅ Sí — **subtipo de personal** | IS-A personal; agrega num_colegiado y especialidad |
| Enfermero | ✅ Sí — **subtipo de personal** | IS-A personal; agrega turno y unidad |
| Administrativo | ✅ Sí — **subtipo de personal** | IS-A personal; agrega departamento y nivel_salarial |
| Paciente | ✅ Sí — entidad independiente | No es IS-A de personal; ciclo de vida diferente |
| Cita médica | ✅ Sí | Evento con fecha, hora, estado; relaciona médico y paciente |
| Diagnóstico | ✅ Sí | Entidad débil o fuerte según diseño — ver Paso 2 |
| Prescripción | ✅ Sí | Depende del diagnóstico; ver Paso 2 |
| Medicamento | ⚖️ Depende | Si el sistema gestiona un catálogo, es entidad; si solo se anota el nombre, es atributo |
| Especialidad | ⚖️ Depende | Si solo una cadena de texto, atributo; si gestiona departamentos, entidad |

---

## Paso 2 — Analizar la jerarquía IS-A de Personal

Responde las siguientes preguntas antes de dibujar:

### ¿Cobertura total o parcial?

> **Señal del texto:** *"Todo miembro del personal pertenece a exactamente un tipo"*

✅ **Cobertura total** — Todo empleado tiene subtipo. No puede existir un `STAFF` sin ser
`MÉDICO`, `ENFERMERO` o `ADMINISTRATIVO`.

En el DDL: columna discriminadora `staff_type VARCHAR NOT NULL`.

---

### ¿Disyunción exclusiva o inclusiva?

> **Señal del texto:** *"no existen empleados sin clasificar"* y el contexto implica
> que un empleado tiene un único rol.

✅ **Disyunción exclusiva** — Un miembro del personal es de **exactamente un tipo**.
No puede ser médico y enfermero al mismo tiempo.

En el DDL: `staff_type VARCHAR NOT NULL CHECK (staff_type IN ('doctor', 'nurse', 'admin'))`.

**Conclusión: Total + Exclusiva → Partición perfecta.**

---

## Paso 3 — Decidir la estrategia de implementación

Para la jerarquía `STAFF → {MÉDICO, ENFERMERO, ADMINISTRATIVO}` considera:

| Criterio | Situación en Salud+ |
|---|---|
| ¿Cuántos atributos exclusivos tiene cada subtipo? | Pocos (2-3 por subtipo) |
| ¿Se consultan todos juntos frecuentemente? | Sí (directorio general de empleados) |
| ¿Necesitas `NOT NULL` en columnas de subtipo? | Ideal, pero los subtipos tienen pocos atributos |
| ¿La jerarquía puede crecer con más subtipos? | Posiblemente sí |

**Decisión recomendada para la práctica:** usar **CTI** (Tabla por Subclase) para
practicar la estrategia más común en producción.

---

## Paso 4 — Dibujar el diagrama ER en draw.io

Abre [app.diagrams.net](https://app.diagrams.net) y construye el diagrama:

### Checklist del diagrama

- [ ] Entidad `STAFF` (supertipo) con sus atributos: `staff_id`, `staff_name`,
  `staff_email`, `staff_phone`, `staff_hire_date`
- [ ] IS-A con **doble línea** (total) y **"d"** en el círculo (exclusiva)
- [ ] Subtipo `DOCTOR` con: `doctor_medical_number`, `doctor_specialty`
- [ ] Subtipo `NURSE` con: `nurse_shift`, `nurse_unit`
- [ ] Subtipo `ADMIN_STAFF` con: `admin_department`, `admin_salary_level`
- [ ] Entidad `PATIENT` con: `patient_id`, `patient_record_number`, `patient_name`,
  `patient_dob`, `patient_blood_type`, `patient_country`
- [ ] Relación `TREATS`: `DOCTOR (0,N) ←→ (0,N) PATIENT` (médico responsable)
- [ ] Entidad `APPOINTMENT` con: `appointment_id`, `appointment_date`,
  `appointment_time`, `appointment_reason`, `appointment_status`
- [ ] Relación `HAS_APPOINTMENT`: `PATIENT (1,1) ←→ (0,N) APPOINTMENT`
- [ ] Relación `CONDUCTS`: `DOCTOR (1,1) ←→ (0,N) APPOINTMENT`
- [ ] Entidad `DIAGNOSIS` con: `diagnosis_id`, `diagnosis_cie10_code`,
  `diagnosis_description`, `diagnosis_date`
- [ ] Relación `RESULTS_IN`: `APPOINTMENT (1,1) ←→ (0,N) DIAGNOSIS`
- [ ] Entidad `PRESCRIPTION` con: `prescription_id`, `prescription_drug_name`,
  `prescription_dose`, `prescription_duration`, `prescription_start_date`
- [ ] Relación `GENERATES`: `DIAGNOSIS (1,1) ←→ (0,N) PRESCRIPTION`

---

## Paso 5 — Escribir el modelo DBML

Con el diagrama listo, escribe el DBML en [dbdiagram.io](https://dbdiagram.io).
A continuación tienes el modelo completo para verificar tu trabajo:

```dbml
// ============================================================
// Hospital Salud+
// Estrategia de herencia: CTI (Class Table Inheritance)
// Restricción IS-A: Total + Exclusiva
// ============================================================

// ── Supertipo de personal ──────────────────────────────────
Table staff {
  staff_id        uuid        [pk, default: `gen_random_uuid()`]
  staff_type      varchar(10) [not null, note: "doctor | nurse | admin — Total+Exclusiva"]
  staff_name      varchar(100) [not null]
  staff_email     varchar(150) [not null, unique]
  staff_phone     varchar(20)
  staff_hire_date date        [not null]
  created_at      timestamptz [not null, default: `now()`]

  indexes {
    staff_email [unique, name: 'uq_staff_email']
    staff_type  [name: 'ix_staff_type']
  }
}

// ── Subtipo: MÉDICO ────────────────────────────────────────
Table doctors {
  staff_id              uuid        [pk, ref: - staff.staff_id, note: "FK = PK (CTI)"]
  doctor_medical_number varchar(20) [not null, unique]
  doctor_specialty      varchar(80) [not null]
}

// ── Subtipo: ENFERMERO ────────────────────────────────────
Table nurses {
  staff_id    uuid       [pk, ref: - staff.staff_id]
  nurse_shift varchar(10) [not null, note: "morning | afternoon | night"]
  nurse_unit  varchar(80) [not null]
}

// ── Subtipo: ADMINISTRATIVO ───────────────────────────────
Table admin_staff {
  staff_id            uuid     [pk, ref: - staff.staff_id]
  admin_department    varchar(80) [not null]
  admin_salary_level  smallint    [not null, default: 1]
}

// ── Pacientes ─────────────────────────────────────────────
Table patients {
  patient_id            uuid        [pk, default: `gen_random_uuid()`]
  patient_record_number varchar(20) [not null, unique]
  patient_name          varchar(100) [not null]
  patient_dob           date
  patient_blood_type    varchar(5)
  patient_country       varchar(60) [not null]
  created_at            timestamptz [not null, default: `now()`]
}

// ── Citas médicas ─────────────────────────────────────────
Table appointments {
  appointment_id     uuid        [pk, default: `gen_random_uuid()`]
  patient_id         uuid        [not null, ref: > patients.patient_id]
  doctor_staff_id    uuid        [not null, ref: > doctors.staff_id]
  appointment_date   date        [not null]
  appointment_time   time        [not null]
  appointment_reason text
  appointment_status varchar(15) [not null, default: 'scheduled',
                                  note: "scheduled | attended | cancelled"]

  indexes {
    patient_id      [name: 'ix_appointments_patient_id']
    doctor_staff_id [name: 'ix_appointments_doctor_id']
    appointment_date [name: 'ix_appointments_date']
  }
}

// ── Diagnósticos ──────────────────────────────────────────
Table diagnoses {
  diagnosis_id          uuid [pk, default: `gen_random_uuid()`]
  appointment_id        uuid [not null, ref: > appointments.appointment_id]
  diagnosis_cie10_code  varchar(10) [not null]
  diagnosis_description text        [not null]
  diagnosis_date        date        [not null]
  diagnosis_notes       text
}

// ── Prescripciones ────────────────────────────────────────
Table prescriptions {
  prescription_id         uuid [pk, default: `gen_random_uuid()`]
  diagnosis_id            uuid [not null, ref: > diagnoses.diagnosis_id]
  prescription_drug_name  varchar(150) [not null]
  prescription_dose       varchar(80)  [not null]
  prescription_duration   varchar(80)
  prescription_start_date date         [not null]
}
```

---

## Paso 6 — Verificación: exportar a PostgreSQL

Desde dbdiagram.io, exporta a SQL y verifica que:

- [ ] El DDL exportado ejecuta sin errores en PostgreSQL 16+
- [ ] Los constraints de herencia CTI son `PRIMARY KEY` + `FOREIGN KEY` en una columna
- [ ] La tabla `staff` tiene el `CHECK` sobre `staff_type` (añadirlo manualmente
  si dbdiagram.io no lo genera)

El `CHECK` que debes agregar manualmente al DDL exportado:

```sql
ALTER TABLE staff
    ADD CONSTRAINT ck_staff_type
        CHECK (staff_type IN ('doctor', 'nurse', 'admin'));
```

---

## Preguntas de reflexión

Responde en tu cuaderno o en los comentarios del DBML:

1. ¿Por qué se eligió CTI y no STI para esta jerarquía?
2. ¿Qué pasaría si un médico pudiera ser también enfermero (turno nocturno)?
   ¿Cambiaría la restricción de disyunción?
3. ¿Debería `DIAGNOSIS` ser una entidad débil de `APPOINTMENT`?
   ¿Cuál sería la clave discriminante?
4. Si el hospital quisiera gestionar un catálogo de medicamentos (nombre, principio activo,
   presentación), ¿qué cambios haría en el modelo?

---

← [README](../README.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Proyecto Semana 05 →](../3-proyecto/README.md)
