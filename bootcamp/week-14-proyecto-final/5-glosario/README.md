# Glosario Final — Repaso del Bootcamp (Semanas 1–14)

> Consolidación de los términos técnicos más importantes del bootcamp,
> ordenados alfabéticamente. Úsalo como referencia durante el proyecto final
> y como hoja de repaso de todo el programa.

---

## A

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `1FN` (Primera Forma Normal) | Una tabla está en 1FN si todos sus atributos son atómicos (no hay grupos repetitivos ni listas en una columna). | En vez de `phone_numbers TEXT = '555-1234, 555-5678'`, crear tabla `phone_numbers` separada. |
| `2FN` (Segunda Forma Normal) | Una tabla en 1FN está en 2FN si todos sus atributos dependen de la PK **completa** (elimina dependencias parciales en PKs compuestas). | Si la PK es `(order_id, product_id)` y `product_name` solo depende de `product_id`, moverlo a la tabla `products`. |
| `3FN` (Tercera Forma Normal) | Una tabla en 2FN está en 3FN si no hay dependencias transitivas (ningún atributo no-clave determina a otro atributo no-clave). | Si `zip_code → city`, entonces `city` depende transitivamente de la PK a través de `zip_code` → separar en tabla `zip_codes`. |
| `adjacency list` (lista de adyacencia) | Modelo para representar jerarquías en una tabla relacional mediante una columna `parent_id` que apunta a la misma tabla. | `departments(department_id, parent_id FK → department_id)`. Consultable con `WITH RECURSIVE`. |
| `atributo calculado` (derivado) | Atributo cuyo valor se puede derivar de otros datos almacenados. No se almacena en la BD para evitar inconsistencias. | `age` se calcula a partir de `birth_date` y `NOW()`. |
| `atributo multivaluado` | Atributo que puede tener múltiples valores para la misma entidad. Se modela como tabla separada, no como columna. | Un empleado puede tener múltiples teléfonos → tabla `employee_phones(employee_id, phone_number)`. |

## B

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `B-tree` (árbol B) | Estructura de índice por defecto en PostgreSQL. Soporta comparaciones `=`, `<`, `>`, `BETWEEN`, `LIKE 'prefix%'`. | `CREATE INDEX ix_orders_date ON orders(order_date)`. |

## C

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `cardinalidad` | Número de instancias de una entidad que pueden relacionarse con instancias de otra. Puede ser 1:1, 1:N, M:N. | Un cliente puede tener muchos pedidos (1:N). Un pedido contiene muchos productos y viceversa (M:N). |
| `clave candidata` | Atributo o conjunto mínimo de atributos que puede identificar unívocamente cada fila. Una tabla puede tener varias; la elegida como PK se llama clave primaria. | En `users`: tanto `user_id` (UUID) como `user_email` son claves candidatas. |
| `clave compuesta` | Clave primaria formada por dos o más columnas. Común en tablas puente de relaciones M:N. | `enrollment_id = (student_id, course_id)` en una tabla de inscripciones. |
| `clave foránea` (`foreign key`, FK) | Columna o conjunto de columnas que referencian la PK de otra tabla, garantizando integridad referencial. | `orders.customer_id UUID REFERENCES customers(customer_id)`. |
| `clave natural` | Clave primaria formada por un atributo del mundo real que identifica la entidad (ej: número de pasaporte, ISBN). Riesgosa: puede cambiar. | ISBN como PK de libros. Preferible usar `book_id UUID` como PK subrogada. |
| `clave primaria` (`primary key`, PK) | Constraint que identifica unívocamente cada fila. Implica `NOT NULL` + `UNIQUE`. En el bootcamp: siempre `UUID DEFAULT gen_random_uuid()`. | `CONSTRAINT pk_users PRIMARY KEY (user_id)`. |
| `clave subrogada` | Clave primaria artificial generada por el sistema, sin significado de negocio. Estable, no cambia aunque cambien los datos. | `UUID DEFAULT gen_random_uuid()` o `BIGINT GENERATED ALWAYS AS IDENTITY`. |
| `constraint` | Restricción declarativa que define reglas que los datos deben cumplir. PostgreSQL las verifica automáticamente en cada operación DML. | `CHECK (product_price > 0)`, `NOT NULL`, `UNIQUE`, `FOREIGN KEY`. |

