# Glosario — Semana 12: Objetos avanzados y transacciones

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

| Término | Definición | Ejemplo |
| ------- | ---------- | ------- |
| **ACID** | Conjunto de cuatro propiedades que garantizan la fiabilidad de las transacciones en una base de datos relacional: Atomicidad, Consistencia, Aislamiento y Durabilidad. | `BEGIN; UPDATE ...; INSERT ...; COMMIT;` |
| **`AFTER` trigger** | Trigger que se ejecuta después de que la operación DML ya modificó la tabla. Los cambios son visibles para el trigger. No puede cancelar la operación. | `CREATE TRIGGER ... AFTER INSERT ON orders FOR EACH ROW ...` |
| **Atomicidad** | Propiedad ACID que garantiza que todas las operaciones de una transacción se aplican o ninguna se aplica. | Si falla un `INSERT` dentro de un `BEGIN`, el `ROLLBACK` deshace todo lo anterior. |
| **`BEFORE` trigger** | Trigger que se ejecuta antes de la operación DML. Puede modificar `NEW` o retornar `NULL` para cancelar la operación. | Normalizar email a minúsculas antes de insertar. |
| **`BEGIN`** | Inicia una transacción explícita en PostgreSQL. Todas las operaciones siguientes son atómicas hasta `COMMIT` o `ROLLBACK`. | `BEGIN; UPDATE ...; COMMIT;` |
| **`CALL`** | Sentencia para invocar un procedimiento almacenado creado con `CREATE PROCEDURE`. | `CALL sp_cancel_order('...uuid...', 'Motivo');` |
| **`COMMIT`** | Confirma y persiste todos los cambios realizados desde el `BEGIN` de la transacción. Los cambios quedan visibles para otras sesiones. | `BEGIN; INSERT ...; COMMIT;` |
| **Consistencia** | Propiedad ACID que garantiza que la BD siempre pasa de un estado válido a otro estado válido, respetando constraints y reglas de integridad. | Un `CHECK (product_price >= 0)` impide que una transacción deje precios negativos. |
| **`CREATE MATERIALIZED VIEW`** | Crea una vista que almacena físicamente en disco el resultado de la consulta. Requiere `REFRESH` para actualizar los datos. | `CREATE MATERIALIZED VIEW mvw_monthly_sales AS SELECT ... WITH DATA;` |
| **`CREATE OR REPLACE FUNCTION`** | Crea una nueva función o reemplaza una existente con el mismo nombre y firma sin necesidad de hacer `DROP` previo. | `CREATE OR REPLACE FUNCTION fn_total(p_id UUID) RETURNS NUMERIC ...` |
| **`CREATE OR REPLACE PROCEDURE`** | Crea o reemplaza un procedimiento almacenado (disponible desde PostgreSQL 11). Los procedimientos pueden hacer `COMMIT`/`ROLLBACK` internos. | `CREATE OR REPLACE PROCEDURE sp_close_order(p_id UUID) ...` |
| **`DECLARE`** | Bloque de declaración de variables locales dentro de una función PL/pgSQL. Se ubica entre la firma y el `BEGIN`. | `DECLARE v_total NUMERIC := 0;` |
| **Durabilidad** | Propiedad ACID que garantiza que los cambios confirmados (`COMMIT`) sobreviven a fallos del sistema, reinicios o cortes de energía, gracias al WAL. | Los datos escritos en disco tras un `COMMIT` persisten incluso si el servidor cae. |
| **`FOR EACH ROW`** | Nivel de disparo de un trigger: la función trigger se ejecuta una vez por cada fila afectada por la operación DML. | `CREATE TRIGGER ... FOR EACH ROW EXECUTE FUNCTION ...` |
| **`FOR EACH STATEMENT`** | Nivel de disparo de un trigger: la función se ejecuta una vez por sentencia DML, sin importar cuántas filas afecte. `NEW` y `OLD` no están disponibles. | Útil para loguear que se ejecutó un `DELETE` masivo. |
| **`INSTEAD OF` trigger** | Trigger que solo se puede definir sobre vistas. Reemplaza completamente la operación DML (INSERT/UPDATE/DELETE) sobre la vista, permitiendo hacerla actualizable manualmente. | Permite `INSERT` en una vista de solo lectura. |
| **Nivel de aislamiento** (`isolation level`) | Grado al que una transacción en curso es visible para otras transacciones concurrentes. Por defecto PostgreSQL usa `READ COMMITTED`. | `BEGIN ISOLATION LEVEL REPEATABLE READ;` |
| **`NEW`** | Registro especial disponible en funciones trigger que contiene los valores de la fila después de la operación (`INSERT` o `UPDATE`). No disponible en `DELETE`. | `NEW.customer_email := lower(NEW.customer_email);` |
| **`OLD`** | Registro especial disponible en funciones trigger que contiene los valores de la fila antes de la operación (`UPDATE` o `DELETE`). No disponible en `INSERT`. | `row_to_json(OLD)` para guardar el estado anterior en auditoría. |
| **PL/pgSQL** | Lenguaje procedural nativo de PostgreSQL para escribir funciones, procedimientos y triggers con control de flujo, variables y manejo de excepciones. | `CREATE FUNCTION fn_x() RETURNS TEXT LANGUAGE plpgsql AS $$ BEGIN ... END; $$;` |
| **Procedimiento almacenado** | Objeto de BD creado con `CREATE PROCEDURE`. A diferencia de una función, no retorna un valor pero puede hacer `COMMIT`/`ROLLBACK` internos. Se invoca con `CALL`. | `CALL sp_complete_order('...uuid...');` |
| **`RAISE EXCEPTION`** | Sentencia PL/pgSQL que lanza un error y aborta la ejecución de la función, propagando el error a la transacción que la llamó. | `RAISE EXCEPTION 'Precio negativo: %', NEW.price;` |
| **`RAISE NOTICE`** | Sentencia PL/pgSQL que emite un mensaje informativo sin interrumpir la ejecución. Útil para debugging. | `RAISE NOTICE 'Procesando orden %', p_order_id;` |
| **`REFRESH MATERIALIZED VIEW`** | Actualiza el contenido de una vista materializada ejecutando de nuevo su consulta base. Con `CONCURRENTLY` no bloquea lecturas (requiere `UNIQUE` index). | `REFRESH MATERIALIZED VIEW CONCURRENTLY mvw_monthly_sales;` |
| **`RETURNS TABLE`** | Declaración en `CREATE FUNCTION` que permite a la función retornar múltiples filas con columnas nombradas. Se usa con `RETURN QUERY`. | `RETURNS TABLE (order_id UUID, order_total NUMERIC)` |
| **`RETURNS TRIGGER`** | Tipo de retorno obligatorio para funciones PL/pgSQL que serán usadas como triggers. La función debe retornar `NEW`, `OLD` o `NULL`. | `CREATE FUNCTION fn_audit() RETURNS TRIGGER LANGUAGE plpgsql ...` |
| **`ROLLBACK`** | Deshace todos los cambios realizados desde el `BEGIN` de la transacción (o desde el último `SAVEPOINT` si se usa `ROLLBACK TO SAVEPOINT`). | `BEGIN; UPDATE ...; ROLLBACK;` — ningún cambio persiste. |
| **`SAVEPOINT`** | Punto de guardado interno dentro de una transacción activa que permite hacer rollback parcial sin deshacer toda la transacción. | `SAVEPOINT sp1; UPDATE ...; ROLLBACK TO SAVEPOINT sp1;` |
| **`TG_OP`** | Variable especial disponible en funciones trigger que contiene la operación que disparó el trigger: `'INSERT'`, `'UPDATE'` o `'DELETE'`. | `IF TG_OP = 'DELETE' THEN ... END IF;` |
| **`TG_TABLE_NAME`** | Variable especial en triggers que contiene el nombre de la tabla sobre la que se disparó el trigger. Permite crear funciones trigger reutilizables. | `INSERT INTO audit_log (audit_table, ...) VALUES (TG_TABLE_NAME, ...);` |
| **Vista** (`VIEW`) | Consulta guardada como objeto de base de datos. No almacena datos propios: cada `SELECT` sobre la vista re-ejecuta la consulta base. Siempre refleja el estado actual de las tablas subyacentes. | `CREATE OR REPLACE VIEW vw_orders AS SELECT ...;` |
| **Vista actualizable** (`updatable view`) | Vista sobre la que PostgreSQL permite ejecutar `INSERT`, `UPDATE` y `DELETE`. Requiere que apunte a una sola tabla sin `DISTINCT`, `GROUP BY`, funciones de agregación ni subconsultas. | `UPDATE vw_active_products SET product_price = 99 WHERE ...;` |
| **Vista materializada** (`materialized view`) | Vista que almacena físicamente el resultado de su consulta en disco. Las lecturas son rápidas pero los datos pueden estar desactualizados hasta el próximo `REFRESH`. | `CREATE MATERIALIZED VIEW mvw_sales AS SELECT ... WITH DATA;` |
| **WAL** (`Write-Ahead Log`) | Mecanismo de PostgreSQL que garantiza la durabilidad (propiedad D de ACID): todos los cambios se escriben primero en el log antes de aplicarse en los archivos de datos. | Permite recuperar la BD a un estado consistente tras un crash. |

---

*Última actualización: Semana 12 · Modelo Físico*
