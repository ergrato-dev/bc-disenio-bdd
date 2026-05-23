---
applyTo: "bootcamp/**/README.md, bootcamp/**/1-teoria/**/*.md, bootcamp/**/5-glosario/**/*.md, bootcamp/**/rubrica-evaluacion.md"
---

# Convenciones Markdown — Bootcamp Diseño de Bases de Datos Relacionales

## Idioma

- ✅ Todo el contenido educativo (teoría, guías, README) **en español**
- ✅ Términos técnicos en inglés escritos entre backticks: `PRIMARY KEY`, `JOIN`, `NULL`
- ✅ Nombres de objetos de BD en inglés: tabla `order_items`, columna `created_at`
- ❌ No mezclar idiomas dentro de un mismo párrafo sin señalarlo con backticks

## Estructura obligatoria de README.md de semana

```markdown
# Semana XX — [Título de la Semana]

> [Tagline de una línea que resume el valor de aprendizaje]

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, serás capaz de:

- ✅ [Objetivo 1 — verbo de acción + resultado concreto]
- ✅ [Objetivo 2]
- ...

## 📋 Prerequisitos

- [ ] Haber completado [Semana anterior]
- [ ] [Concepto específico que debe dominar]

## 🗂️ Contenido de la Semana

| #   | Tipo        | Tema        | Tiempo |
| --- | ----------- | ----------- | ------ |
| 1   | 📖 Teoría   | [Tema]      | ~Xh    |
| 2   | 💻 Práctica | [Ejercicio] | ~Xh    |
| 3   | 🏗️ Proyecto | [Nombre]    | ~Xh    |

## ⏱️ Distribución del Tiempo (8 horas)

| Componente            | Horas |
| --------------------- | ----- |
| Teoría                | 2h    |
| Prácticas guiadas     | 3h    |
| Proyecto semanal      | 2h    |
| Evaluación / revisión | 1h    |

## 📌 Entregables

- [ ] [Entregable 1]
- [ ] [Entregable 2]

## 🔗 Navegación

← [Semana anterior](../week-XX-tema/) &nbsp;&nbsp;|&nbsp;&nbsp; [Semana siguiente](../week-XX-tema/) →
```

## Estructura obligatoria de archivos de teoría

```markdown
# [Título del tema]

## 🎯 Objetivos

- [Lo que el estudiante aprenderá]

## 📖 [Sección 1: Concepto principal]

[Explicación]

### Ejemplo

[Código SQL o diagrama con explicación]

## 📖 [Sección 2]

...

## ⚠️ Errores Comunes

| Error | Por qué ocurre | Cómo evitarlo |
| ----- | -------------- | ------------- |

## 🧩 Resumen

[Tabla o listado de conceptos clave]

## 📚 Recursos Adicionales

- [Enlace oficial 1]
- [Enlace oficial 2]

## ✅ Checklist de Comprensión

- [ ] [Pregunta de autocomprobación 1]
- [ ] [Pregunta 2]
```

## Bloques de código

- Usar siempre el lenguaje en el fenced code block: ` ```sql `, ` ```dbml `, ` ```yaml `
- SQL dentro de bloques: keywords en MAYÚSCULAS, identificadores en minúsculas
- Incluir comentarios explicativos en español dentro del código educativo

````markdown
```sql
-- Creamos la tabla con una clave primaria de identidad (más segura que SERIAL)
CREATE TABLE products (
    id    BIGINT GENERATED ALWAYS AS IDENTITY CONSTRAINT pk_products PRIMARY KEY,
    name  VARCHAR(100) NOT NULL
);
```
````

````

## Advertencias y notas especiales

```markdown
> 💡 **Tip:** [Consejo práctico]

> ⚠️ **Atención:** [Algo a tener cuidado]

> ❌ **Anti-patrón:** [Práctica a evitar con explicación]

> 📌 **Recuerda:** [Concepto clave a no olvidar]
````

## Tablas comparativas (obligatorias en teoría)

Cuando se comparen dos enfoques, usar siempre tabla con columnas: Aspecto | ✅ Recomendado | ❌ Evitar

## Vinculación de assets

```markdown
<!-- ✅ CORRECTO — ruta relativa desde el archivo actual -->

![Diagrama ER del sistema de e-commerce](../0-assets/er-ecommerce.svg)

<!-- ❌ INCORRECTO — ruta absoluta o URL externa para assets propios -->

![Diagrama](https://example.com/diagram.png)
```

- Todo SVG en `0-assets/` debe estar referenciado en al menos un archivo de teoría o práctica
- Texto alternativo descriptivo siempre presente para accesibilidad

## Glosario (`5-glosario/README.md`)

```markdown
# Glosario — Semana XX

## A

### `Atributo`

Propiedad o característica que describe a una entidad. Equivale a una **columna** en el modelo relacional.

**Ejemplo:** La entidad `Customer` tiene atributos `name`, `email`, `birth_date`.

---

## C

### `Cardinalidad`

...
```

Reglas del glosario:

- Orden alfabético estricto
- Términos técnicos entre backticks en el título
- Definición en español, concisa (máximo 3 líneas)
- Ejemplo SQL o contextual cuando aporte valor
- Separador `---` entre entradas
