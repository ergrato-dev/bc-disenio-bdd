---
mode: agent
description: >
  Genera un ejercicio SQL guiado para el bootcamp. Produce README con
  pasos explicados y starter/ejercicio.sql con código comentado listo
  para que el estudiante ejecute sección por sección.
---

# Generar Ejercicio SQL Guiado

Necesito crear un ejercicio SQL guiado para el bootcamp de Diseño de Bases de Datos Relacionales.

## Datos del ejercicio

- **Semana:** $SEMANA
- **Tema:** $TEMA (ej: Creación de tablas con constraints, Normalización 2FN, Índices B-tree)
- **Dificultad:** $DIFICULTAD (básico | intermedio | avanzado)
- **Contexto de negocio:** $CONTEXTO (ej: sistema de biblioteca, plataforma de streaming, e-commerce)
- **Concepto principal a enseñar:** $CONCEPTO

## Estructura a generar

```
2-practicas/ejercicio-XX-NOMBRE/
├── README.md
└── starter/
    └── ejercicio.sql
```

---

## README.md — Formato obligatorio

El README debe seguir esta estructura:

````markdown
# Ejercicio XX — [Título descriptivo]

## 🎯 Objetivo

[Qué va a aprender el estudiante al completar este ejercicio]

## 📋 Prerequisitos

- [Concepto 1 que debe dominar antes]
- [Concepto 2...]

## 🏢 Contexto

[2-3 párrafos describiendo el sistema de negocio de forma atractiva]

## 🗂️ Estructura de la BD

[Descripción breve de las tablas que se van a crear/usar]

---

## Paso 1: [Título del paso]

[Explicación del concepto con el "por qué", no solo el "qué"]

```sql
-- SQL completo y funcional como ejemplo
CREATE TABLE ...
```
````

Ejecuta el bloque del **Paso 1** en `starter/ejercicio.sql`.

**¿Qué observar?** [Qué debe notar el estudiante al ejecutar]

---

## Paso 2: ...

[Repetir para cada paso]

---

## ✅ Verificación final

[Consultas SQL que el estudiante debe ejecutar para confirmar que todo funciona]

## 🔎 Para reflexionar

1. [Pregunta para promover pensamiento crítico]
2. [¿Qué pasaría si...?]
3. [¿Cómo cambiaría el diseño si el requerimiento fuera diferente?]

````

---

## starter/ejercicio.sql — Formato obligatorio

```sql
-- ============================================
-- EJERCICIO XX: [TÍTULO]
-- Semana XX: [TEMA DE LA SEMANA]
-- ============================================
-- Instrucciones:
--   1. Lee el README.md antes de comenzar
--   2. Descomenta y ejecuta cada bloque en orden
--   3. Verifica los resultados antes de avanzar al siguiente paso
-- ============================================

-- ============================================
-- PASO 1: [TÍTULO DEL PASO]
-- ============================================
-- [Explicación breve en español de qué hace este bloque]
-- Descomenta y ejecuta:

-- CREATE TABLE [tabla] (
--     id          BIGINT      GENERATED ALWAYS AS IDENTITY
--                             CONSTRAINT pk_[tabla] PRIMARY KEY,
--     [columna]   VARCHAR(n)  NOT NULL
--                             CONSTRAINT uq_[tabla]_[columna] UNIQUE,
--     created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- ============================================
-- PASO 2: [TÍTULO DEL PASO]
-- ============================================
-- ...
````

## Reglas de calidad

- Cada paso debe enseñar exactamente **un concepto** a la vez
- Incluir entre 3 y 6 pasos por ejercicio
- El contexto de negocio debe ser coherente y realista
- Los datos de prueba (INSERT) deben cubrir casos límite y nulos cuando aplique
- Nunca usar TODOs en ejercicios — el código está completo, solo comentado
- Los comentarios SQL deben explicar el "por qué" (decisiones de diseño), no solo el "qué"
- Terminar siempre con consultas de verificación (SELECT) que confirmen el resultado esperado
