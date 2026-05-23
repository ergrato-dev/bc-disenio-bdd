# Webografía — Semana 11: Índices y Optimización

## Documentación Oficial

| Recurso | URL | Contenido |
|---------|-----|-----------|
| PostgreSQL 16 — Indexes | https://www.postgresql.org/docs/16/indexes.html | Referencia completa de B-tree, Hash, GIN, GiST, BRIN y opciones de `CREATE INDEX` |
| PostgreSQL 16 — EXPLAIN | https://www.postgresql.org/docs/16/sql-explain.html | Sintaxis y todas las opciones de `EXPLAIN` |
| PostgreSQL 16 — pg_stat_user_indexes | https://www.postgresql.org/docs/16/monitoring-stats.html#MONITORING-PG-STAT-ALL-INDEXES-VIEW | Vista del sistema para monitorear el uso real de índices |
| PostgreSQL 16 — Statistics Used by the Planner | https://www.postgresql.org/docs/16/planner-stats.html | Cómo el planificador usa las estadísticas de `pg_stats` para estimaciones |

## Herramientas Online

| Herramienta | URL | Para qué sirve |
|-------------|-----|----------------|
| **explain.depesz.com** | https://explain.depesz.com | Pega la salida de `EXPLAIN ANALYZE` y obtén una visualización coloreada con alertas. Gratuito |
| **pgBadger** | https://pgbadger.darold.net | Analiza logs de PostgreSQL y genera reportes de consultas lentas. Útil en proyectos reales |
| **PostgreSQL EXPLAIN Visualizer (pev2)** | https://explain.dalibo.com | Alternativa visual a depesz. Muestra el plan como árbol interactivo |

## Artículos Recomendados

| Artículo | URL | Por qué leerlo |
|----------|-----|----------------|
| Use The Index, Luke — The Where Clause | https://use-the-index-luke.com/sql/where-clause | Explica con profundidad cómo las condiciones WHERE afectan el uso de índices |
| Use The Index, Luke — Partial Indexes | https://use-the-index-luke.com/sql/where-clause/partial-and-filtered-indexes | Todo sobre índices parciales y sus ventajas |
| Cybertec — GIN vs GiST for Full-Text Search | https://www.cybertec-postgresql.com/en/gin-and-gist-for-full-text-search/ | Cuándo usar cada uno para búsqueda de texto. Benchmarks incluidos |
| Cybertec — BRIN Indexes in PostgreSQL | https://www.cybertec-postgresql.com/en/brin-index-for-postgresql/ | Análisis detallado de BRIN con ejemplos de series temporales |
| 2ndQuadrant — Understanding EXPLAIN ANALYZE | https://www.2ndquadrant.com/en/blog/explaining-the-postgres-query-planner/ | Guía práctica de cómo leer el plan de ejecución en producción |

## Temas para Profundizar (Semana 12+)

| Tema | URL sugerida |
|------|-------------|
| Índices en tablas particionadas | https://www.postgresql.org/docs/16/ddl-partitioning.html#DDL-PARTITIONING-DECLARATIVE |
| `pg_stat_statements` — identificar consultas lentas | https://www.postgresql.org/docs/16/pgstatstatements.html |
| `auto_explain` — loguear planes automáticamente | https://www.postgresql.org/docs/16/auto-explain.html |
