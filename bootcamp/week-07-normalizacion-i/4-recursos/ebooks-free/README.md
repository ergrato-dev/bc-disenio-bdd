# Ebooks Gratuitos — Semana 07: Normalización I

Recursos de lectura gratuitos y legales sobre dependencias funcionales y normalización.

---

## Fundamentos de Normalización

### 1. Database Design — 2nd Edition (Wikibooks)

- **URL:** <https://en.wikibooks.org/wiki/Database_Design>
- **Capítulos relevantes:** Normalization, Functional Dependencies
- **Idioma:** Inglés
- **Por qué leerlo:** Explicación progresiva de 1FN a FNBC con ejemplos visuales
  y ejercicios. Ideal como complemento de la teoría de esta semana.

### 2. Relational Database Design and Implementation — Joyce J. Farrell (excerpts)

- **URL:** <https://openlibrary.org/works/OL19735842W>
- **Capítulos relevantes:** Chapter 7 — Normalization
- **Idioma:** Inglés
- **Por qué leerlo:** Uno de los textos universitarios más usados para normalización.
  Incluye ejercicios prácticos con soluciones.

### 3. Introducción a los Sistemas de Bases de Datos — C. J. Date (resúmenes)

- **URL:** <https://archive.org/search?query=date+introduction+database+systems>
- **Capítulos relevantes:** Capítulo 11 — Normalización adicional: 5NF y más allá
- **Idioma:** Inglés (hay traducción al español en bibliotecas)
- **Por qué leerlo:** El texto canónico de teoría relacional. El Capítulo 10 cubre
  1FN, 2FN, 3FN y FNBC con rigor formal. El autor de estas formas normales.

### 4. SQL Antipatterns — Bill Karwin (capítulo gratuito)

- **URL:** <https://pragprog.com/titles/bksqla/sql-antipatterns/>
- **Capítulo gratuito:** "Jaywalking" — antipatrón de almacenar listas en TEXT
- **Idioma:** Inglés
- **Por qué leerlo:** El capítulo "Jaywalking" describe exactamente el problema
  de `customer_phones TEXT = "555-1234, 555-5678"` que estudiamos esta semana.
  Muy práctico y directo.

### 5. PostgreSQL: Up and Running — Regina O. Obe, Leo S. Hsu (extracto)

- **URL:** <https://www.oreilly.com/library/view/postgresql-up-and/9781492057604/>
- **Sección relevante:** Data Types — JSON, Arrays vs normalized tables
- **Idioma:** Inglés
- **Por qué leerlo:** Perspectiva práctica sobre cuándo usar tipos complejos de
  PostgreSQL (JSONB, ARRAY) vs normalización clásica. Útil para tomar decisiones
  de diseño en proyectos reales.

---

## Lectura Recomendada para Esta Semana

Para acompañar la práctica de LibroExpress, lee primero el capítulo de
**SQL Antipatterns — Jaywalking**. Luego revisa el capítulo de normalización de
**Database Design (Wikibooks)** para reforzar los conceptos de FD parcial y completa.

---

← [README semana](../../README.md)