## D

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `dependencia funcional` | A → B: el valor de A determina unívocamente el valor de B. Fundamental para la normalización. | `user_id → user_email`: conocer el `user_id` determina el `user_email`. |
| `dependencia parcial` | En una tabla con PK compuesta, ocurre cuando un atributo depende solo de parte de la PK. Viola 2FN. | En `order_items(order_id, product_id, product_name)`, `product_name` depende solo de `product_id`. |
| `dependencia transitiva` | A → B → C (donde A es la PK): C depende de la PK solo a través de B. Viola 3FN. | En `orders(order_id, customer_id, customer_city)`: `customer_city` depende de `customer_id`, no de `order_id`. |
| `desnormalización` | Decisión deliberada de introducir redundancia en el modelo para mejorar el rendimiento de queries frecuentes. Debe estar justificada y documentada. | Agregar `customer_name` en `orders` para evitar un JOIN, cuando el nombre del cliente nunca cambia. |
| `diseño conceptual` | Primera etapa del diseño: representar el dominio del negocio como diagrama ER con entidades, atributos y relaciones. Sin pensar aún en tablas o SQL. | Diagrama ER con draw.io en notación Crow's Foot o Chen. |
| `diseño físico` | Tercera etapa: implementar el modelo lógico en un SGBD específico usando DDL. Incluye tipos de datos, constraints, índices y objetos avanzados. | `CREATE TABLE` con PostgreSQL 16, índices, triggers, vistas. |
| `diseño lógico` | Segunda etapa: transformar el modelo ER en tablas relacionales y normalizarlas. Independiente del SGBD. | Modelo DBML en dbdiagram.io con todas las FKs y normalización hasta 3FN. |

## E

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `entidad débil` | Entidad que no puede existir sin la entidad propietaria y no tiene PK propia independiente. Su identificador incluye la FK a la entidad fuerte. | `order_items` no existe sin `orders`. Su PK podría ser `(order_id, product_id)`. |
| `entidad fuerte` | Entidad con existencia independiente e identificador propio. | `customers`, `products`, `doctors` son entidades fuertes. |
| `especialización` | Proceso de definir subtipos de una entidad general (supertipo). Los subtipos heredan atributos del supertipo y agregan los propios. | `employees` como supertipo → `managers` y `technicians` como subtipos. |

## F

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `FNBC` (Forma Normal de Boyce-Codd) | Versión más estricta de 3FN: todo determinante debe ser una clave candidata. | Si `instructor → classroom` pero `instructor` no es clave candidata, hay violación de FNBC. |
| `función` (PostgreSQL) | Objeto de BD que encapsula lógica SQL o plpgsql y devuelve un valor o tabla. Se invoca con `SELECT fn_name(args)`. | `CREATE FUNCTION fn_get_total(order_uuid UUID) RETURNS NUMERIC`. |

## G

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `generalización` | Proceso inverso a la especialización: unir entidades con atributos comunes en un supertipo. | Unir `cars` y `trucks` en el supertipo `vehicles`. |
| `GIN` (Generalized Inverted Index) | Tipo de índice PostgreSQL para búsqueda en tipos compuestos: `JSONB`, `ARRAY`, texto completo. | `CREATE INDEX ix_products_tags ON products USING GIN(product_tags)`. |

## I

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `índice B-tree` | Ver `B-tree`. |  |
| `índice compuesto` | Índice sobre dos o más columnas. Útil cuando los WHERE siempre filtran por las mismas N columnas juntas. | `CREATE INDEX ix_orders_customer_status ON orders(customer_id, order_status)`. |
| `índice parcial` | Índice que solo cubre un subconjunto de filas (con cláusula `WHERE`). Más pequeño y eficiente que el índice completo. | `CREATE INDEX ix_orders_pending ON orders(created_at) WHERE order_status = 'pending'`. |
| `integridad referencial` | Garantía de que todas las FKs apuntan a filas que existen en la tabla referenciada. Mantenida por el SGBD con constraints FK. | PostgreSQL impide insertar un `order` con `customer_id` que no existe en `customers`. |

## M

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `modelo conceptual` | Ver `diseño conceptual`. |  |
| `modelo entidad-relación` | Representación gráfica del dominio del negocio usando entidades, atributos y relaciones. Herramienta del diseño conceptual. | Diagrama ER de un sistema de biblioteca con Libro, Autor, Categoría. |
| `modelo relacional` | Modelo de datos que organiza la información en tablas (relaciones) con filas (tuplas) y columnas (atributos). Base matemática de SQL. | Tablas `users`, `orders`, `products` con PKs y FKs entre ellas. |
| `multi-tenancy` | Arquitectura donde múltiples clientes (tenants) comparten la misma instancia de BD, con datos estrictamente separados. | SaaS con `tenant_id UUID NOT NULL` en todas las tablas + RLS. |

