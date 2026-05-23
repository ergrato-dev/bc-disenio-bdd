# Proyecto Semana 07 — ConnectPro: Identificar y corregir violaciones 1FN y 2FN

> **Fase:** Modelo Lógico &nbsp;|&nbsp; **Semana:** 07 de 14

## Contexto del Negocio

ConnectPro es la red social profesional que modelaste en la Semana 06. El equipo de
backend implementó el modelo relacional inicial con cierta premura y, al revisar el
esquema semanas después, se encontraron **dos violaciones de formas normales** que
están causando problemas en producción:

1. **Anomalía de actualización masiva:** Cuando un usuario actualiza sus habilidades
   técnicas (`user_skills`), el equipo tiene que ejecutar múltiples `UPDATE` sobre una
   columna de texto con valores separados por comas. Además, no se puede filtrar
   eficientemente por habilidad individual.

2. **Anomalía de inserción en tabla de aplicaciones:** La tabla `job_applications`
   tiene una clave primaria compuesta y almacena el nombre de la empresa junto con los
   datos del postulante. Si se elimina la única aplicación a una oferta, se pierde
   información sobre la empresa.

Tu tarea es diagnosticar exactamente qué forma normal viola cada problema, y
corregirlo aplicando las transformaciones correspondientes.

## Objetivo

Identificar, clasificar y corregir las violaciones de 1FN y 2FN presentes en el
esquema de ConnectPro entregado en `starter/connectpro-normalizacion.sql`.

## Requerimientos

| ID    | Requerimiento                                                                          |
|-------|----------------------------------------------------------------------------------------|
| RF-01 | Identificar qué columna viola 1FN y qué normal form rule incumple exactamente         |
| RF-02 | Crear la tabla `user_skills` con los atributos correctos y FK a `users`               |
| RF-03 | Migrar los datos de `users.user_skills_text` a la nueva tabla `user_skills`            |
| RF-04 | Identificar qué columna de `job_applications` crea una dependencia parcial (viola 2FN) |
| RF-05 | Crear o ajustar la tabla `companies` para alojar los atributos que dependen de `company_id` |
| RF-06 | Asegurarse que `job_applications` solo contenga atributos con FD completa sobre la PK |
| RF-07 | Documentar en comentarios SQL las dependencias funcionales de cada tabla final         |

### Restricciones de diseño

- Usar `UUID DEFAULT gen_random_uuid()` para todas las PKs nuevas
- Definir `ON DELETE CASCADE` en FKs de tablas débiles o derivadas
- Nomenclatura: `pk_`, `fk_`, `uq_`, `ck_` como prefijos de constraints
- Columnas auto-documentadas: `user_skill_name`, `company_name`, etc.

## Esquema con violaciones (punto de partida)

El archivo `starter/connectpro-normalizacion.sql` contiene el esquema de ConnectPro
con las siguientes modificaciones intencionales respecto al modelo de Semana 06:

### Violación 1 — `users.user_skills_text` (1FN)

```sql
-- La tabla users tiene una columna con valores no atómicos:
CREATE TABLE users (
    user_id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_name       VARCHAR(100) NOT NULL,
    user_email      VARCHAR(150) NOT NULL UNIQUE,
    user_skills_text TEXT,   -- "SQL, Python, PostgreSQL, Docker"  ← viola 1FN
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

Un usuario puede tener 0 a N habilidades. Almacenarlas en un campo de texto hace
imposible indexarlas, filtrarlas eficientemente o contarlas por habilidad.

### Violación 2 — `job_applications.company_name` (2FN)

```sql
-- PK compuesta: {user_id, job_posting_id}
-- Pero company_name depende solo de job_posting_id (no de user_id)
CREATE TABLE job_applications (
    user_id         UUID    NOT NULL,
    job_posting_id  UUID    NOT NULL,
    company_name    VARCHAR(100),  -- depende solo de job_posting_id ← viola 2FN
    applied_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, job_posting_id)
);
```

`company_name` depende del `job_posting_id` (la oferta sabe a qué empresa pertenece),
no de la combinación `{user_id, job_posting_id}` → es una **dependencia parcial**.

## Entregables

1. `connectpro-normalizacion.sql` en `starter/` con las correcciones aplicadas
2. Sección de comentarios al inicio del archivo con el mapa de FDs antes y después
3. Consulta de verificación que demuestre que los datos migrados son consistentes

## Instrucciones

1. Abre `starter/connectpro-normalizacion.sql` en DBeaver o pgAdmin
2. Lee los comentarios `-- TODO:` y completa cada sección en orden
3. Ejecuta el script completo en PostgreSQL 16+ sin errores
4. Responde las preguntas de reflexión al final del archivo

---

← [README semana](../README.md) | [Práctica](../2-practicas/README.md)

4. Documenta tus decisiones de diseño en este README

## ✅ Criterios de Aceptación

- [ ] Todos los scripts SQL ejecutan sin errores en PostgreSQL 16+
- [ ] Las constraints nombradas siguen la convención `tipo_tabla_columna`
- [ ] El diseño está justificado en comentarios SQL o en este README

## 🔗 Referencias

- [Semana 07 — Teoría](../1-teoria/)
- [Semana 07 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)
