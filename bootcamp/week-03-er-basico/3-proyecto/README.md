# Proyecto Semana 03 — Sistema de Gestión Académica: Universidad TechEdu

> **Fase:** Modelo Conceptual &nbsp;|&nbsp; **Semana:** 03 de 14  
> **Herramienta:** draw.io (app.diagrams.net)  
> **Entrega:** Diagrama ER en SVG + hoja de análisis completada

## 📋 Contexto del Negocio

**Universidad TechEdu** es una institución de educación superior con sede en varios
campus. Necesita un sistema para gestionar su oferta académica: cursos, profesores,
estudiantes e inscripciones.

El sistema debe reemplazar hojas de cálculo dispersas y permitir responder preguntas
como: ¿qué cursos ofrece cada departamento?, ¿qué estudiantes están inscritos en
este semestre?, ¿cuál es el historial académico de un estudiante?, ¿qué carga
tiene cada profesor?

## 📐 Requerimientos del negocio

### Departamentos y profesores

- La universidad se organiza en **departamentos** (Ingeniería de Software, Matemáticas,
  Diseño UX, etc.). Cada departamento tiene un nombre, código único y un edificio donde
  opera.
- Cada departamento tiene un **director** (que es un profesor) designado. Un profesor
  puede ser director de un departamento como máximo.
- Los **profesores** tienen nombre, email institucional, título académico (licenciatura,
  maestría, doctorado) y fecha de contratación. Cada profesor pertenece a exactamente
  un departamento.

### Cursos y clases

- Los **cursos** son la oferta académica: "Fundamentos de SQL", "Cálculo I", etc.
  Cada curso tiene un código único, nombre, descripción, créditos y nivel
  (pregrado / posgrado). Cada curso pertenece a un departamento.
- Un curso puede tener **prerequisitos**: otros cursos que el estudiante debe haber
  aprobado antes. Un curso puede requerir varios prerequisitos, y puede ser
  prerequisito de varios otros cursos.
- Cada semestre se abren **clases** (grupos): es la impartición concreta de un curso.
  Una clase tiene un número de grupo, semestre (ej: "2026-1"), aula, horario y
  cupo máximo. Una clase es impartida por exactamente un profesor. Un profesor puede
  impartir cero o muchas clases por semestre.

### Estudiantes e inscripciones

- Los **estudiantes** tienen número de matrícula (único), nombre, email, fecha de
  nacimiento y carrera. La carrera es un atributo simple (texto), no una entidad
  (el sistema no gestiona el detalle de las carreras).
- Un estudiante puede **inscribirse** en cero o muchas clases por semestre. Una clase
  puede tener cero o muchos estudiantes inscritos (hasta el cupo máximo).
- La inscripción registra la fecha en que se realizó, la calificación final (puede
  ser NULL si el semestre no ha terminado) y el estado (inscrito, retirado, aprobado,
  reprobado).

## 🎯 Objetivo del Proyecto

Diseñar el diagrama ER completo para el sistema de **Universidad TechEdu** aplicando
los conceptos de la Semana 03:

1. Identificar todas las entidades del dominio
2. Definir atributos para cada entidad (con tipos)
3. Identificar todas las relaciones y determinar su cardinalidad
4. Documentar las decisiones de diseño más importantes
5. Crear el diagrama en draw.io y exportarlo como SVG

## 📦 Entregables

| Entregable | Archivo | Descripción |
|------------|---------|-------------|
| Hoja de análisis | `starter/analisis-er.md` | Completar las secciones con TODO |
| Diagrama ER | `mi-diagrama-er.svg` | Exportado desde draw.io |

## 📌 Instrucciones

1. Lee el enunciado completo antes de empezar
2. Abre `starter/analisis-er.md` y completa las secciones marcadas con `TODO`
3. Crea el diagrama en draw.io basándote en tu análisis
4. Verifica que el diagrama y el análisis son coherentes entre sí
5. Exporta el diagrama como SVG con opción "Incluir una copia del diagrama"

## ✅ Criterios de aceptación

- [ ] El diagrama incluye todas las entidades del enunciado
- [ ] Cada entidad tiene su atributo identificador marcado
- [ ] Todas las relaciones tienen cardinalidad y participación correctas
- [ ] Las relaciones están etiquetadas con un verbo descriptivo
- [ ] La relación de prerequisitos (reflexiva) está representada
- [ ] La relación de director entre PROFESOR y DEPARTAMENTO está representada
- [ ] El diagrama está exportado como SVG desde draw.io
- [ ] La hoja de análisis está completada

---

← [Práctica](../2-practicas/README.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Semana 04 →](../../week-04-er-intermedio/README.md)

- [ ] Diagrama ER exportado como SVG desde draw.io
- [ ] Listado de entidades, atributos y relaciones con justificación

## 🚀 Instrucciones

1. Trabaja en el directorio `starter/`
2. Lee los comentarios `-- TODO:` en cada archivo y completa el código
3. Prueba tu solución ejecutando los scripts en PostgreSQL 16+
4. Documenta tus decisiones de diseño en este README

## ✅ Criterios de Aceptación

- [ ] Todos los scripts SQL ejecutan sin errores en PostgreSQL 16+
- [ ] Las constraints nombradas siguen la convención `tipo_tabla_columna`
- [ ] El diseño está justificado en comentarios SQL o en este README

## 🔗 Referencias

- [Semana 03 — Teoría](../1-teoria/)
- [Semana 03 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)
