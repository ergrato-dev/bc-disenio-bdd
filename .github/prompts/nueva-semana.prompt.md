---
mode: agent
description: >
  Genera la estructura completa de una semana del bootcamp de Diseño de BD:
  carpetas, README, teoría, prácticas SQL, proyecto con starter/solution,
  recursos y glosario. Espera confirmación antes de cada sección.
---

# Crear Semana del Bootcamp

Necesito crear el contenido completo para una semana del **Bootcamp de Diseño de Bases de Datos Relacionales**.

## Datos de la Semana

- **Número:** $SEMANA (ej: 03)
- **Slug:** $SLUG (ej: er_basico)
- **Título:** $TITULO (ej: Diagrama ER Básico)
- **Fase:** $FASE (Fundamentos | Conceptual | Lógico | Físico | Avanzado)
- **Semana anterior:** $SEMANA_ANTERIOR
- **Semana siguiente:** $SEMANA_SIGUIENTE

## Qué generar

Sigue **estrictamente** este orden y espera confirmación antes de avanzar:

### Paso 1 — Estructura base + README.md

Crea la carpeta `bootcamp/week-$SEMANA-$SLUG/` con todas las subcarpetas y el `README.md` principal que incluya:

- Objetivos de aprendizaje (4-6 bullets)
- Prerequisitos (semanas anteriores relevantes)
- Tabla de contenidos con enlaces
- Distribución del tiempo (8h/semana)
- Entregables de la semana
- Navegación anterior/siguiente

### Paso 2 — Teoría (`1-teoria/`)

Genera el material teórico con:

- Explicaciones conceptuales claras en español
- Diagramas DBML o referencias a SVGs en `0-assets/`
- Ejemplos SQL comentados educativamente
- Tabla de resumen de conceptos clave
- Sección "Errores comunes" con anti-patrones

### Paso 3 — Prácticas (`2-practicas/`)

Crea entre 2 y 3 ejercicios guiados. Cada ejercicio debe:

- Tener su propio `README.md` con pasos detallados
- Incluir `starter/ejercicio.sql` con código comentado (listo para descomentar y ejecutar)
- **NO** usar TODOs — el código SQL completo debe estar ahí, solo comentado
- Incluir verificación: qué resultado esperar al ejecutar

### Paso 4 — Proyecto (`3-proyecto/`)

Genera el proyecto integrador con:

- `README.md`: contexto de negocio real, requerimientos, criterios de evaluación
- `starter/`: esqueleto SQL con TODOs claros y descriptivos
- `solution/`: solución completa (se excluye del repo público vía `.gitignore`)

### Paso 5 — Recursos + Glosario + Rúbrica

- `4-recursos/webgrafia/README.md`: mínimo 5 recursos de calidad (PostgreSQL docs, artículos, etc.)
- `5-glosario/README.md`: 8-12 términos clave ordenados A-Z, definidos en español
- `rubrica-evaluacion.md`: criterios de evaluación con ponderación (conocimiento 30%, desempeño 40%, producto 30%)

## Convenciones obligatorias

- SQL: keywords en MAYÚSCULAS, identificadores en snake_case inglés
- Comentarios SQL en español
- Nombres de constraints explícitos: `pk_tabla`, `fk_tabla_columna`, `uq_tabla_col`, `ck_tabla_col`
- `NOT NULL` declarado explícitamente siempre
- `ON DELETE`/`ON UPDATE` en todas las FOREIGN KEY
- PostgreSQL 16+ (`GENERATED ALWAYS AS IDENTITY`, `TIMESTAMPTZ`, `gen_random_uuid()`)
