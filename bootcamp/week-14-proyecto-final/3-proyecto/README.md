# Proyecto Final — MediSync: Sistema de Gestión Hospitalaria

> **Fase:** Diseño Avanzado + Proyecto Final &nbsp;|&nbsp; **Semana:** 14 de 14

## Contexto del Sistema

MediSync es la plataforma de gestión clínica de una red hospitalaria regional.
Integra el registro de pacientes, la gestión de médicos y departamentos, la
agenda de citas, los historiales médicos y las prescripciones farmacológicas.

El sistema debe estar preparado para crecer de 1 clínica a 10, por lo que el
diseño incluye soporte para multi-tenancy mediante RLS. Volumen estimado:
500 médicos, 20.000 pacientes, 150.000 citas por año.

Este proyecto es el **capstone del bootcamp**: integra todos los conceptos
estudiados en las semanas 1 a 13 en un único sistema de producción real.

---

## Requerimientos Funcionales

**RF-01 — Departamentos con jerarquía**
Los departamentos tienen una estructura arbórea: Medicina General puede contener
Cardiología, que a su vez contiene Cardiopatía Congénita. La jerarquía es indefinida.
Se debe poder consultar el árbol completo con una sola query (`WITH RECURSIVE`).

**RF-02 — Médicos con relación supervisora**
Cada médico pertenece a un departamento. Un médico puede supervisar a otros médicos
(relación reflexiva). Si un médico supervisor es dado de baja (soft delete),
sus supervisados no se borran: pasan a supervisor nulo.

**RF-03 — Citas con ciclo de vida y soft delete**
Un paciente reserva una cita con un médico en una fecha y hora específicas.
El estado de la cita sigue el ciclo: `scheduled → confirmed → completed` o `cancelled`.
Las citas canceladas se conservan con `cancelled_at` (soft delete) para auditoría.
Un médico no puede tener dos citas activas al mismo tiempo.

**RF-04 — Historial médico con auditoría completa**
Cada cita completada genera un registro en `medical_records`. Si el médico edita
el diagnóstico o las notas de un historial, la versión anterior se conserva en
`medical_records_history` con autor y timestamp.

**RF-05 — Prescripciones**
Después de una cita, el médico puede emitir prescripciones. Cada prescripción
contiene uno o más medicamentos, con dosis y duración en días.

**RF-06 — Índices justificados**
Todas las columnas FK deben tener índice. Las búsquedas más frecuentes son:
citas por médico + fecha, historial por paciente, prescripciones por cita.

**RF-07 — Objetos avanzados**
- Vista `vw_upcoming_appointments`: citas confirmadas o agendadas en los
  próximos 7 días con nombre de médico y paciente.
- Función `fn_get_patient_history(patient_uuid UUID)`: devuelve todas las
  entradas de historial de un paciente ordenadas por fecha.
- Trigger `trg_medical_records_audit`: captura en `medical_records_history`
  cada `UPDATE` en `medical_records`.

---

## Entregables

Completa el archivo `starter/medisync-final.sql` con todos los `TODO`:

| Parte | Contenido | Concepto aplicado |
|-------|-----------|------------------|
| 0 | Schema `medisync` | DDL, schemas |
| 1 | Tabla `departments` | Jerarquía, auto-referencia |
| 2 | Tabla `doctors` | FK, relación reflexiva |
| 3 | Tabla `patients` | UUID, TIMESTAMPTZ, NOT NULL |
| 4 | Tabla `appointments` | Soft delete, CHECK de estado |
| 5 | Tablas `medical_records` + `medical_records_history` | Auditoría, historial |
| 6 | Tablas `drugs` + `prescriptions` | Normalización, M:N |
| 7 | Índices | B-tree, índices parciales |
| 8 | Vista `vw_upcoming_appointments` | Vistas |
| 9 | Función `fn_get_patient_history` | Funciones plpgsql |
| 10 | Trigger auditoría `medical_records` | Triggers, AFTER |
| 11 | `WITH RECURSIVE` para árbol de departamentos | CTEs recursivas |
| 12 | Datos de prueba | INSERT |
| 13 | Consultas de demostración | SELECT + JOIN + funciones |

---

## Restricciones de Diseño

- Nomenclatura del bootcamp: UUID PKs, prefijos de entidad, constraints nombradas
- Normalización mínima 3FN (con justificación si desnormalizas algo)
- Toda FK con `ON DELETE` explícito
- `TIMESTAMPTZ` para fechas, `NUMERIC` para montos
- Los comentarios SQL explican el "por qué" de las decisiones no obvias

---

← [Práctica GymPro](../2-practicas/README.md) | → [Recursos](../4-recursos/ebooks-free/README.md)

- [ ] Documento de requerimientos
- [ ] Diagrama ER (draw.io / SVG)
- [ ] Modelo DBML en dbdiagram.io
- [ ] Script DDL completo e idempotente
- [ ] Estrategia de indexación justificada
- [ ] Presentación técnica (10 min)

## 🚀 Instrucciones

1. Trabaja en el directorio `starter/`
2. Lee los comentarios `-- TODO:` en cada archivo y completa el código
3. Prueba tu solución ejecutando los scripts en PostgreSQL 16+
4. Documenta tus decisiones de diseño en este README

## ✅ Criterios de Aceptación

- [ ] Todos los scripts SQL ejecutan sin errores en PostgreSQL 16+
- [ ] Las constraints nombradas siguen la convención `tipo_tabla_columna`
- [ ] El diseño está justificado en comentarios SQL o en este README

## 🔗 Referencias

- [Semana 14 — Teoría](../1-teoria/)
- [Semana 14 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)
