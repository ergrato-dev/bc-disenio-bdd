# Glosario — Semana 11: Índices y Optimización

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

| Término | Definición | Ejemplo |
|---------|-----------|---------|
| `ANALYZE` | Comando que recorre la tabla y actualiza las estadísticas usadas por el planificador de consultas. Sin estadísticas actualizadas, el planificador puede tomar decisiones erróneas. | `ANALYZE tasks;` |
| `Bitmap Heap Scan` | Nodo del plan de ejecución que accede al heap en lotes de páginas completas tras construir un bitmap. Más eficiente que `Index Scan` cuando hay muchas filas candidatas. | Aparece en `EXPLAIN` cuando hay ~100–10 000 filas a recuperar |
| `Bitmap Index Scan` | Primera fase del acceso por bitmap: recorre el índice y construye un mapa de bits de las páginas del heap que contienen filas relevantes. | Nodo hijo de `Bitmap Heap Scan` |
| `B-tree` | Tipo de índice por defecto en PostgreSQL. Árbol balanceado con hojas enlazadas que soporta igualdad, rangos y ordenamiento. Búsqueda en O(log n). | `CREATE INDEX ix_orders_customer_id ON orders (customer_id);` |
| `BRIN` (_Block Range Index_) | Índice que almacena los valores mínimo y máximo de una columna por cada rango de bloques físicos. Muy pequeño pero solo efectivo si los datos están físicamente ordenados. | `CREATE INDEX ix_logs_created USING BRIN ON logs (created_at);` |
| Costo (`cost`) | Unidad de estimación interna del planificador (no milisegundos). Se usa para comparar alternativas. El formato es `cost=arranque..total`. | `cost=0.00..4821.00` |
| _Covering index_ | Índice que contiene todas las columnas necesarias para satisfacer una consulta sin acceder al heap. Se crea con la cláusula `INCLUDE`. | `CREATE INDEX ix_orders_covering ON orders (customer_id) INCLUDE (order_status, order_total);` |
| `CREATE INDEX CONCURRENTLY` | Variante de `CREATE INDEX` que construye el índice sin bloquear lecturas ni escrituras en la tabla. Tarda más pero es segura en producción. | `CREATE INDEX CONCURRENTLY ix_tasks_status ON tasks (task_status);` |
| `ctid` | Puntero interno de PostgreSQL que identifica la ubicación física de una fila: `(número_de_bloque, número_de_fila_en_bloque)`. Los índices almacenan pares `clave → ctid`. | `SELECT ctid, * FROM tasks LIMIT 5;` |
| `EXPLAIN` | Comando que muestra el plan de ejecución estimado de una consulta **sin ejecutarla**. Seguro en producción para consultas de solo lectura. | `EXPLAIN SELECT * FROM tasks WHERE project_id = '...';` |
| `EXPLAIN ANALYZE` | Variante de `EXPLAIN` que **ejecuta** la consulta y muestra tiempos reales junto a las estimaciones. Imprescindible para detectar discrepancias entre costo estimado y tiempo real. | `EXPLAIN (ANALYZE, BUFFERS) SELECT ...;` |
| `GIN` (_Generalized Inverted Index_) | Índice invertido para tipos de datos compuestos como `JSONB`, arrays y `tsvector`. Soporta operadores `@>`, `?`, `&&`, `@@`. | `CREATE INDEX ix_meta_gin ON products USING GIN (product_metadata);` |
| `GiST` (_Generalized Search Tree_) | Familia de índices extensible para predicados complejos como rangos de fechas, geometría y restricciones de no solapamiento. | `CONSTRAINT no_overlap EXCLUDE USING GIST (resource_id WITH =, period WITH &&)` |
| `Hash` | Tipo de índice que calcula un valor hash de cada entrada. Solo soporta igualdad (`=`) pero puede superar a B-tree en ese caso. WAL-safe desde PostgreSQL 10. | `CREATE INDEX ix_tokens USING HASH ON sessions (session_token);` |
| `Index Only Scan` | Nodo del plan que satisface la consulta completamente desde el índice, sin acceder al heap. Requiere un _covering index_ y un mapa de visibilidad actualizado. | `Heap Fetches: 0` en `EXPLAIN` |
| `Index Scan` | Nodo del plan que usa el índice para obtener los `ctid` y luego accede al heap por cada fila. Eficiente con alta selectividad. | Aparece como `Index Scan using ix_tasks_pk on tasks` |
| Índice compuesto (_composite index_) | Índice creado sobre dos o más columnas. El planificador puede usarlo si la consulta incluye el prefijo izquierdo de las columnas del índice (regla del prefijo izquierdo). | `CREATE INDEX ix_tasks_proj_status ON tasks (project_id, task_status);` |
| Índice de expresión | Índice creado sobre el resultado de una función o expresión. El planificador lo usa cuando la misma expresión aparece en la cláusula `WHERE`. | `CREATE INDEX ix_users_lower_email ON users (lower(user_email));` |
| Índice parcial (_partial index_) | Índice que solo indexa un subconjunto de filas definido por una cláusula `WHERE`. Más pequeño y rápido para consultas que filtran el mismo subconjunto. | `CREATE INDEX ix_tasks_active ON tasks (due_date) WHERE task_status NOT IN ('done','cancelled');` |
| `Nested Loop` | Estrategia de JOIN donde por cada fila del conjunto externo se busca en el conjunto interno. Eficiente cuando el interno es pequeño o tiene un índice eficiente. | Aparece en `EXPLAIN` para joins con baja cardinalidad |
| `pg_stat_user_indexes` | Vista del sistema que muestra estadísticas de uso de índices: cuántas veces se usó (`idx_scan`), cuántas filas se leyeron y el tamaño. Útil para detectar índices no usados. | `SELECT indexrelname, idx_scan FROM pg_stat_user_indexes WHERE relname = 'tasks';` |
| Planificador (_query planner_) | Componente de PostgreSQL que analiza las estadísticas y genera el plan de ejecución más eficiente para cada consulta. Puede ser guiado pero no forzado en producción. | El planificador elige entre `Seq Scan`, `Index Scan`, `Bitmap Heap Scan`, etc. |
| Selectividad (_selectivity_) | Fracción de filas de la tabla que una condición devuelve. Alta selectividad = pocos resultados = índice efectivo. Baja selectividad = muchos resultados = el planificador prefiere `Seq Scan`. | `WHERE task_status = 'backlog'` en 50 000 filas: selectividad ~1/6 ≈ 17% → baja |
| `Seq Scan` | Escaneo secuencial de todas las páginas de una tabla: O(n) en páginas. Normal en tablas pequeñas o cuando la consulta retorna una fracción grande de las filas. | `Seq Scan on orders (cost=0.00..4821.00 rows=98000...)` |
| `work_mem` | Parámetro de PostgreSQL que controla la memoria por operación de ordenamiento y tabla hash. Si es insuficiente, el Sort usa `external merge` (disco), lo que aparece en `EXPLAIN ANALYZE`. | `SET work_mem = '64MB';` — solo para la sesión actual |

---

*Última actualización: Semana 11 · Modelo Físico*
