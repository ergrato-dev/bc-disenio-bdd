# Webografía — Semana 07: Normalización I

Referencias web sobre dependencias funcionales, 1FN y 2FN.

---

## Documentación Oficial

### PostgreSQL — Data Types

- **URL:** <https://www.postgresql.org/docs/16/datatype.html>
- **Por qué:** Referencia completa de tipos de datos de PostgreSQL. Importante para
  elegir el tipo correcto al normalizar (`SMALLINT` vs `INTEGER`, `VARCHAR` vs `TEXT`).

### PostgreSQL — Constraints

- **URL:** <https://www.postgresql.org/docs/16/ddl-constraints.html>
- **Por qué:** Documentación oficial de `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`,
  `CHECK` y `NOT NULL`. Esencial para implementar correctamente el modelo 2FN.

---

## Teoría y Conceptos

### Database Normalization — Wikipedia

- **URL:** <https://en.wikipedia.org/wiki/Database_normalization>
- **Por qué:** Artículo completo con historia, definiciones formales y ejemplos
  de cada forma normal. Incluye referencias a los papers originales de Codd.

### Functional Dependency — Wikipedia

- **URL:** <https://en.wikipedia.org/wiki/Functional_dependency>
- **Por qué:** Definición formal de dependencias funcionales, axiomas de Armstrong,
  cierre de atributos y tipos (trivial, completa, parcial, transitiva).

### First Normal Form — Database.Guide

- **URL:** <https://database.guide/1nf-first-normal-form-explained/>
- **Por qué:** Explicación práctica de 1FN con ejemplos visuales de antes y después.
  Cubre los 3 criterios con tablas de ejemplo.

### Second Normal Form — Database.Guide

- **URL:** <https://database.guide/2nf-second-normal-form-explained/>
- **Por qué:** Explicación de 2FN con el mismo estilo visual. Incluye ejercicios
  para identificar dependencias parciales.

---

## Práctica y Ejercicios

### SQL Normalization Tutorial — PostgreSQL Tutorial

- **URL:** <https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-primary-key/>
- **Por qué:** Tutoriales de PostgreSQL sobre PKs, FKs y constraints. Base para
  implementar correctamente las tablas del modelo normalizado.

### Normalization Exercises — w3resource

- **URL:** <https://www.w3resource.com/sql-exercises/sql-normalization-exercises.php>
- **Por qué:** Colección de ejercicios prácticos de normalización con soluciones.
  Útil para practicar más allá de los ejercicios del bootcamp.

### Use The Index, Luke — SQL Performance Explained

- **URL:** <https://use-the-index-luke.com/sql/where-clause/the-equals-operator/slow-indexes-part-i>
- **Por qué:** Explica por qué los valores multivaluados (violación de 1FN) como
  `user_skills_text LIKE '%Python%'` son lentos e imposibles de indexar eficientemente.

---

## Artículos de Referencia

### "A Relational Model of Data for Large Shared Data Banks" — E. F. Codd (1970)

- **URL:** <https://www.seas.upenn.edu/~zives/03f/cis550/codd.pdf>
- **Por qué:** El paper original de Edgar F. Codd donde introdujo el modelo
  relacional. Lectura histórica que establece los fundamentos matemáticos de todo
  lo que estudiamos en este bootcamp.

### "Further Normalization of the Data Base Relational Model" — E. F. Codd (1972)

- **URL:** <https://link.springer.com/chapter/10.1007/978-3-642-80744-5_3>
- **Por qué:** Segundo paper de Codd donde introduce 2FN, 3FN y la noción de
  dependencias funcionales. Lectura avanzada para entender el origen formal del tema.

---

## Herramientas Online

### dbdiagram.io — DBML

- **URL:** <https://dbdiagram.io>
- **Por qué:** Modelar el esquema normalizado de ConnectPro antes de escribir SQL.
  Usar DBML para representar las 4+ tablas del modelo 2FN.

### DB Fiddle (PostgreSQL)

- **URL:** <https://www.db-fiddle.com/>
- **Por qué:** Ejecutar los scripts de práctica y proyecto online sin necesidad de
  instalar PostgreSQL localmente. Seleccionar "PostgreSQL 15" (compatible con 16).

---

← [README semana](../../README.md)
