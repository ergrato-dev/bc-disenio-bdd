# Webografía — Semana 08: Normalización II

## Referencias Web

### Documentación Oficial

#### PostgreSQL 16 — Generated Columns
- **URL:** <https://www.postgresql.org/docs/16/ddl-generated-columns.html>
- **Descripción:** Cómo usar columnas generadas (`GENERATED ALWAYS AS`) como
  alternativa a columnas calculadas mantenidas por triggers.
- **Relevancia:** Patrón de desnormalización — columna calculada sin trigger.

#### PostgreSQL 16 — Materialized Views
- **URL:** <https://www.postgresql.org/docs/16/sql-creatematerializedview.html>
- **Descripción:** Sintaxis y opciones de `CREATE MATERIALIZED VIEW` y
  `REFRESH MATERIALIZED VIEW CONCURRENTLY`.
- **Relevancia:** Patrón 3 de desnormalización — tablas de resumen para reporting.

#### PostgreSQL 16 — Trigger Functions
- **URL:** <https://www.postgresql.org/docs/16/plpgsql-trigger.html>
- **Descripción:** Cómo escribir funciones de trigger en PL/pgSQL para mantener
  columnas calculadas sincronizadas tras INSERT/UPDATE/DELETE.
- **Relevancia:** Mecanismo de sincronización para desnormalización controlada.

---

### Teoría y Tutoriales

#### Wikipedia — Boyce–Codd Normal Form
- **URL:** <https://en.wikipedia.org/wiki/Boyce%E2%80%93Codd_normal_form>
- **Descripción:** Artículo bien mantenido con la definición formal de FNBC,
  el ejemplo clásico de horario y la comparación con 3FN.
- **Relevancia:** Referencia de consulta rápida para definiciones formales.

#### Wikipedia — Third Normal Form
- **URL:** <https://en.wikipedia.org/wiki/Third_normal_form>
- **Descripción:** Definición de 3FN con ejemplos y la sección "Comparison
  with Boyce–Codd normal form" es especialmente útil.
- **Relevancia:** Ver las secciones "Transitive dependency" y "BCNF comparison".

#### Database.Guide — BCNF vs 3NF
- **URL:** <https://database.guide/boyce-codd-normal-form-bcnf/>
- **Descripción:** Explicación visual con ejemplos de tablas antes/después.
  Incluye el ejemplo del horario universitario con todas las CKs identificadas.
- **Relevancia:** Referencia rápida para el ejemplo clásico de FNBC.

#### Database.Guide — Denormalization
- **URL:** <https://database.guide/denormalization/>
- **Descripción:** Introducción a la desnormalización con ejemplos prácticos,
  tipos de redundancia y cuándo cada uno es apropiado.
- **Relevancia:** Sección "When to Denormalize" directamente aplicable al proyecto.

---

### Rendimiento y Optimización

#### Use The Index, Luke — Denormalization
- **URL:** <https://use-the-index-luke.com/sql/testing-scalability/index-only-scan-covering-index>
- **Descripción:** Markus Winand explica cómo los índices cubrientes pueden
  ser una alternativa a la desnormalización para evitar JOINs costosos.
- **Relevancia:** Antes de desnormalizar, considerar si un índice cubriente
  resuelve el problema de rendimiento con menor riesgo.

#### Percona Blog — When to Denormalize a Database
- **URL:** <https://www.percona.com/blog/when-to-denormalize-a-database/>
- **Descripción:** Artículo de blog técnico con criterios cuantitativos para
  decidir cuándo desnormalizar (métricas de latencia, ratio read/write, etc.).
- **Relevancia:** Complementa el árbol de decisión de la teoría semana 08.

---

### Herramientas

#### dbdiagram.io — DBML Reference
- **URL:** <https://dbml.dbdiagram.io/docs/>
- **Descripción:** Referencia del lenguaje DBML para modelar el esquema
  normalizado de ConnectPro como diagrama.
- **Relevancia:** Usa esta referencia para crear el diagrama entidad-relación
  del modelo final del proyecto.

#### pgAdmin 4 — Query Tool
- **URL:** <https://www.pgadmin.org/docs/pgadmin4/latest/query_tool.html>
- **Descripción:** Documentación del Query Tool de pgAdmin para ejecutar y
  analizar los scripts SQL del proyecto.
- **Relevancia:** Herramienta principal para ejecutar y verificar los scripts.

---

← [Videografía](../videografia/README.md) | → [Glosario](../../5-glosario/README.md)
