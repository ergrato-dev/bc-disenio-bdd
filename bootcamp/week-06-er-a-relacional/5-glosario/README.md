# Glosario — Semana 06: Del ER al Modelo Relacional

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

---

## A

**`atributo compuesto`**
Atributo formado por sub-atributos. Se descompone en columnas individuales al transformarlo
en un modelo relacional.
Ejemplo: `address` (compuesto) → `address_street`, `address_city`, `address_country`.

**`atributo derivado`**
Atributo cuyo valor puede calcularse a partir de otros datos del modelo. No se almacena
en la base de datos para evitar redundancia.
Ejemplo: `age` derivado de `birth_date` → se calcula con `EXTRACT(YEAR FROM AGE(birth_date))`.

**`atributo multivaluado`**
Atributo que puede tener varios valores para una misma entidad. Se transforma en una
tabla separada con FK hacia la entidad principal (R6).
Ejemplo: `phone_numbers` de `employees` → tabla `employee_phones(emp_id FK, phone_number)`.

---

## C

**`clave foránea`** (`FOREIGN KEY`)
Columna o conjunto de columnas en una tabla que referencia la clave primaria de otra tabla
(o de la misma tabla en relaciones reflexivas). Garantiza integridad referencial.
Ejemplo: `orders.customer_id REFERENCES customers(customer_id)`.

**`clave primaria`** (`PRIMARY KEY`)
Atributo o conjunto de atributos que identifica de forma única cada fila de una tabla.
No admite valores NULL ni duplicados.
Ejemplo: `user_id UUID DEFAULT gen_random_uuid() PRIMARY KEY`.

**`clave primaria compuesta`**
Clave primaria formada por dos o más columnas. Común en tablas de intersección (R5).
Ejemplo: `PRIMARY KEY (student_id, course_id)` en la tabla `enrollments`.

**`CTI`** (`Class Table Inheritance`)
Estrategia de implementación de jerarquía IS-A en la que existe una tabla para el supertipo
y una tabla adicional por cada subtipo. La PK del subtipo es también FK al supertipo.
Ejemplo: `staff` (supertipo) + `doctors(staff_id PK REFERENCES staff)`.

---

## E

**`entidad asociativa`**
Entidad creada para representar una relación N:M que tiene atributos propios. Al transformarla
se convierte en una tabla de intersección con sus propios atributos.
Ejemplo: `ENROLLMENT(student_id, course_id, enroll_date, grade)`.

**`entidad débil`** (`weak entity`)
Entidad que no puede identificarse por sí sola y depende de otra entidad (su propietaria).
Se transforma con una FK NOT NULL + ON DELETE CASCADE (R2).
Ejemplo: `EXPERIENCE` depende de `USER` → `experiences(experience_id PK, user_id FK NOT NULL)`.

**`entidad fuerte`** (`strong entity`)
Entidad con clave propia que puede identificarse de forma independiente. Se transforma
directamente en una tabla (R1).
Ejemplo: `CUSTOMER`, `PRODUCT`, `ORDER`.

---

## H

**`herencia`** (`inheritance`)
Relación IS-A entre un supertipo y sus subtipos. En el modelo relacional se implementa
con tres estrategias: STI, CTI o Concrete Table (R7).

---

## I

**`integridad referencial`**
Garantía de que toda FK apunta a un registro que existe en la tabla referenciada.
PostgreSQL la verifica automáticamente en INSERT, UPDATE y DELETE.

**`intersección, tabla de`**
Tabla creada para representar una relación N:M. Contiene al menos dos FK hacia las tablas
participantes y su PK puede ser compuesta o un UUID.
Ejemplo: `job_applications(user_id FK, job_posting_id FK, application_date)`.

---

## M

**`modelo físico`**
Representación de la base de datos en términos de objetos del SGBD: tablas, índices,
constraints, tipos de datos, secuencias. Es lo que se implementa con DDL en PostgreSQL.

**`modelo lógico`**
Representación de la estructura de datos en términos relacionales (tablas, columnas, claves)
independiente del SGBD. Es la salida de aplicar las reglas de transformación al modelo ER.

---

## O

**`ON DELETE CASCADE`**
Política de FK que elimina automáticamente las filas hijas cuando se elimina la fila padre.
Adecuada para entidades débiles o datos dependientes.
Ejemplo: `experiences.user_id ON DELETE CASCADE`.

**`ON DELETE RESTRICT`**
Política de FK que impide eliminar la fila padre si existen filas hijas. Protege la
integridad de datos históricos o críticos.
Ejemplo: `orders.customer_id ON DELETE RESTRICT`.

**`ON DELETE SET NULL`**
Política de FK que pone NULL en la columna FK cuando se elimina la fila padre.
Solo aplicable si la columna FK admite NULL.
Ejemplo: `employees.manager_id ON DELETE SET NULL`.

---

## P

**`participación parcial`**
Una entidad participa parcialmente en una relación si no todas sus instancias están
involucradas en esa relación. Se representa con FK nullable (NULL) en el modelo relacional.

**`participación total`**
Una entidad participa totalmente en una relación si todas sus instancias deben estar
involucradas. Se representa con FK NOT NULL en el modelo relacional.

---

## R

**`reglas de transformación`**
Conjunto de 7 reglas (Elmasri/Navathe) que definen cómo convertir un diagrama ER en
un modelo relacional: R1 entidades fuertes, R2 débiles, R3 relaciones 1:1, R4 1:N,
R5 N:M, R6 atributos multivaluados, R7 jerarquías IS-A.

---

## S

**`STI`** (`Single Table Inheritance`)
Estrategia de jerarquía IS-A donde todos los subtipos se almacenan en una sola tabla con
una columna discriminadora. Los atributos exclusivos de cada subtipo pueden ser NULL.
Ejemplo: `vehicles(vehicle_id, vehicle_type, car_doors, truck_tons)`.

**`supertipo`**
Entidad padre en una jerarquía IS-A. Contiene los atributos comunes a todos los subtipos.
En CTI se convierte en la tabla base referenciada por las tablas de subtipos.

---

## T

**`tabla de unión`** (junction table / bridge table)
Ver: *intersección, tabla de*.

**`transformación ER → Relacional`**
Proceso sistemático de convertir un diagrama Entidad-Relación conceptual en un conjunto
de tablas, columnas, claves y restricciones que conforman el modelo relacional físico.

---

*Última actualización: Semana 06 · Modelo Lógico*
