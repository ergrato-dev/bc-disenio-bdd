# Glosario — Semana 09: Integridad y Restricciones

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

---

## A

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **Acción referencial** (`referential action`) | Comportamiento definido en una FK que determina qué pasa con las filas hijo cuando se borra o actualiza la fila padre. | `ON DELETE CASCADE`, `ON DELETE SET NULL` |

---

## C

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **CASCADE** | Política ON DELETE que borra automáticamente las filas hijo cuando se borra la fila padre. | `FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE` |
| **CHECK** | Tipo de constraint que valida una expresión booleana en cada fila de la tabla. No puede hacer subconsultas. | `CONSTRAINT ck_price CHECK (price > 0)` |
| **Clave candidata** (`candidate key`) | Conjunto mínimo de columnas que identifica unívocamente cada fila. Una tabla puede tener varias. La PK es la clave candidata elegida. | `user_id` y `user_email` pueden ser ambas claves candidatas en `users` |
| **Clave foránea** (`foreign key`) | Columna o grupo de columnas que referencia la PK de otra tabla (o de la misma), garantizando integridad referencial. | `CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id)` |
| **Clave natural** (`natural key`) | PK derivada de un atributo del mundo real que es único por naturaleza (ISBN, número de licencia, email). | `product_isbn VARCHAR(13)` como PK de libros |
| **Clave primaria** (`primary key`) | Constraint que combina NOT NULL + UNIQUE para identificar unívocamente cada fila. Solo puede haber una por tabla. | `CONSTRAINT pk_users PRIMARY KEY (user_id)` |
| **Clave surrogada** (`surrogate key`) | PK artificial generada por el sistema, sin significado de negocio. Ejemplos: UUID, IDENTITY. | `user_id UUID DEFAULT gen_random_uuid()` |
| **Constraint** | Restricción declarativa que PostgreSQL verifica automáticamente en cada operación de escritura. | PK, UNIQUE, NOT NULL, FK, CHECK, EXCLUDE |

---

## D

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **Constraint diferible** (`deferrable constraint`) | Constraint cuya verificación puede posponerse hasta el final de la transacción. Útil para insertar datos con referencias circulares. | `CONSTRAINT fk_x FOREIGN KEY (...) DEFERRABLE INITIALLY DEFERRED` |

---

## I

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **Integridad de dominio** (`domain integrity`) | Garantía de que los valores de una columna pertenecen al conjunto de valores válidos para ese atributo. | `CHECK (status IN ('pending','confirmed'))` |
| **Integridad de entidad** (`entity integrity`) | Garantía de que cada fila de una tabla tiene un identificador único y no nulo. La PK implementa esta propiedad. | `PRIMARY KEY (user_id)` |
| **Integridad referencial** (`referential integrity`) | Garantía de que toda FK apunta a una fila existente en la tabla padre. La FK implementa esta propiedad. | `FOREIGN KEY (customer_id) REFERENCES customers(customer_id)` |

---

## N

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **NO ACTION** | Política ON DELETE por defecto. Similar a RESTRICT, pero la verificación es diferida hasta el final de la transacción (no inmediata). | `ON DELETE NO ACTION` (comportamiento por defecto) |
| **NOT NULL** | Constraint que impide insertar o actualizar una columna con valor NULL. PostgreSQL acepta NULL por defecto en toda columna. | `customer_name VARCHAR(100) NOT NULL` |
| **NULL semántico** | Uso de NULL con un significado específico de negocio (ej: `deleted_at NULL` = "activo", `parent_id NULL` = "nodo raíz"). | `deleted_at TIMESTAMPTZ  -- NULL = no borrado` |

---

## O

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **ON DELETE CASCADE** | Acción referencial que borra las filas hijo automáticamente cuando se borra el padre. | `ON DELETE CASCADE` |
| **ON DELETE RESTRICT** | Acción referencial que impide borrar el padre si tiene filas hijo. La verificación es inmediata. | `ON DELETE RESTRICT` |
| **ON DELETE SET NULL** | Acción referencial que pone la columna FK del hijo en NULL cuando se borra el padre. La columna FK debe ser nullable. | `ON DELETE SET NULL` |
| **ON DELETE SET DEFAULT** | Acción referencial que asigna el valor DEFAULT de la columna FK cuando se borra el padre. | `ON DELETE SET DEFAULT` |

---

## P

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **PK compuesta** (`composite primary key`) | PK formada por dos o más columnas. Útil en tablas de unión m:n sin datos propios. | `PRIMARY KEY (student_id, course_id)` |
| **Política de cascada** (`cascade policy`) | Ver "Acción referencial". El conjunto de reglas ON DELETE / ON UPDATE de una FK. | — |

---

## R

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **RESTRICT** | Política ON DELETE que genera un error inmediato si se intenta borrar un padre con hijos. | `ON DELETE RESTRICT` |
| **Restricción de tabla** (`table-level constraint`) | CHECK declarado fuera de una columna específica, que puede referenciar múltiples columnas de la misma fila. | `CONSTRAINT ck_dates CHECK (end_date > start_date)` |

---

## S

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **SET NULL** | Acción referencial que pone la FK del hijo en NULL cuando se borra el padre. | `ON DELETE SET NULL` |

---

## U

| Término | Definición | Ejemplo SQL |
|---------|------------|-------------|
| **UNIQUE** | Constraint que garantiza que no existan dos filas con el mismo valor en la columna o grupo de columnas. Permite múltiples NULLs. | `CONSTRAINT uq_users_email UNIQUE (user_email)` |

---

*Última actualización: Semana 09 · Modelo Lógico*
