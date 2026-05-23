# Libros Gratuitos — Semana 08: Normalización II

## Libros Recomendados

### 1. Fundamentals of Database Systems (Elmasri & Navathe) — Capítulo 10

**Tema:** Algoritmos de normalización avanzada — 3FN por síntesis, FNBC

> Capítulo disponible en versiones anteriores del libro (6ª edición),
> accesible en repositorios educativos de universidades públicas.

- **URL:** <https://repository.unp.edu.ar/handle/20.500.12272/3053>
- **Formato:** PDF
- **Idioma:** Inglés
- **Relevancia directa:** Algoritmo de síntesis para 3FN (p. 363-375),
  comparación FNBC vs 3FN con ejemplos paso a paso

---

### 2. An Introduction to Database Systems (C.J. Date) — Capítulo 11

**Tema:** Dependencias funcionales, 3FN, FNBC y el debate entre ambas formas normales.

> Date es el autor más riguroso en teoría relacional. Su tratamiento de
> la distinción 3FN/FNBC es el más claro de la literatura.

- **URL:** <https://archive.org/details/introductiontoda0000date_d5q5>
- **Formato:** PDF (Archive.org)
- **Idioma:** Inglés
- **Relevancia directa:** Capítulo 11 — Third and Fourth Normal Forms,
  con la demostración de que FNBC no siempre preserva dependencias

---

### 3. Database Management Systems (Ramakrishnan & Gehrke) — Capítulo 19

**Tema:** Normalización — 3FN por síntesis, FNBC por descomposición.

> Libro de texto estándar en cursos de licenciatura. La 3ª edición está
> disponible libremente en repositorios académicos.

- **URL:** <https://pages.cs.wisc.edu/~dbbook/>
- **Formato:** Web + PDF (acceso libre desde la página del autor)
- **Idioma:** Inglés
- **Relevancia directa:** Capítulo 19 — Schema Refinement and Normal Forms,
  con algoritmos detallados y ejemplos de descomposición FNBC con pérdida de FDs

---

### 4. SQL Antipatterns (Bill Karwin) — Capítulo 17: Poor Man's Search Engine

**Tema:** Desnormalización — cuándo es válida y cuándo es un antipatrón.

> Este libro trata la desnormalización desde el punto de vista práctico:
> cuándo es una decisión de ingeniería justificada y cuándo es simplemente
> pereza que generará problemas de mantenimiento.

- **URL:** <https://pragprog.com/titles/bksqla/sql-antipatterns/>
- **Formato:** Digital (preview gratuito en el sitio oficial)
- **Idioma:** Inglés
- **Relevancia directa:** Capítulo 17 — Antipatrón "Jaywalking" y el
  uso correcto de tablas de lookup vs columnas redundantes

---

### 5. PostgreSQL 16 Documentation — DDL: Constraints

**Tema:** Implementación física de las restricciones que refuerzan 3FN/FNBC.

> Documentación oficial de PostgreSQL. Las constraints `UNIQUE` y `CHECK`
> son las herramientas que hacen cumplir las formas normales a nivel físico.

- **URL:** <https://www.postgresql.org/docs/16/ddl-constraints.html>
- **Formato:** HTML (web oficial)
- **Idioma:** Inglés / Español parcial
- **Relevancia directa:** Secciones 5.4–5.6 — PRIMARY KEY, FOREIGN KEY,
  UNIQUE y CHECK como mecanismos de integridad que soportan la normalización

---

← [Teoría](../../1-teoria/) | → [Videografía](../videografia/README.md)
