# Ebooks y Libros Gratuitos — Semana 10: DDL en PostgreSQL

## Documentación Oficial PostgreSQL 16

| Título | URL | Descripción |
|--------|-----|-------------|
| Chapter 8 — Data Types | <https://www.postgresql.org/docs/16/datatype.html> | Referencia completa de todos los tipos de datos en PostgreSQL 16: numéricos, texto, fecha/hora, booleano, UUID, JSON, arrays y tipos especiales. **Indispensable tenerlo abierto al escribir DDL.** |
| CREATE SCHEMA | <https://www.postgresql.org/docs/16/sql-createschema.html> | Sintaxis oficial de `CREATE SCHEMA`, opciones de autorización y ejemplos. |
| CREATE SEQUENCE | <https://www.postgresql.org/docs/16/sql-createsequence.html> | Todas las opciones de `CREATE SEQUENCE`: START, INCREMENT, CYCLE, CACHE. |
| CREATE TABLE | <https://www.postgresql.org/docs/16/sql-createtable.html> | Sintaxis completa de `CREATE TABLE`, `GENERATED`, columnas computadas, y todas las formas de constraint. |
| ALTER TABLE | <https://www.postgresql.org/docs/16/sql-altertable.html> | Referencia de `ADD COLUMN IF NOT EXISTS`, `ADD CONSTRAINT`, `ALTER COLUMN SET DEFAULT`. |
| Chapter 5 — DDL (Data Definition) | <https://www.postgresql.org/docs/16/ddl.html> | Capítulo completo sobre DDL: tablas, schemas, herencia, dependencias y modificaciones. |

---

## Libros de Acceso Libre

| Título | Autor | URL | Por qué leerlo |
|--------|-------|-----|----------------|
| **The Internals of PostgreSQL** — Capítulo 1: Cluster, Database, Schema | Hironobu Suzuki | <https://www.interdb.jp/pg/pgsql01.html> | Explica cómo PostgreSQL almacena físicamente objetos: tablespaces, schemas, OIDs. Profundiza el "por qué" detrás de `pg_catalog` y `information_schema`. |
| **PostgreSQL 16 Tutorial** — Data Types | PostgreSQL Tutorial | <https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-data-types/> | Tutorial práctico con ejemplos de cada tipo de dato, cuándo usarlo y comparaciones. Buen complemento a la documentación oficial. |
| **SQL Style Guide** | Simon Holywell | <https://www.sqlstyle.guide/> | Guía de estilo SQL ampliamente adoptada. Incluye convenciones de nomenclatura, indentación y estructura de scripts DDL. |

---

## Referencia Rápida de Tipos (Cheatsheet)

| Enlace | Descripción |
|--------|-------------|
| <https://www.postgresql.org/docs/16/datatype-numeric.html> | Detalle de todos los tipos numéricos con rangos exactos |
| <https://www.postgresql.org/docs/16/datatype-character.html> | Diferencias internas entre `CHAR`, `VARCHAR` y `TEXT` |
| <https://www.postgresql.org/docs/16/datatype-datetime.html> | Tipos de fecha/hora, zonas horarias e intervalos |
| <https://www.postgresql.org/docs/16/datatype-uuid.html> | Tipo `UUID` nativo y uso de `gen_random_uuid()` |
| <https://www.postgresql.org/docs/16/datatype-json.html> | Diferencias entre `JSON` y `JSONB`, operadores y funciones |
