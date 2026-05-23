# Ebooks Gratuitos — Semana 09: Integridad y Restricciones

> Recursos de lectura libre para profundizar en constraints, integridad
> referencial y diseño defensivo de bases de datos.

---

## PostgreSQL Documentation — Constraints

| Campo   | Detalle |
|---------|---------|
| Título  | PostgreSQL 16 — Chapter 5: Data Definition — Constraints |
| Autor   | The PostgreSQL Global Development Group |
| URL     | <https://www.postgresql.org/docs/16/ddl-constraints.html> |
| Idioma  | Inglés |
| Acceso  | Gratuito (documentación oficial) |

**Por qué leerlo:** Es la referencia definitiva sobre cada tipo de constraint
en PostgreSQL 16. Cubre NOT NULL, UNIQUE, PK, FK, CHECK y EXCLUDE con ejemplos
detallados de cada comportamiento. Especialmente útil para entender `DEFERRABLE`,
`INITIALLY DEFERRED` y las diferencias sutiles entre `RESTRICT` y `NO ACTION`.

---

## Use The Index, Luke — No Fear of Constraints

| Campo   | Detalle |
|---------|---------|
| Título  | Use The Index, Luke — Foreign Key Indexes |
| Autor   | Markus Winand |
| URL     | <https://use-the-index-luke.com/sql/join/foreign-key-indexes> |
| Idioma  | Inglés |
| Acceso  | Gratuito (web) |

**Por qué leerlo:** Explica por qué PostgreSQL **no crea automáticamente**
índices en columnas FK y qué problemas de rendimiento causa omitirlos.
Incluye ejemplos de `EXPLAIN ANALYZE` mostrando el impacto real en
operaciones de DELETE y UPDATE en la tabla padre.

---

## PostgreSQL Documentation — Information Schema

| Campo   | Detalle |
|---------|---------|
| Título  | PostgreSQL 16 — Chapter 37: The Information Schema (table_constraints, referential_constraints) |
| Autor   | The PostgreSQL Global Development Group |
| URL     | <https://www.postgresql.org/docs/16/information-schema.html> |
| Idioma  | Inglés |
| Acceso  | Gratuito (documentación oficial) |

**Por qué leerlo:** Muestra cómo consultar los metadatos de constraints a
través del `information_schema` estándar SQL, como alternativa portátil a
`pg_constraint`. Útil para escribir scripts de auditoría que funcionen en
múltiples SGBD.

---

## Database Reliability Engineering (extracto relevante)

| Campo   | Detalle |
|---------|---------|
| Título  | Database Reliability Engineering — Cap. 3: Data Integrity |
| Autores | Laine Campbell, Charity Majors |
| URL     | <https://www.oreilly.com/library/view/database-reliability-engineering/9781491925935/> |
| Idioma  | Inglés |
| Acceso  | Preview gratuito en O'Reilly (capítulos 1-3) |

**Por qué leerlo:** Perspectiva de ingeniería de confiabilidad sobre la
integridad de datos. Argumenta por qué las restricciones deben estar en la
base de datos y no solo en la aplicación, con ejemplos de incidentes reales
causados por ausencia de constraints en producción.
