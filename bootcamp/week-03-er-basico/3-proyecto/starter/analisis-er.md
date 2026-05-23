# Hoja de Análisis ER — Universidad TechEdu

> **Instrucciones:** Completa cada sección marcada con `TODO`. Lee el enunciado
> completo en `README.md` antes de empezar. No hay una única respuesta correcta:
> justifica tus decisiones con el enunciado.

---

## Sección 1 — Identificación de entidades

Lista todos los sustantivos del dominio y decide si son entidades o atributos.

| Sustantivo | ¿Entidad? | Justificación |
|------------|-----------|---------------|
| Departamento | TODO | TODO |
| Profesor | TODO | TODO |
| Director | TODO | TODO — ¿es una entidad separada o un rol de PROFESOR? |
| Curso | TODO | TODO |
| Clase (grupo) | TODO | TODO |
| Estudiante | TODO | TODO |
| Inscripción | TODO | TODO — ¿es una entidad o solo la relación entre ESTUDIANTE y CLASE? |
| Carrera | TODO | TODO — ¿entidad o atributo de ESTUDIANTE? Lee el enunciado con cuidado |
| Prerequisito | TODO | TODO — ¿entidad propia o atributo de relación? |
| Semestre | TODO | TODO |
| Aula | TODO | TODO |

**Entidades que incluirás en tu diagrama:**
> TODO: lista final

---

## Sección 2 — Atributos de cada entidad

Para cada entidad, completa la tabla. Marca el tipo de atributo y señala el identificador.

### DEPARTMENT (Departamento)

| Atributo | Tipo | Notas |
|----------|------|-------|
| TODO | TODO (identificador) | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |

### PROFESSOR (Profesor)

| Atributo | Tipo | Notas |
|----------|------|-------|
| TODO | TODO (identificador) | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |

### COURSE (Curso)

| Atributo | Tipo | Notas |
|----------|------|-------|
| TODO | TODO (identificador) | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |

### CLASS (Clase / Grupo)

| Atributo | Tipo | Notas |
|----------|------|-------|
| TODO | TODO (identificador) | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |

### STUDENT (Estudiante)

| Atributo | Tipo | Notas |
|----------|------|-------|
| TODO | TODO (identificador) | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |
| TODO | TODO | |

---

## Sección 3 — Relaciones y cardinalidades

Para cada relación, indica:
- El nombre (verbo)
- La cardinalidad (1:1, 1:N, N:M)
- La participación en cada extremo (|| o ○)
- Notación Crow's Foot resultante

| Relación | Entre | Cardinalidad | Notación CF | Regla de negocio |
|----------|-------|-------------|-------------|-----------------|
| TODO | DEPARTMENT — PROFESSOR | TODO | TODO | Un profesor pertenece a un departamento; un departamento tiene... |
| TODO | DEPARTMENT — PROFESSOR | TODO | TODO | La relación de "dirección" — un director es un profesor |
| TODO | DEPARTMENT — COURSE | TODO | TODO | |
| TODO | PROFESSOR — CLASS | TODO | TODO | |
| TODO | COURSE — CLASS | TODO | TODO | |
| TODO | STUDENT — CLASS | TODO | TODO | Relación N:M — la inscripción |
| TODO | COURSE — COURSE | TODO | TODO | Relación reflexiva — prerequisitos |

### Atributos de la relación INSCRIPCION (STUDENT — CLASS)

> TODO: lista los atributos que pertenecen a la inscripción (no al estudiante ni a la clase)

---

## Sección 4 — Decisiones de diseño

Responde estas preguntas para documentar tus decisiones más importantes:

### 4.1 ¿Creaste una entidad separada para la inscripción o solo una relación N:M?

> TODO: explica tu decisión con el enunciado

### 4.2 ¿Cómo modelaste la relación de "director" entre PROFESOR y DEPARTAMENTO?

Opciones posibles:
- a) Una relación 1:1 separada llamada "dirige"
- b) Un atributo `director_id` en DEPARTAMENTO

> TODO: elige una y justifícala

### 4.3 ¿Cómo modelaste los prerequisitos?

Los prerequisitos son una relación de COURSE consigo mismo (reflexiva).

> TODO: describe cómo la dibujaste en draw.io y cómo nombraste los roles

### 4.4 Atributo derivado identificado

> TODO: identifica al menos un atributo derivado en tu modelo y explica por qué no
> lo almacenas

---

## Sección 5 — Verificación final

Antes de exportar, verifica:

- [ ] Cada entidad tiene exactamente un atributo identificador
- [ ] Todas las relaciones tienen cardinalidad y participación marcadas
- [ ] Todas las relaciones están etiquetadas con un verbo
- [ ] La relación reflexiva de prerequisitos está representada
- [ ] La relación de director está representada
- [ ] La entidad de inscripción (o relación N:M) tiene sus atributos propios
- [ ] Los nombres de entidades están en inglés (MAYÚSCULAS o PascalCase)
- [ ] El diagrama está exportado como SVG

---

← [README del Proyecto](../README.md)
