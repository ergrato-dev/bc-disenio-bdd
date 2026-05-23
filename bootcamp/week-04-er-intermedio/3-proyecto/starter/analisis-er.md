# Hoja de Análisis ER — TechSummit

> Completa todas las secciones con tus propias respuestas.  
> **No hay respuesta única correcta** — el objetivo es que documentes tus decisiones
> de diseño con justificaciones claras.

---

## Sección 1 — Identificación de Entidades

Lee el enunciado y completa la tabla. Para cada sustantivo importante del texto,
decide si es una entidad, un atributo o un candidato a entidad débil.

| Sustantivo | Tipo | Justificación (escribe al menos una oración) |
|------------|------|----------------------------------------------|
| Conferencia | <!-- TODO: Entidad / Atributo / Entidad débil --> | <!-- TODO --> |
| Charla | <!-- TODO --> | <!-- TODO: ¿De qué depende para ser identificada? --> |
| Ponente | <!-- TODO --> | <!-- TODO --> |
| Sala | <!-- TODO: ¿El nombre de sala es único globalmente o por conferencia? --> | <!-- TODO --> |
| Sesión | <!-- TODO --> | <!-- TODO: ¿Qué entidad la identifica? --> |
| Asistente | <!-- TODO --> | <!-- TODO --> |
| Inscripción | <!-- TODO: ¿Entidad propia o solo relación? --> | <!-- TODO: ¿Tiene atributos propios? ¿Otras entidades la referencian? --> |
| Especialidad de ponente | <!-- TODO: Entidad o multivaluado --> | <!-- TODO --> |

---

## Sección 2 — Entidades Débiles

Para cada entidad débil que identificaste, completa esta ficha:

### Entidad débil #1

| Campo | Tu respuesta |
|-------|-------------|
| Nombre de la entidad débil | <!-- TODO --> |
| Entidad fuerte (propietaria) | <!-- TODO --> |
| ¿Por qué no puede identificarse sola? | <!-- TODO --> |
| Clave parcial (atributo discriminador) | <!-- TODO --> |
| PK compuesta resultante | <!-- TODO: (fk_entidad_fuerte, clave_parcial) --> |
| Tipo de relación de identificación | <!-- TODO: 1:N → Fuerte a Débil --> |

### Entidad débil #2

| Campo | Tu respuesta |
|-------|-------------|
| Nombre de la entidad débil | <!-- TODO --> |
| Entidad fuerte (propietaria) | <!-- TODO --> |
| ¿Por qué no puede identificarse sola? | <!-- TODO --> |
| Clave parcial (atributo discriminador) | <!-- TODO --> |
| PK compuesta resultante | <!-- TODO --> |
| Tipo de relación de identificación | <!-- TODO --> |

---

## Sección 3 — Atributos Multivaluados

### SPEAKER: especialidades

| Pregunta de diseño | Tu respuesta |
|--------------------|-------------|
| ¿Cómo representas las especialidades en el diagrama ER? | <!-- TODO: doble óvalo o tabla separada --> |
| Nombre de la tabla derivada | <!-- TODO: ejemplo: speaker_specialties --> |
| Columnas de esa tabla y sus tipos | <!-- TODO --> |
| PK de la tabla derivada | <!-- TODO --> |
| ¿Por qué no usarías un campo `VARCHAR` con valores separados por coma? | <!-- TODO --> |

---

## Sección 4 — Relaciones y Cardinalidades

Completa la tabla para cada par de entidades:

| Relación | Verbo | Cardinalidad | Participación lado A | Participación lado B | Justificación |
|----------|-------|-------------|----------------------|----------------------|---------------|
| CONFERENCE ─ CHARLA | <!-- TODO --> | <!-- TODO: 1:N / N:M --> | <!-- TODO: obligatoria/opcional --> | <!-- TODO --> | <!-- TODO --> |
| CHARLA ─ SPEAKER | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO: ¿Un ponente puede no tener charlas asignadas todavía? --> |
| CHARLA ─ SALA | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO: ¿Una sala puede no tener charlas programadas? --> |
| SPEAKER ─ CONFERENCE | <!-- TODO: ¿Hay relación directa o solo a través de CHARLA? --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| SESION ─ ASISTENTE | <!-- TODO: a través de qué entidad --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |

---

## Sección 5 — Entidad Asociativa: INSCRIPCION

### Decisión de diseño

Responde cada pregunta para justificar por qué INSCRIPCION es una entidad propia:

1. **¿La relación ASISTENTE-SESION tiene atributos propios?**  
   <!-- TODO: Lista los atributos y di de quién serían si no hubiera entidad asociativa -->

2. **¿Otras partes del sistema podrían referenciar una INSCRIPCION?**  
   <!-- TODO: ¿Podría existir una tabla PAGOS que apunte a una inscripción específica? -->

3. **¿La inscripción tiene un ciclo de vida propio?**  
   <!-- TODO: Describe los posibles estados y transiciones -->

4. **¿Podría un asistente inscribirse dos veces a la misma sesión?**  
   <!-- TODO: ¿Qué restricción de unicidad necesitarías en la tabla? -->

### Atributos de INSCRIPCION

| Atributo | Tipo de dato | Restricción | Justificación |
|----------|-------------|-------------|---------------|
| id | bigint | PK | <!-- TODO: ¿Por qué PK sustituta en lugar de PK compuesta (asistente+sesion)? --> |
| <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | fecha en que el asistente se inscribió |
| <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | confirmada / en_espera / cancelada |
| <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | si el asistente efectivamente asistió |
| <!-- TODO: FK → asistente --> | bigint | FK NOT NULL | |
| <!-- TODO: FK → sesión --> | bigint | FK NOT NULL | |

---

## Sección 6 — Verificación final

Antes de dibujar el diagrama, responde:

1. ¿Cuántas entidades tiene tu modelo? Lístelas: <!-- TODO -->

2. ¿Cuántas relaciones de identificación (entidades débiles)? <!-- TODO -->

3. ¿Cuántos atributos multivaluados aparecen como tablas separadas? <!-- TODO -->

4. ¿Hay alguna relación N:M que NO sea una entidad asociativa? Si es así, ¿cuál y por qué no la promoviste?  
   <!-- TODO -->

5. ¿Qué pasa si una SALA cambia de capacidad entre conferencias? ¿Tu modelo lo soporta?  
   <!-- TODO -->

---

## Diagrama ER (enlace)

> Cuando termines, exporta tu diagrama desde draw.io y guárdalo en:  
> `3-proyecto/mi-diagrama-er.svg`

Enlace al diagrama en draw.io: <!-- TODO: pega el enlace de tu diagrama aquí -->
