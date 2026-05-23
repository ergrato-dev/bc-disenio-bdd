# Glosario — Semana 01: El mundo relacional

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

| Término | Definición | Ejemplo |
| ------- | ---------- | ------- |
| `ACID` | Conjunto de propiedades que garantizan la fiabilidad de transacciones: Atomicidad, Consistencia, Isolamiento, Durabilidad. | Una transferencia bancaria es ACID: o se debita y acredita completa, o no ocurre nada. |
| `Atributo` | Término formal del modelo relacional para referirse a una columna de una tabla. | La tabla `books` tiene los atributos `title`, `author`, `year`. |
| `Base de datos` | Colección organizada de datos estructurados, gestionada por un SGBD. | Una base de datos de una biblioteca contiene tablas de libros, socios y préstamos. |
| `CHAR(n)` | Tipo de dato de texto de longitud **fija** exactamente `n` caracteres; rellena con espacios si el valor es más corto. | `CHAR(2)` para códigos ISO de país: `'MX'`, `'US'`. |
| `Clave foránea` | Columna (o conjunto) que referencia la clave primaria de otra tabla; garantiza integridad referencial. (`FOREIGN KEY`) | `book_id` en `loans` referencia `id` en `books`. |
| `Clave primaria` | Columna (o conjunto) que identifica de forma única cada fila en una tabla. (`PRIMARY KEY`) | La columna `id` en `books` es clave primaria. |
| `Columna` | Término coloquial para *atributo*. Define el nombre y tipo de dato de una posición en la tabla. | `email VARCHAR(254)` define la columna `email` de tipo texto de hasta 254 caracteres. |
| `DDL` | *Data Definition Language* — sentencias SQL que definen la estructura de la BD: `CREATE`, `ALTER`, `DROP`. | `CREATE TABLE books (...)` es DDL. |
| `DML` | *Data Manipulation Language* — sentencias SQL que operan sobre los datos: `SELECT`, `INSERT`, `UPDATE`, `DELETE`. | `INSERT INTO books VALUES (...)` es DML. |
| `Docker` | Plataforma de contenedores que permite empaquetar aplicaciones con sus dependencias para ejecutarlas de forma aislada y reproducible. | `docker compose up -d` levanta PostgreSQL y pgAdmin en cualquier máquina. |
| `Dominio` | Conjunto de valores válidos para un atributo; en PostgreSQL se implementa con tipos de datos y constraints. | El dominio de `publication_year` podría ser: entero positivo entre 1450 y el año actual. |
| `Esquema` | 1) Estructura de una BD (tablas, columnas, constraints). 2) En PostgreSQL, un namespace que agrupa objetos dentro de una BD. | `CREATE SCHEMA bootcamp` crea un namespace; las tablas dentro se llaman `bootcamp.books`. |
| `FOREIGN KEY` | Ver *clave foránea*. | `CONSTRAINT fk_loans_book_id FOREIGN KEY (book_id) REFERENCES books(book_id)` |
| `Fila` | Término coloquial para *tupla*. Un registro individual en una tabla. | Cada libro en la tabla `books` ocupa una fila. |
| `GENERATED ALWAYS AS IDENTITY` | Sintaxis de PostgreSQL para columnas de secuencia auto-incremental visible al negocio (p.ej. número de factura). Para claves primarias internas se prefiere `UUID DEFAULT gen_random_uuid()`. | `invoice_number BIGINT GENERATED ALWAYS AS IDENTITY` |
| `Instancia` | El conjunto de datos reales almacenados en una BD en un momento dado; lo opuesto al esquema. | El esquema define que `books` tiene `title`; la instancia son los libros concretos guardados. |
| `Integridad referencial` | Propiedad que garantiza que toda clave foránea apunta a una fila existente en la tabla referenciada. | No puede existir un `loan` con `book_id = '...'` si no hay ningún libro con ese `book_id`. |
| `Modelo relacional` | Modelo de datos que organiza la información en tablas con esquema fijo, propuesto por Edgar F. Codd en 1970. | PostgreSQL, MySQL y Oracle implementan el modelo relacional. |
| `NoSQL` | Categoría de SGBD no relacionales diseñados para casos específicos (documentales, columnares, clave-valor, grafos). | MongoDB es un SGBD documental NoSQL. |
| `NOT NULL` | Constraint que impide que una columna contenga el valor especial `NULL`. | `email VARCHAR(254) NOT NULL` garantiza que todo socio tenga email. |
| `NULL` | Valor especial que representa *dato desconocido o ausente*; distinto de cero o cadena vacía. | `return_date = NULL` en un préstamo indica que el libro todavía no fue devuelto. |
| `NUMERIC(p,s)` | Tipo de dato decimal de precisión exacta con `p` dígitos totales y `s` decimales. Nunca usar `FLOAT` para dinero. | `NUMERIC(12, 2)` para precios: hasta `9,999,999,999.99`. |
| `OLAP` | *Online Analytical Processing* — cargas de trabajo analíticas: pocas consultas pesadas sobre grandes volúmenes históricos. | Reportes de ventas anuales por región son OLAP. |
| `OLTP` | *Online Transaction Processing* — cargas de trabajo transaccionales: muchas operaciones pequeñas y frecuentes. | Registrar un pedido en un e-commerce es OLTP. |
| `ON DELETE` | Cláusula de una `FOREIGN KEY` que define qué hacer cuando se elimina la fila referenciada. Opciones: `RESTRICT`, `CASCADE`, `SET NULL`, `SET DEFAULT`. | `ON DELETE RESTRICT` impide borrar un libro que tenga préstamos activos. |
| `pgAdmin` | Herramienta web de administración y consulta para PostgreSQL. | Usamos pgAdmin en `http://localhost:5050` para ejecutar SQL visualmente. |
| `PostgreSQL` | SGBD relacional open-source avanzado, con soporte a SQL completo, extensiones, JSON, arrays y más. | PostgreSQL 16 es el motor principal de este bootcamp. |
| `PRIMARY KEY` | Ver *clave primaria*. | `CONSTRAINT pk_books PRIMARY KEY` |
| `Relación` | Término formal del modelo relacional para referirse a una tabla. | La relación `books` contiene los libros de la biblioteca. |
| `SGBD` | *Sistema Gestor de Bases de Datos* (en inglés: DBMS). Software que gestiona el almacenamiento, consulta y administración de bases de datos. | PostgreSQL, MySQL, MongoDB son SGBD. |
| `SQL` | *Structured Query Language* — lenguaje estándar para interactuar con bases de datos relacionales. | `SELECT * FROM books WHERE year > 2000;` |
| `TIMESTAMPTZ` | Tipo de dato de PostgreSQL para fecha + hora **con** zona horaria. Siempre preferir sobre `TIMESTAMP`. | `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` |
| `Tupla` | Término formal del modelo relacional para referirse a una fila (registro) de una tabla. | Cada fila de `books` es una tupla. |
| `UUID` | *Universally Unique Identifier* — identificador de 128 bits generado de forma distribuida sin coordinación central. | `gen_random_uuid()` genera un UUID en PostgreSQL. |
| `VARCHAR(n)` | Tipo de dato de texto de longitud variable, con máximo `n` caracteres. | `VARCHAR(254)` para emails, `VARCHAR(100)` para nombres. |

---

*Última actualización: Semana 01 · Fundamentos*

