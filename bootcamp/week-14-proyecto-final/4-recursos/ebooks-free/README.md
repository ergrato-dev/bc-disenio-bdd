# Libros Gratuitos Recomendados — Semana 14

Recursos de lectura gratuita o con acceso abierto para profundizar en diseño
de bases de datos, SQL avanzado y PostgreSQL en producción.

---

## Diseño de Bases de Datos

### Database Design for Mere Mortals (Capítulos de muestra)
- **URL:** https://www.informit.com/articles/article.aspx?p=373888
- **Nivel:** Principiante → Intermedio
- **Por qué:** Introduce el proceso de diseño relacional de forma accesible,
  con énfasis en requerimientos → modelo conceptual → modelo lógico. Ideal
  para repasar los fundamentos antes del proyecto final.

### CMU 15-445 Course Notes (Andy Pavlo — Carnegie Mellon)
- **URL:** https://15445.courses.cs.cmu.edu/fall2023/notes/
- **Nivel:** Intermedio → Avanzado
- **Por qué:** Notas del curso de bases de datos más completo disponible
  públicamente. Cubre desde almacenamiento físico hasta optimización de
  queries y control de concurrencia. Texto de referencia para los temas de
  las semanas 10-14.

---

## PostgreSQL

### PostgreSQL 16 Official Documentation
- **URL:** https://www.postgresql.org/docs/16/
- **Nivel:** Todos los niveles
- **Por qué:** La documentación oficial de PostgreSQL es excepcionalmente
  bien escrita. Los capítulos más relevantes para este bootcamp son:
  - [DDL](https://www.postgresql.org/docs/16/ddl.html) — Tipos de datos, constraints, schemas
  - [Indexes](https://www.postgresql.org/docs/16/indexes.html) — Tipos de índice, estrategias
  - [PL/pgSQL](https://www.postgresql.org/docs/16/plpgsql.html) — Funciones y triggers
  - [Row Security](https://www.postgresql.org/docs/16/ddl-rowsecurity.html) — RLS y multi-tenancy

### The Internals of PostgreSQL (Hironobu Suzuki)
- **URL:** https://www.interdb.jp/pg/
- **Nivel:** Avanzado
- **Por qué:** Explica cómo PostgreSQL funciona internamente: heap files,
  MVCC, VACUUM, el planificador de queries. Imprescindible para entender
  por qué `EXPLAIN ANALYZE` muestra lo que muestra.

---

## SQL y Prácticas

### pgExercises — Interactive SQL Practice
- **URL:** https://pgexercises.com/
- **Nivel:** Principiante → Intermedio
- **Por qué:** Ejercicios SQL interactivos con retroalimentación inmediata.
  Cubre SELECT, JOINs, agregaciones, CTEs y funciones de ventana. Perfecto
  para repasar y afianzar antes del proyecto final.

### SQL Style Guide (Simon Holywell)
- **URL:** https://www.sqlstyle.guide/
- **Nivel:** Todos los niveles
- **Por qué:** Guía de estilo SQL consensuada por la comunidad. Complementa
  las convenciones de nomenclatura del bootcamp con argumentos adicionales.

---

← [README de la Semana](../../README.md) | → [Videografía](../videografia/README.md)
