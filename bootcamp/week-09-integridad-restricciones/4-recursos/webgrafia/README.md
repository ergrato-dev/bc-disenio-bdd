# Webografía — Semana 09: Integridad y Restricciones

> Referencias web organizadas por tema para consulta durante y después de
> la semana.

---

## Documentación Oficial PostgreSQL

| Recurso | URL | Descripción |
|---------|-----|-------------|
| Constraints (DDL) | <https://www.postgresql.org/docs/16/ddl-constraints.html> | Referencia completa de todos los tipos de constraints |
| ALTER TABLE | <https://www.postgresql.org/docs/16/sql-altertable.html> | Agregar, modificar y eliminar constraints en tablas existentes |
| CREATE TABLE | <https://www.postgresql.org/docs/16/sql-createtable.html> | Sintaxis completa de declaración de constraints en la creación |
| pg_constraint | <https://www.postgresql.org/docs/16/catalog-pg-constraint.html> | Catálogo del sistema: inspeccionar constraints programáticamente |
| CREATE INDEX | <https://www.postgresql.org/docs/16/sql-createindex.html> | Crear índices en columnas FK y columnas frecuentemente consultadas |

---

## Integridad Referencial y Diseño

| Recurso | URL | Descripción |
|---------|-----|-------------|
| Foreign Keys — Use The Index, Luke | <https://use-the-index-luke.com/sql/join/foreign-key-indexes> | Por qué necesitas índices en columnas FK (con EXPLAIN ANALYZE) |
| NULL Values in SQL | <https://modern-sql.com/concept/three-valued-logic> | Lógica de tres valores y comportamiento de NULL en SQL |
| Referential Integrity — PostgreSQL Wiki | <https://wiki.postgresql.org/wiki/Referential_integrity> | Guía práctica de integridad referencial con ejemplos avanzados |
| Deferrable Constraints | <https://begriffs.com/posts/2017-08-27-deferrable-sql-constraints.html> | Cuándo y cómo usar constraints diferibles (DEFERRABLE) |

---

## Herramientas y Utilidades

| Recurso | URL | Descripción |
|---------|-----|-------------|
| pgAdmin Constraints UI | <https://www.pgadmin.org/docs/pgadmin4/latest/table_dialog.html> | Cómo gestionar constraints visualmente en pgAdmin 4 |
| DBeaver ER Diagrams | <https://dbeaver.com/docs/dbeaver/ER-Diagrams/> | Ver el diagrama ER generado desde constraints reales de la BD |
| dbdiagram.io DBML docs | <https://dbml.dbdiagram.io/docs/#indexes> | Cómo declarar constraints e índices en DBML para dbdiagram.io |

---

## Artículos Complementarios

| Recurso | URL | Descripción |
|---------|-----|-------------|
| Don't use ENUMs in PostgreSQL | <https://tapoueh.org/blog/2018/05/postgresql-data-types-enum/> | Por qué preferir CHECK + VARCHAR sobre tipos ENUM en la mayoría de casos |
| Database Constraints Best Practices | <https://www.depesz.com/2010/03/03/writing-better-code-constraints/> | Depesz (ex-Postgres core) sobre prácticas recomendadas en constraints |
| Partial Indexes — PostgreSQL | <https://www.postgresql.org/docs/16/indexes-partial.html> | Índices parciales para implementar UNIQUE condicional (soft delete) |
| Information Schema Constraints | <https://www.postgresql.org/docs/16/infoschema-table-constraints.html> | Consultar constraints a través del `information_schema` estándar SQL |
