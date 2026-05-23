# Webografía — Semana 10: DDL en PostgreSQL

## Documentación Oficial

| Recurso | URL | Descripción |
|---------|-----|-------------|
| PostgreSQL 16 Docs — Data Types | <https://www.postgresql.org/docs/16/datatype.html> | Referencia completa de todos los tipos. Punto de partida obligatorio al elegir tipos para una columna. |
| PostgreSQL 16 Docs — DDL | <https://www.postgresql.org/docs/16/ddl.html> | Capítulo 5 completo: tablas, schemas, constraints, herencia y particionamiento. |
| PostgreSQL 16 Docs — CREATE SCHEMA | <https://www.postgresql.org/docs/16/sql-createschema.html> | Sintaxis y ejemplos oficiales. |
| PostgreSQL 16 Docs — search_path | <https://www.postgresql.org/docs/16/runtime-config-client.html#GUC-SEARCH-PATH> | Cómo PostgreSQL resuelve nombres de objetos no calificados. |
| PostgreSQL 16 Docs — Sequences | <https://www.postgresql.org/docs/16/sql-createsequence.html> | Todas las opciones de `CREATE SEQUENCE` y funciones de control. |

---

## Artículos Técnicos

| Título | Sitio | URL | Descripción |
|--------|-------|-----|-------------|
| GENERATED ALWAYS AS IDENTITY vs SERIAL | depesz.com | <https://www.depesz.com/2017/04/10/waiting-for-postgresql-10-identity-columns/> | Análisis técnico en profundidad de las diferencias entre SERIAL y GENERATED AS IDENTITY por uno de los core developers de PostgreSQL. |
| UUID vs BIGINT as Primary Key | Haki Benita | <https://hakibenita.com/postgresql-hash-index> | Análisis del impacto de distintos tipos de PK en el rendimiento de índices. |
| PostgreSQL Data Type Selection Guide | PostgreSQL Tutorial | <https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-data-types/> | Guía práctica sobre cuándo elegir cada tipo de dato. |
| The many faces of DISTINCT in PostgreSQL | Modern SQL | <https://modern-sql.com/> | Explicaciones de conceptos SQL estándar con foco en PostgreSQL. |
| Idempotent Migrations Best Practices | Flyway Blog | <https://flywaydb.org/documentation/concepts/migrations> | Aunque habla de Flyway, explica muy bien el concepto de scripts idempotentes y por qué importan. |

---

## Herramientas en Línea

| Herramienta | URL | Utilidad |
|-------------|-----|---------|
| **dbdiagram.io** | <https://dbdiagram.io> | Crear el modelo lógico en DBML antes de escribir el DDL. |
| **pgFormatter** | <https://sqlformat.darold.net/> | Formateador de SQL online — útil para limpiar scripts antes de entregar. |
| **regex101** | <https://regex101.com/> | Probar expresiones regulares para las constraints `CHECK ~ '...'`. |
| **PostgreSQL Explain** | <https://explain.depesz.com/> | Visualizador de planes de ejecución de `EXPLAIN ANALYZE`. |

---

## Temas Relacionados para Explorar Después

| Tema | Enlace sugerido |
|------|-----------------|
| Particionamiento de tablas | <https://www.postgresql.org/docs/16/ddl-partitioning.html> |
| Full-Text Search con `tsvector` | <https://www.postgresql.org/docs/16/textsearch-intro.html> |
| Tipos de rango (`DATERANGE`, `NUMRANGE`) | <https://www.postgresql.org/docs/16/rangetypes.html> |
| Row-Level Security con schemas | <https://www.postgresql.org/docs/16/ddl-rowsecurity.html> |
