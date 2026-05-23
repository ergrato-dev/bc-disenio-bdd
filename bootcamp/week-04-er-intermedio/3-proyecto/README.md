# Proyecto Semana 04 — Sistema de Gestión de Conferencias: TechSummit

> **Fase:** Modelo Conceptual Intermedio &nbsp;|&nbsp; **Semana:** 04 de 14  
> **Herramienta:** draw.io (app.diagrams.net)  
> **Entrega:** Hoja de análisis completada + diagrama ER exportado como SVG

## 📋 Contexto del Negocio

**TechSummit** es una plataforma de gestión de conferencias tecnológicas. Organiza
múltiples eventos por año, cada uno con docenas de charlas, ponentes invitados y
miles de asistentes.

El equipo de TI necesita un modelo de datos que capture la complejidad real del
negocio: charlas que ocurren en salas específicas impartidas por ponentes, asistentes
que se inscriben en sesiones (con límite de cupo), y el historial completo de quién
estuvo en qué sesión.

## 📐 Requerimientos del negocio

### Conferencias

- El sistema gestiona múltiples **conferencias** al año. Cada conferencia tiene un nombre,
  año, ciudad sede, fecha de inicio y fecha de fin. El nombre de la conferencia es único.
- Cada conferencia tiene un número de edición que la identifica **dentro de su nombre**:
  "TechSummit 2026 — Edición 8", "TechSummit 2025 — Edición 7". El número de edición
  solo es único en el contexto del nombre de la conferencia.

### Charlas y ponentes

- Cada conferencia tiene una o más **charlas**. Cada charla tiene un título, descripción,
  duración en minutos y nivel de dificultad (principiante, intermedio, avanzado). El
  código de charla (p.ej. `T-042`) es único **dentro de la conferencia** que la contiene.
- Cada charla es impartida por exactamente un **ponente**. Un ponente puede impartir cero
  o muchas charlas a lo largo del tiempo (en distintas conferencias).
- Los ponentes tienen nombre, email, bio corta, empresa donde trabajan y una lista de
  **especialidades** (múltiples: "machine learning", "cloud", "seguridad"…).

### Salas

- Cada conferencia tiene un conjunto de **salas** donde se realizan las charlas. Cada
  sala tiene un número o nombre (`Sala A`, `Sala Principal`) y una capacidad de asistentes.
  El nombre de sala es único **dentro de la conferencia**.
- Cada charla se realiza en exactamente una sala de su conferencia.

### Sesiones e inscripciones

- Una **sesión** es la realización concreta de una charla en una sala a una hora específica.
  Una charla puede tener más de una sesión (por ejemplo, se repite por alta demanda).
  Cada sesión tiene hora de inicio, hora de fin y un aforo disponible.
- Los **asistentes** se registran en el sistema con nombre, email, empresa y país. Un
  asistente puede inscribirse a cero o muchas sesiones de una conferencia.
- La **inscripción** de un asistente a una sesión tiene: fecha de inscripción, estado
  (confirmada, en lista de espera, cancelada) y si el asistente efectivamente asistió
  (booleano, registrado post-evento).

## 🎯 Objetivo del Proyecto

Diseñar el diagrama ER completo de TechSummit aplicando los conceptos de Semana 04:

1. Identificar las **entidades débiles** (al menos 2) y sus claves parciales
2. Representar los **atributos multivaluados** con sus tablas derivadas
3. Identificar la **relación ternaria** si existe (charla, sala, conferencia)
4. Modelar la **entidad asociativa** (inscripción) con sus atributos propios
5. Documentar todas las decisiones en la hoja de análisis

## 📦 Entregables

| Entregable | Archivo | Descripción |
|------------|---------|-------------|
| Hoja de análisis | `starter/analisis-er.md` | Completar todas las secciones TODO |
| Diagrama ER | `mi-diagrama-er.svg` | Exportado desde draw.io con todas las entidades |

## 📌 Instrucciones

1. Lee todo el enunciado antes de empezar
2. Completa `starter/analisis-er.md` sección por sección
3. Usa tu análisis como guía para construir el diagrama en draw.io
4. Exporta como SVG con **"Incluir una copia del diagrama"** activado
5. Verifica con los criterios de aceptación antes de entregar

## ✅ Criterios de aceptación

- [ ] El diagrama incluye todas las entidades del enunciado
- [ ] Al menos 2 entidades débiles identificadas con su clave parcial documentada
- [ ] Los atributos multivaluados de PONENTE representados con tabla separada
- [ ] La entidad asociativa INSCRIPCION tiene sus 3 atributos propios
- [ ] Todas las relaciones tienen cardinalidad y participación (Crow's Foot)
- [ ] Todas las relaciones están etiquetadas con un verbo
- [ ] La hoja de análisis está completada con justificaciones, no solo respuestas
- [ ] El diagrama está exportado como SVG desde draw.io

---

← [Práctica](../2-practicas/README.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Semana 05 →](../../week-05-er-avanzado/README.md)

- [ ] Diagrama ER actualizado con entidades débiles y/o ternarias
- [ ] Documento de decisiones de diseño

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

- [Semana 04 — Teoría](../1-teoria/)
- [Semana 04 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)
