# Proyecto Semana 11 — Estrategia de Indexación para TaskFlow

> **Fase:** Modelo Físico &nbsp;|&nbsp; **Semana:** 11 de 14

## Contexto del Negocio

**TaskFlow** es la plataforma de gestión de proyectos que comenzaste a diseñar en la
semana 10. El equipo de ingeniería ha notado que, a medida que los datos crecen,
algunas consultas se vuelven lentas: asignar tareas, cargar el tablero de un proyecto
y filtrar por estado o fecha de vencimiento.

Tu misión es analizar las **8 consultas más frecuentes** de la aplicación, diseñar
una estrategia de indexación justificada y verificar el impacto con `EXPLAIN ANALYZE`.

---

## Requerimientos Funcionales

Las siguientes consultas representan las operaciones más críticas de TaskFlow.
Deberás crear los índices necesarios para que cada una use un **Index Scan**
(o Index Only Scan) en lugar de un Seq Scan.

| # | Consulta | Descripción |
|---|----------|-------------|
| Q1 | `WHERE assignee_id = ?` | Todas las tareas asignadas a un miembro |
| Q2 | `WHERE project_id = ? AND task_status = 'in_progress' ORDER BY task_priority` | Tareas activas de un proyecto por prioridad |
| Q3 | `WHERE task_id = ? ORDER BY created_at DESC` | Comentarios recientes de una tarea |
| Q4 | `WHERE organization_id = ?` | Proyectos de una organización |
| Q5 | `WHERE task_status = 'backlog'` (toda la BD) | Baja selectividad — espera Seq Scan |
| Q6 | `WHERE project_id = ?` en `project_members` | Miembros de un proyecto |
| Q7 | JOIN a través de `task_labels` | Tareas con una etiqueta específica |
| Q8 | `WHERE due_date < CURRENT_DATE AND task_status NOT IN ('done','cancelled')` | Tareas vencidas activas |

---

## Entregables

### 1. Esquema con datos de prueba (`starter/taskflow-indexing.sql`)

El archivo `starter/taskflow-indexing.sql` contiene:

- **PARTE 1** — Esquema completo de TaskFlow (9 tablas)
- **PARTE 2** — Generación de 50 000 tareas con `generate_series`
- **PARTE 3** — Las 8 consultas con `EXPLAIN ANALYZE` sin índices
- **PARTE 4** — Sección `TODO` para que crees los índices justificados
- **PARTE 5** — Las mismas 8 consultas para ejecutar con los índices

### 2. Tabla de resultados (comentario SQL en PARTE 5)

Completa la tabla en tu script:

```
-- | Q# | Nodo antes  | ms antes | Nodo después   | ms después | Mejora |
-- |----|-------------|----------|----------------|------------|--------|
-- | Q1 |             |          |                |            |        |
-- | Q2 |             |          |                |            |        |
-- | Q3 |             |          |                |            |        |
-- | Q4 |             |          |                |            |        |
-- | Q5 |             |          |                |            |        |
-- | Q6 |             |          |                |            |        |
-- | Q7 |             |          |                |            |        |
-- | Q8 |             |          |                |            |        |
```

### 3. Justificación de índices no creados

Explica en comentarios SQL por qué decidiste **no** crear un índice en Q5
(baja selectividad) y qué observaste en el plan de ejecución.

---

## Criterios de Evaluación

| Criterio | Puntos |
|----------|--------|
| Índices correctos creados para Q1–Q4, Q6–Q8 | 40 |
| Q5 no tiene índice y se justifica con evidencia del plan | 15 |
| Q8 usa un índice parcial con cláusula `WHERE` | 15 |
| Tabla de resultados completa con tiempos reales | 20 |
| Nomenclatura de índices sigue `ix_tabla_columna` | 10 |

---

## Referencias

- [Semana 11 — Teoría](../1-teoria/)
- [Semana 11 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16 — Capítulo 11: Índices](https://www.postgresql.org/docs/16/indexes.html)

← [Semana 10](../../week-10-ddl-postgresql/README.md) | → [Semana 12](../../week-12-objetos-avanzados/README.md)