## N

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `normalización` | Proceso de organizar las tablas de una BD para reducir redundancia y dependencias no deseadas, mediante la aplicación de formas normales. | Pasar de una tabla `orders` con datos del cliente embebidos a tablas separadas `orders` y `customers`. |
| `NULL` | Valor especial que representa la ausencia de dato. No es cero ni cadena vacía. Las operaciones aritméticas con NULL producen NULL. | `SELECT 1 + NULL` → `NULL`. Columnas opcionales usan `NULL`; las obligatorias usan `NOT NULL`. |

## P

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `procedimiento` (stored procedure) | Bloque de lógica SQL/plpgsql que se ejecuta con `CALL`. A diferencia de las funciones, no retorna un valor directamente; puede tener lógica transaccional. | `CREATE PROCEDURE sp_create_order(customer_uuid UUID, items JSONB)`. |

## R

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `relación ternaria` | Relación en el modelo ER que involucra exactamente tres entidades simultáneamente. No puede descomponerse en dos relaciones binarias sin perder información. | `ASSIGNMENT(doctor_id, patient_id, slot_id)` — un médico atiende a un paciente en un turno específico. |
| `relación reflexiva` | Relación de una entidad consigo misma (auto-referencia). Modela jerarquías, supervisión y parentesco. | `employees(employee_id, supervisor_id FK → employees)`. |
| `RLS` (Row Level Security) | Mecanismo de PostgreSQL que permite definir políticas de acceso a nivel de fila. Cada usuario/rol solo ve las filas que la política le permite. | `ENABLE ROW LEVEL SECURITY ON orders; CREATE POLICY ... USING (tenant_id = current_setting('app.tenant_id')::UUID)`. |

## S

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `SGBD` (Sistema Gestor de Bases de Datos) | Software que gestiona el almacenamiento, la recuperación y la modificación de datos. Garantiza ACID. | PostgreSQL, MySQL, Oracle, SQL Server, SQLite. |
| `soft delete` | Patrón donde los registros "eliminados" no se borran físicamente sino que se marcan con una fecha en la columna `deleted_at`. | `UPDATE orders SET deleted_at = NOW() WHERE order_id = $1`. Vista `vw_active_orders` filtra `WHERE deleted_at IS NULL`. |
| `supertipo / subtipo` | Ver `especialización` y `generalización`. |  |

## T

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `tabla puente` (junction table) | Tabla que materializa una relación M:N entre dos entidades. Contiene las FKs de ambas entidades y puede tener atributos propios. | `order_items(order_id FK, product_id FK, quantity, unit_price)`. |
| `trigger` | Procedimiento que PostgreSQL ejecuta automáticamente en respuesta a un evento DML (`INSERT`, `UPDATE`, `DELETE`) sobre una tabla. | `CREATE TRIGGER trg_orders_updated_at BEFORE UPDATE ON orders ... EXECUTE FUNCTION fn_set_updated_at()`. |
| `TIMESTAMPTZ` | Tipo de dato PostgreSQL para fecha y hora con zona horaria. Almacena en UTC internamente y convierte según la zona del cliente. Siempre preferir sobre `TIMESTAMP`. | `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()`. |

## U

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `UUID` (Universally Unique Identifier) | Identificador de 128 bits globalmente único. En PostgreSQL: `gen_random_uuid()` genera UUID v4. PK recomendada en el bootcamp. | `product_id UUID NOT NULL DEFAULT gen_random_uuid()`. |

## V

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `vista` (view) | Consulta SQL almacenada con nombre. Actúa como tabla virtual; no almacena datos por sí misma. | `CREATE VIEW vw_active_products AS SELECT ... WHERE deleted_at IS NULL`. |
| `vista materializada` | Vista cuyo resultado se almacena físicamente. Se refresca manualmente o con `REFRESH MATERIALIZED VIEW`. Útil para queries analíticas costosas. | `CREATE MATERIALIZED VIEW mv_monthly_sales AS SELECT ...`. |

## W

| Término | Definición | Ejemplo |
|---------|------------|---------|
| `WITH RECURSIVE` | Extensión de las CTEs de SQL que permite consultas iterativas sobre estructuras jerárquicas o grafos. PostgreSQL lo soporta nativamente. | `WITH RECURSIVE tree AS (SELECT ... WHERE parent_id IS NULL UNION ALL SELECT ... JOIN tree ...)`. |

---

*Última actualización: Semana 14 · Proyecto Final Integrador · Bootcamp Diseño de BDD Zero to Hero*

← [Recursos Web](../4-recursos/webgrafia/README.md) | → [README de la Semana](../README.md)
