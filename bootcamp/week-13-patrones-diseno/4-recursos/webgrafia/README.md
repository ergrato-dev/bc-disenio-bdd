# Webografía — Semana 13

## Soft Delete

### vladmihalcea.com — The best way to implement soft deletes
- **URL:** <https://vladmihalcea.com/soft-delete/>
- **Por qué:** Análisis detallado de los trade-offs del soft delete con énfasis
  en integridad referencial, índices y alternativas como la tabla de archivo.

### use-the-index-luke.com — Partial Indexes
- **URL:** <https://use-the-index-luke.com/sql/where-clause/partial-and-filtered-indexes>
- **Por qué:** Explica cuándo usar índices parciales y cuándo no, con ejemplos
  de rendimiento. Aplica directamente al patrón soft delete.

---

## Auditoría e Historia

### PostgreSQL Wiki — Audit Trigger
- **URL:** <https://wiki.postgresql.org/wiki/Audit_trigger>
- **Por qué:** Implementación canónica de un trigger de auditoría genérico en
  PostgreSQL, mantenida por la comunidad. Sirve como referencia para el patrón
  de `products_history` y `articles_history`.

### PostgreSQL 16 — Event Triggers vs Row Triggers
- **URL:** <https://www.postgresql.org/docs/16/event-triggers.html>
- **Por qué:** Explica la diferencia entre row-level triggers (los que usamos en
  el curso) y event triggers (para cambios DDL). Amplía el contexto de auditoría.

---

## Jerarquías

### explainextended.com — Hierarchical Queries in PostgreSQL
- **URL:** <https://explainextended.com/2009/03/17/hierarchical-queries-in-postgresql/>
- **Por qué:** Comparativa de rendimiento de los 4 modelos de árbol con planes
  de ejecución reales. Referencia clásica del tema.

### PostgreSQL 16 — Recursive CTEs
- **URL:** <https://www.postgresql.org/docs/16/queries-with.html#QUERIES-WITH-RECURSIVE>
- **Por qué:** Documentación oficial de `WITH RECURSIVE`, incluyendo la cláusula
  `CYCLE` para detectar ciclos en grafos (no solo árboles).

---

## Multi-Tenancy y Row Level Security

### Supabase — Row Level Security
- **URL:** <https://supabase.com/docs/guides/database/postgres/row-level-security>
- **Por qué:** Guía práctica muy bien escrita sobre RLS con casos de uso SaaS.
  Aunque está orientada a Supabase, usa PostgreSQL estándar.

### Citus Data — Multi-Tenancy with PostgreSQL
- **URL:** <https://www.citusdata.com/blog/2016/10/03/designing-your-saas-database-for-high-scalability/>
- **Por qué:** Análisis de las 3 estrategias de multi-tenancy con escenarios
  reales de escalado y recomendaciones según el volumen de tenants.

### PostgreSQL 16 — Schema-per-tenant
- **URL:** <https://www.postgresql.org/docs/16/ddl-schemas.html>
- **Por qué:** Referencia oficial de la gestión de schemas en PostgreSQL,
  fundamento de la estrategia schema-per-tenant.
