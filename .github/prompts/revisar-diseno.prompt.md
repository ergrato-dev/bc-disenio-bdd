---
mode: agent
description: >
  Analiza y revisa un diseño de base de datos (ER, modelo lógico o DDL).
  Detecta violaciones de formas normales, problemas de integridad, índices
  faltantes y anti-patrones. Propone mejoras justificadas.
---

# Revisar Diseño de Base de Datos

Necesito una revisión técnica detallada del siguiente diseño de base de datos.

## Material a revisar

$MATERIAL

<!-- Pega aquí: DDL SQL, DBML, descripción del modelo ER, o diagrama -->

## Contexto del sistema

$CONTEXTO

<!-- Describe brevemente el dominio del negocio y los requerimientos clave -->

## Tipo de revisión solicitada

$TIPO (completa | normalización | integridad | rendimiento | nomenclatura)

---

## Criterios de revisión

Analiza el diseño en el siguiente orden e informa con claridad cada hallazgo:

### 1. Normalización

Para cada tabla, verifica:

- **1FN:** ¿Existen grupos repetidos, columnas multivaluadas o valores no atómicos?
- **2FN:** (Solo si PK es compuesta) ¿Hay dependencias parciales?
- **3FN:** ¿Hay dependencias transitivas (atributo no clave que depende de otro no clave)?
- **FNBC:** ¿Toda dependencia funcional tiene como determinante una superclave?
- **4FN:** ¿Hay dependencias multivaluadas independientes en la misma tabla?

Para cada violación encontrada:

```
❌ VIOLACIÓN [XFN] — Tabla: [nombre]
   Problema: [descripción exacta]
   Dependencia detectada: [A → B]
   Solución: [cómo refactorizar]
```

### 2. Integridad referencial

Verifica:

- ¿Todas las FK tienen definido `ON DELETE` y `ON UPDATE`?
- ¿Las políticas de cascada son correctas para el dominio?
- ¿Hay columnas que deberían ser FK pero no lo son?
- ¿Los constraints `NOT NULL` son coherentes con las reglas de negocio?
- ¿Los constraints `CHECK` cubren todas las invariantes del dominio?
- ¿Hay `UNIQUE` faltantes en columnas que deberían serlo?

### 3. Nomenclatura y convenciones

Revisa contra el estándar del bootcamp:

- Tablas: `snake_case` plural en inglés
- Columnas: `snake_case` singular en inglés
- Constraints nombrados explícitamente: `pk_`, `fk_`, `uq_`, `ck_`
- Índices: `ix_tabla_columna`
- Tipos de datos PostgreSQL apropiados para cada caso de uso

### 4. Rendimiento e indexación

Identifica:

- FK sin índice (causa full-scan en JOINs)
- Columnas frecuentes en `WHERE`/`ORDER BY`/`GROUP BY` sin índice
- Columnas `text` o `varchar` de alta cardinalidad candidatas a índice
- Posibles índices parciales o compuestos beneficiosos
- Columnas calculables que no deberían persistirse

### 5. Anti-patrones de diseño

Detecta:

- Columnas tipo `data1`, `data2`, `data3` (indica tabla pivote faltante)
- Campos `varchar` almacenando múltiples valores separados por comas
- Uso de `id` genérico sin prefijo de tabla en relaciones complejas
- Ausencia de `created_at`/`updated_at` en tablas de entidades
- Uso de `SERIAL` en lugar de `GENERATED ALWAYS AS IDENTITY` (código nuevo)
- `TIMESTAMP` en lugar de `TIMESTAMPTZ`

---

## Formato del informe de salida

```
## 📋 Resumen del Diseño

[Descripción breve del modelo y su propósito]

## 🚦 Diagnóstico General

- **Normalización:** ✅ Cumple / ⚠️ Observaciones / ❌ Violaciones
- **Integridad:** ✅ / ⚠️ / ❌
- **Nomenclatura:** ✅ / ⚠️ / ❌
- **Rendimiento:** ✅ / ⚠️ / ❌

## 🔴 Problemas Críticos (deben corregirse)

[Listado con descripción + solución propuesta + DDL de corrección]

## 🟡 Observaciones (mejoras recomendadas)

[Listado con justificación]

## 🟢 Buenas prácticas detectadas

[Reconocer lo que está bien hecho]

## ✅ Diseño corregido

[DDL o DBML completo con todas las correcciones aplicadas]
```
