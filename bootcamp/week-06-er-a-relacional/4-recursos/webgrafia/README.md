# Webografía — Semana 06: Del ER al Modelo Relacional

## PostgreSQL — Referencias Oficiales

| Recurso | URL | Qué cubre |
|---|---|---|
| DDL: Constraints | <https://www.postgresql.org/docs/16/ddl-constraints.html> | NOT NULL, CHECK, UNIQUE, FK, PK |
| CREATE TABLE | <https://www.postgresql.org/docs/16/sql-createtable.html> | Sintaxis completa y opciones avanzadas |
| ALTER TABLE | <https://www.postgresql.org/docs/16/sql-altertable.html> | Agregar constraints y columnas post-creación |
| Data Types | <https://www.postgresql.org/docs/16/datatype.html> | UUID, TIMESTAMPTZ, NUMERIC, JSONB, etc. |
| Table Inheritance | <https://www.postgresql.org/docs/16/ddl-inherit.html> | Herencia nativa de tablas en PostgreSQL |

---

## DBML — Referencias

| Recurso | URL | Qué cubre |
|---|---|---|
| DBML Docs | <https://dbml.dbdiagram.io/docs/> | Sintaxis completa: tablas, refs, índices, notas |
| dbdiagram.io | <https://dbdiagram.io> | Editor visual en línea, exportar SQL, compartir |
| DBML GitHub | <https://github.com/holistics/dbml> | Especificación del lenguaje y parser open source |

---

## Artículos y Guías

### Transformación ER → Relacional

- **"ER to Relational Mapping — Step by Step"** — Database Management Systems (Ramakrishnan):
  <https://pages.cs.wisc.edu/~dbbook/openAccess/thirdEdition/slides/slides3ed-english/Ch19.pdf>
  Slides con los 7 pasos de transformación del libro canónico.

- **"Entity Relationship Diagram to Relational Model"** — Studytonight:
  <https://www.studytonight.com/dbms/er-to-relational-mapping.php>
  Referencia rápida con ejemplos para cada tipo de relación.

---

### Herencia de Tablas (R7)

- **"Patterns of Enterprise Application Architecture: Inheritance Mappers"** — Martin Fowler:
  <https://martinfowler.com/eaaCatalog/singleTableInheritance.html>
  Descripción canónica de STI, CTI (Class Table Inheritance) y Concrete Table.

- **"Single Table Inheritance vs Class Table Inheritance"** — Bill Karwin:
  <https://stackoverflow.com/a/3579462>
  Respuesta Stack Overflow con la comparativa más citada de la comunidad.

---

### FK y ON DELETE

- **"Foreign Keys in PostgreSQL: A Practical Guide"** — Crunchydata:
  <https://www.crunchydata.com/blog/postgres-constraints-for-newbies>
  Guía práctica con todos los tipos de constraints y cuándo usarlos.

- **"ON DELETE CASCADE vs RESTRICT vs SET NULL"** — vertabelo.com:
  <https://vertabelo.com/blog/a-comprehensive-guide-to-foreign-keys-in-postgresql/>
  Comparativa detallada con casos de uso reales para cada política.
