# Proyecto Semana 08 — ConnectPro: Llevar el Modelo a 3FN/FNBC

> **Fase:** Modelo Lógico &nbsp;|&nbsp; **Semana:** 08 de 14

## Contexto del Negocio

**ConnectPro** es la red social profesional que comenzaste a modelar en las semanas 06 y 07.
El equipo de ingeniería revisó el esquema en 2FN y descubrió que dos tablas importantes
aún contienen dependencias transitivas. Además, el product manager solicitó mantener un
contador de postulaciones en cada oferta de trabajo para mejorar el rendimiento del listado
principal — una decisión que hay que documentar y justificar técnicamente.

Tu misión en este proyecto es llevar el modelo a **3FN y FNBC** donde sea posible, y
documentar con criterio técnico las decisiones de desnormalización que sean justificadas.

## Objetivo

- Identificar y clasificar todas las dependencias transitivas en el esquema heredado
- Extraer las entidades faltantes (`countries`, `job_categories`) mediante el algoritmo de síntesis
- Verificar si el modelo resultante también está en FNBC
- Documentar la decisión de desnormalización de `job_applications_count` con el formato estándar

## Esquema de Partida (heredado de Semana 07 — con violaciones 3FN)

El esquema está en `starter/connectpro-normalizacion-3fn.sql`. Contiene dos tablas con
violaciones 3FN intencionales que debes corregir:

### Violación 1 — `users`: dependencia transitiva de país

```
user_id → user_country_code → user_country_name   (transitiva ❌)
```

La columna `user_country_name` depende de `user_country_code`, no directamente
de `user_id`. Si un país cambia de nombre oficial, hay que actualizar todas las
filas de usuarios de ese país.

### Violación 2 — `job_postings`: dependencia transitiva de categoría

```
job_posting_id → job_category_id → job_category_name   (transitiva ❌)
```

La columna `job_category_name` depende de `job_category_id`. Si se renombra
una categoría, habría que tocar miles de filas de ofertas.

### Desnormalización Documentada — `job_applications_count`

La columna `job_applications_count INTEGER DEFAULT 0` en `job_postings` es
**redundante**: su valor podría calcularse con `COUNT(*) FROM job_applications
WHERE job_posting_id = ...`. Sin embargo, el listado de ofertas se ejecuta
~30,000 veces por día y leer el contador directamente evita un JOIN y GROUP BY
costoso. Esta decisión **debe estar documentada** en el DDL.

## Requerimientos Funcionales

- **RF-01:** Extraer `countries(country_code PK, country_name)` y referenciarla desde `users`
- **RF-02:** Extraer `job_categories(job_category_id PK, job_category_name)` y referenciarla desde `job_postings`
- **RF-03:** Verificar con consultas diagnóstico que ya no hay transitivas en el modelo
- **RF-04:** Evaluar si el modelo resultante está en FNBC (justificar con FDs)
- **RF-05:** Documentar la decisión de desnormalización de `job_applications_count` con el formato estándar (razón, trade-off, mecanismo de sincronización)
- **RF-06:** Escribir el trigger o el comentario de qué trigger haría falta para mantener `job_applications_count` sincronizado

## Restricciones de Diseño

- Usar `UUID DEFAULT gen_random_uuid()` para todas las PKs nuevas
- `country_code CHAR(2)` como PK de `countries` (clave natural — código ISO 3166-1 alpha-2)
- `job_category_id SMALLINT GENERATED ALWAYS AS IDENTITY` en `job_categories`
- Todas las `FOREIGN KEY` con política `ON DELETE` explícita y justificada
- Nombres de constraints en formato `tipo_tabla_columna`

## Entregables

1. Script `starter/connectpro-normalizacion-3fn.sql` completado con:
   - DDL de `countries` y `job_categories`
   - `ALTER TABLE` para modificar `users` y `job_postings`
   - Consultas de verificación
   - Análisis de FNBC comentado
   - Bloque de documentación de la desnormalización

## Instrucciones

1. Abre `starter/connectpro-normalizacion-3fn.sql`
2. Sigue los `-- TODO:` en orden — cada uno corresponde a un RF
3. Ejecuta sección por sección en pgAdmin o DBeaver
4. Verifica con las consultas diagnóstico incluidas al final

---

← [Práctica](../2-practicas/README.md) | → [Recursos](../4-recursos/ebooks-free/README.md)

## ✅ Criterios de Aceptación

- [ ] Todos los scripts SQL ejecutan sin errores en PostgreSQL 16+
- [ ] Las constraints nombradas siguen la convención `tipo_tabla_columna`
- [ ] El diseño está justificado en comentarios SQL o en este README

## 🔗 Referencias

- [Semana 08 — Teoría](../1-teoria/)
- [Semana 08 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)
