# Proyecto Semana 10 — TaskFlow: Sistema de Gestión de Proyectos

> **Fase:** Modelo Físico &nbsp;|&nbsp; **Semana:** 10 de 14

## Contexto del Negocio

**TaskFlow** es una plataforma de gestión de proyectos que permite a equipos
de desarrollo organizar su trabajo mediante proyectos, tareas y etiquetas.
Funciona de forma similar a Linear o Jira: cada organización gestiona
múltiples proyectos, y cada proyecto tiene tareas asignadas a sus miembros.

La plataforma exige que cada tarea tenga un **número de ticket visible**
(ej: `TASK-42`) para facilitar la comunicación entre el equipo, además de un
identificador interno UUID para las integraciones de API.

---

## Objetivo

Escribir el script DDL completo para TaskFlow aplicando los conceptos de la
Semana 10: selección de tipos de datos, organización en schema, uso correcto
de `GENERATED ALWAYS AS IDENTITY` para el número de ticket, y patrón de
script idempotente.

---

## Requerimientos Funcionales

| Código | Requerimiento |
|--------|---------------|
| RF-01  | El sistema gestiona **organizaciones** que agrupan miembros y proyectos |
| RF-02  | Un **miembro** pertenece a una organización y tiene un rol (`admin`, `manager`, `developer`, `viewer`) |
| RF-03  | Un miembro puede ser **miembro de proyecto** con un rol adicional (`lead`, `developer`, `reviewer`, `observer`) |
| RF-04  | Cada **proyecto** tiene un código corto único dentro de su organización (`project_key`, máx. 10 chars) |
| RF-05  | Un proyecto puede estar en estado `active`, `on_hold`, `completed` o `archived` |
| RF-06  | Cada **tarea** tiene un `task_number` auto-incremental visible al usuario y un `task_id` UUID interno |
| RF-07  | Las tareas tienen prioridad numérica del 1 (crítica) al 4 (baja) |
| RF-08  | Las tareas tienen estado: `backlog`, `in_progress`, `in_review`, `done`, `cancelled` |
| RF-09  | Cada proyecto puede tener **etiquetas** (`labels`) con nombre y color hexadecimal (#RRGGBB) |
| RF-10  | Una tarea puede tener múltiples etiquetas (relación N:M) |
| RF-11  | Los miembros pueden escribir **comentarios** en las tareas |
| RF-12  | Se pueden adjuntar **archivos** a las tareas, guardando nombre y tamaño en bytes |

---

## Diagrama de Entidades

```
organizations
    ├── members  (FK → organizations)
    ├── projects (FK → organizations, owner_id → members)
    │     ├── project_members (FK → projects, members)
    │     ├── labels          (FK → projects)
    │     └── tasks           (FK → projects, assignee → members, reporter → members)
    │           ├── task_labels  (FK → tasks, labels)
    │           ├── comments     (FK → tasks, author → members)
    │           └── attachments  (FK → tasks, uploaded_by → members)
```

---

## Decisiones de Diseño que Debes Tomar

Antes de escribir el DDL, responde estas preguntas en un comentario dentro
de tu script:

1. ¿Qué tipo usas para `task_priority`? ¿Por qué no `VARCHAR`?
2. ¿Por qué `task_number` es `BIGINT GENERATED ALWAYS AS IDENTITY` en lugar
   de `UUID` o `SERIAL`?
3. ¿Qué tipo usas para `label_color`? ¿Cómo validas el formato `#RRGGBB`?
4. ¿Qué política `ON DELETE` aplicas en `task_labels.task_id`? ¿Y en
   `task_labels.label_id`?
5. ¿Por qué `project_members` tiene una PK propia UUID en lugar de una PK
   compuesta `(project_id, member_id)`?

---

## Entregables

- [ ] Archivo `starter/taskflow-ddl.sql` completado y probado en PostgreSQL 16
- [ ] El script debe ejecutarse sin errores dos veces seguidas (idempotente)
- [ ] El script debe incluir al menos 2 filas de datos de prueba por tabla
- [ ] Responde las 5 preguntas de diseño en comentarios dentro del SQL

### Criterios de Evaluación

| Criterio                                           | Puntaje |
|----------------------------------------------------|---------|
| Tipos de datos correctos y justificados            | 25 %    |
| Constraints nombrados con la convención del bootcamp | 25 %  |
| Script idempotente (`IF NOT EXISTS`)               | 20 %    |
| Índices en todas las columnas FK                   | 15 %    |
| Datos de prueba coherentes y respuestas de diseño  | 15 %    |

---

← [Práctica: ShopHub DDL](../2-practicas/README.md) | → [Recursos](../4-recursos/ebooks-free/README.md)
