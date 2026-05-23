---
mode: agent
description: >
  Genera un diagrama ER completo (modelo conceptual y/o lógico) a partir de
  un enunciado de requerimientos. Produce DBML para dbdiagram.io y
  descripción textual del modelo conceptual.
---

# Generar Diagrama ER

Necesito diseñar el modelo de datos para el siguiente sistema:

## Enunciado

$DESCRIPCION_DEL_SISTEMA

## Nivel del diagrama requerido

$NIVEL (conceptual | lógico | físico | todos)

---

## Qué generar

### 1. Análisis de requerimientos

Antes de diagramar, identifica y lista:

- **Entidades principales** con justificación
- **Atributos clave** de cada entidad (tipo, restricciones)
- **Relaciones** entre entidades con cardinalidades (mínima y máxima)
- **Reglas de negocio** detectadas
- **Supuestos** asumidos (documéntalos)

### 2. Modelo Conceptual (si aplica)

Describe el diagrama ER en notación textual:

```
ENTIDAD: Customer
  Atributos: id (PK), full_name, email, phone (multivaluado), address (compuesto)
  Relaciones:
    - PLACES (1:N) → Order
    - HAS (0:N) → Address

ENTIDAD DÉBIL: OrderItem
  Llave discriminante: line_number
  Depende de: Order
```

### 3. Modelo Lógico en DBML (para dbdiagram.io)

Genera el DBML completo siguiendo estas reglas:

```dbml
// ============================================
// Modelo Lógico: [NOMBRE DEL SISTEMA]
// Versión: 1.0 | Fecha: [FECHA]
// ============================================

Table [tabla] {
  id          bigint      [pk, increment, note: "Clave primaria"]
  // ... columnas con tipos PostgreSQL
  created_at  timestamptz [not null, default: `now()`]

  indexes {
    // índices relevantes
  }
}

Ref: tabla1.fk_col > tabla2.id [delete: cascade]
```

Reglas DBML obligatorias:

- Usar tipos PostgreSQL reales (`varchar(n)`, `numeric(p,s)`, `timestamptz`, `boolean`, `uuid`, `jsonb`)
- Incluir `note:` en columnas que requieran explicación
- Documentar todas las relaciones con `Ref:` y política `delete`/`update`
- Agregar bloque `indexes {}` para FKs y columnas de búsqueda frecuente
- Incluir comentario de cabecera con nombre, versión y fecha

### 4. Script DDL PostgreSQL 16+

Genera el DDL equivalente listo para ejecutar:

- `GENERATED ALWAYS AS IDENTITY` para PKs
- `TIMESTAMPTZ` para fechas/horas
- Constraints nombrados explícitamente (`pk_`, `fk_`, `uq_`, `ck_`)
- `ON DELETE` y `ON UPDATE` en todas las FOREIGN KEY
- Comentarios educativos en español explicando decisiones de diseño

### 5. Decisiones de diseño

Para cada decisión no obvia, documenta:

- ¿Por qué se eligió esta cardinalidad?
- ¿Por qué esta tabla y no otra estructura?
- ¿Qué forma normal se alcanza y por qué?
- ¿Algún trade-off o alternativa considerada?

## Convenciones

- Tablas: `snake_case`, plural, en inglés
- Columnas: `snake_case`, singular, en inglés
- Todo diagrama debe ser coherente entre el nivel conceptual, lógico y físico
- Normalizar hasta 3FN como mínimo; documentar si se aplica desnormalización
