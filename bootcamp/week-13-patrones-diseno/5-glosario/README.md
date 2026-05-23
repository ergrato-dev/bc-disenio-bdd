# Glosario — Semana 13: Patrones de diseño avanzados

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

| Término | Definición | Ejemplo |
| ------- | ---------- | ------- |
| `adjacency list` | Modelo de árbol donde cada nodo almacena la referencia a su padre directo mediante `parent_id`. | `categories(parent_id UUID REFERENCES categories)` |
| `audit trail` (traza de auditoría) | Registro secuencial e inmutable de quién hizo qué cambio, en qué entidad y cuándo. | Tabla `orders_history` con columna `history_operation` |
| `auditoría de datos` | Registro sistemático de cambios sobre los datos para trazabilidad, cumplimiento normativo y depuración. | Trigger `AFTER INSERT OR UPDATE OR DELETE` que escribe en `_history` |
| `closure table` | Tabla auxiliar que almacena todos los pares ancestro-descendiente de un árbol, incluyendo relaciones no directas. | `category_paths(ancestor_id, descendant_id, path_depth)` |
| `CTE recursiva` | Expresión de tabla común (`WITH RECURSIVE`) que se referencia a sí misma para navegar jerarquías en árbol o grafos. | `WITH RECURSIVE tree AS (SELECT ... UNION ALL SELECT ...)` |
| `current_setting()` | Función de PostgreSQL que lee una variable de sesión configurada con `SET LOCAL`. Permite pasar contexto (user_id, tenant_id) a triggers. | `current_setting('app.current_user_id', true)::UUID` |
| `deleted_at` | Columna `TIMESTAMPTZ` que almacena el momento de eliminación lógica de una fila. `NULL` indica que el registro está activo. | `WHERE deleted_at IS NULL` en una vista activa |
| `eliminación física` (`hard delete`) | Operación `DELETE FROM tabla WHERE ...` que borra permanentemente el registro. No hay forma de recuperarlo sin backup. | `DELETE FROM products WHERE product_id = '...'` |
| `eliminación lógica` (`soft delete`) | Patrón que en lugar de borrar una fila, la marca como inactiva actualizando `deleted_at = NOW()`. | `UPDATE products SET deleted_at = NOW() WHERE product_id = '...'` |
| `historial de cambios` (`history table`) | Tabla adicional que almacena una copia completa de cada versión anterior de una fila, con metadata de la operación. | `products_history(history_operation, history_changed_at, ...)` |
| `índice parcial` (`partial index`) | Índice que solo incluye las filas que satisfacen una condición `WHERE`. Reduce el tamaño del índice y permite UNIQUE selectivo. | `CREATE UNIQUE INDEX ON customers(email) WHERE deleted_at IS NULL` |
| `multi-tenancy` | Arquitectura donde múltiples clientes (`tenants`) comparten la misma instalación de BD, aislados entre sí por datos o por esquemas. | Columna `tenant_id` + Row Level Security |
| `nested sets` | Modelo de árbol que asigna a cada nodo dos valores enteros (`lft`, `rgt`) que representan rangos anidados. Permite consultar subárboles sin recursión. | `WHERE lft BETWEEN parent.lft AND parent.rgt` |
| `nodo hoja` (`leaf node`) | Nodo de un árbol que no tiene hijos. En adjacency list: no existe ningún registro con ese nodo como `parent_id`. | `WHERE category_id NOT IN (SELECT parent_id FROM categories WHERE parent_id IS NOT NULL)` |
| `nodo raíz` (`root node`) | Nodo sin padre en una estructura árbol. En adjacency list se identifica por `parent_id IS NULL`. | `WHERE parent_id IS NULL` |
| `path enumeration` | Modelo de árbol que almacena la ruta completa de un nodo como texto (ej. `'1/3/7/'`). Simplifica las consultas de ancestros con `LIKE`. | `WHERE path LIKE '1/3/%'` devuelve todos los descendientes |
| `point-in-time query` | Consulta que recupera el estado de los datos tal como estaban en un momento pasado específico, consultando la tabla de historial. | `SELECT * FROM orders_history WHERE changed_at <= '2026-02-01' ORDER BY changed_at DESC LIMIT 1` |
| `política de fila` (`row policy`) | Regla de PostgreSQL creada con `CREATE POLICY` que filtra automáticamente las filas visibles según el contexto de sesión. | `CREATE POLICY p ON articles USING (tenant_id = current_setting('app.tenant_id')::UUID)` |
| `Row Level Security` (RLS) | Mecanismo de PostgreSQL que aplica políticas de visibilidad a nivel de fila. Requiere `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`. | `ALTER TABLE products ENABLE ROW LEVEL SECURITY` |
| `schema-per-tenant` | Estrategia de multi-tenancy que asigna un esquema PostgreSQL separado a cada tenant, logrando aislamiento total de datos y DDL. | `CREATE SCHEMA tenant_acme; SET search_path = tenant_acme;` |
| `tenant` | Cliente o inquilino en una arquitectura multi-tenant. Cada tenant tiene su conjunto propio de datos aislado del resto. | La empresa "TechBlog S.A." es un tenant de ContentHub |

---

← [README de la Semana](../README.md) | → [Semana 14 — Proyecto Final](../../week-14-proyecto-final/README.md)

*Última actualización: Semana 13 · Diseño Avanzado*
