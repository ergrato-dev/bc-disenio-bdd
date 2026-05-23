# Ebooks y Documentación Oficial — Semana 13

## Documentación PostgreSQL 16 (gratuita y oficial)

### Partial Indexes
- **URL:** <https://www.postgresql.org/docs/16/indexes-partial.html>
- **Por qué:** Explica el concepto de índices parciales con `WHERE`, clave para
  implementar el patrón soft delete con unicidad selectiva.

### Row Security Policies (RLS)
- **URL:** <https://www.postgresql.org/docs/16/ddl-rowsecurity.html>
- **Por qué:** Guía oficial de Row Level Security: `ENABLE ROW LEVEL SECURITY`,
  `CREATE POLICY`, `BYPASSRLS`. Fundamental para el patrón multi-tenancy.

### WITH Queries (CTEs recursivas)
- **URL:** <https://www.postgresql.org/docs/16/queries-with.html>
- **Por qué:** Explica la sintaxis `WITH RECURSIVE`, cómo definir el caso base
  y el caso recursivo, y los límites de profundidad (`RECURSIVE ... CYCLE`).

### Trigger Functions
- **URL:** <https://www.postgresql.org/docs/16/plpgsql-trigger.html>
- **Por qué:** Referencia completa de las variables especiales en triggers:
  `TG_OP`, `NEW`, `OLD`, `TG_TABLE_NAME`. Esencial para los triggers de historial.

### System Administration Functions — `current_setting()`
- **URL:** <https://www.postgresql.org/docs/16/functions-admin.html>
- **Por qué:** Documenta `current_setting()` y `set_config()`, las funciones que
  permiten comunicar contexto (user_id, tenant_id) desde la aplicación al trigger.

---

## Artículo Técnico — Hierarchical Queries in PostgreSQL

- **URL:** <https://explainextended.com/2009/03/17/hierarchical-queries-in-postgresql/>
- **Por qué:** Comparativa detallada de los 4 modelos de árbol (Adjacency List,
  Path Enumeration, Nested Sets, Closure Table) con ejemplos de rendimiento.
  Aunque es anterior a PG16, los patrones siguen siendo válidos.

---

## Artículo Técnico — Soft Deletes: pros and cons

- **URL:** <https://vladmihalcea.com/soft-delete/>
- **Por qué:** Análisis de trade-offs del soft delete: impacto en índices,
  integridad referencial con registros eliminados, y alternativas como el
  archivado en tabla separada.
