---
applyTo: "**/*.dbml, bootcamp/**/0-assets/**"
---

# Convenciones de Diagramas — Bootcamp Diseño de Bases de Datos Relacionales

## Herramientas por nivel de modelo

| Nivel           | Herramienta  | Formato              | Cuándo usar                                                          |
| --------------- | ------------ | -------------------- | -------------------------------------------------------------------- |
| Conceptual (ER) | draw.io      | SVG exportado        | Entidades, relaciones, cardinalidades en notación Chen o Crow's Foot |
| Lógico          | dbdiagram.io | DBML + SVG exportado | Tablas, columnas, relaciones, tipos de datos                         |
| Físico          | dbdiagram.io | DBML + SVG exportado | DDL completo visualizado con índices y constraints                   |

---

## Convenciones DBML (dbdiagram.io)

### Estructura obligatoria de un archivo `.dbml`

```dbml
// ============================================
// [Nivel] del Modelo: [Nombre del Sistema]
// Semana: XX | Versión: 1.0 | Fecha: YYYY-MM-DD
// ============================================

// --- Grupo: [Nombre del módulo] ---

Table [nombre_tabla_plural] {
  id          bigint      [pk, increment, note: "Clave primaria"]
  [columna]   [tipo]      [not null, note: "Descripción del campo"]
  created_at  timestamptz [not null, default: `now()`]

  indexes {
    [columna_fk]    [name: "ix_tabla_columna"]
    [columna_busq]  [name: "ix_tabla_col_busqueda"]
  }

  Note: "Descripción del propósito de la tabla"
}

// Relaciones — siempre con política de delete/update
Ref: tabla_hijo.fk_col > tabla_padre.id [delete: cascade, update: cascade]
```

### Tipos de datos DBML — usar equivalentes PostgreSQL exactos

```dbml
// ✅ CORRECTO — tipos PostgreSQL reales
id          bigint
code        varchar(10)
description text
price       numeric(10,2)
is_active   boolean
created_at  timestamptz
birth_date  date
payload     jsonb
uid         uuid

// ❌ INCORRECTO — tipos genéricos o inexistentes en PostgreSQL
id          integer auto_increment
price       float
created_at  datetime
```

### Cardinalidades — notación de referencias

```dbml
// 1:N — el más común (un padre, muchos hijos)
Ref: orders.customer_id > customers.id   // muchos órdenes → un cliente

// 1:1
Ref: profiles.user_id - users.id         // un perfil ↔ un usuario

// M:N — siempre a través de tabla pivote
Ref: book_authors.book_id   > books.id
Ref: book_authors.author_id > authors.id
```

### Políticas de eliminación por tipo de relación

| Relación                           | `delete` recomendado | Justificación                               |
| ---------------------------------- | -------------------- | ------------------------------------------- |
| Hijos dependientes del padre       | `cascade`            | `OrderItem` sin `Order` no tiene sentido    |
| Referencia a entidad independiente | `restrict`           | No borrar `Product` si tiene ventas         |
| Auditoría / historial              | `set null`           | Mantener registro aunque se borre el origen |
| Relación obligatoria               | `no action`          | Forzar manejo explícito en la aplicación    |

---

## Convenciones SVG (assets visuales)

### Paleta de colores — obligatoria

```
Fondo principal:    #1e1e2e   (Catppuccin Mocha Base)
Fondo de tarjeta:   #313244   (Catppuccin Mocha Surface0)
Texto principal:    #cdd6f4   (Catppuccin Mocha Text)
Acento primario:    #89b4fa   (Catppuccin Mocha Blue — PostgreSQL)
Acento secundario:  #a6e3a1   (Catppuccin Mocha Green — éxito/correcto)
Acento error:       #f38ba8   (Catppuccin Mocha Red — anti-patrones)
Acento advertencia: #f9e2af   (Catppuccin Mocha Yellow — atención)
Borde/línea:        #45475a   (Catppuccin Mocha Surface2)
```

### Reglas de estilo SVG

- ❌ Sin degradés (gradients) — colores sólidos únicamente
- ✅ Bordes redondeados con `rx="6"` en rectángulos de tablas/entidades
- ✅ Fuentes sans-serif únicamente: `Inter`, `Roboto`, `system-ui`
- ✅ Tamaño mínimo de texto: 12px para etiquetas, 14px para títulos de tabla
- ✅ Líneas de relación con flechas claras y etiquetas de cardinalidad visibles
- ✅ Leyenda incluida cuando el diagrama use símbolos no estándar

### Nomenclatura de archivos SVG

| Tipo de asset            | Patrón de nombre              | Ejemplo                                 |
| ------------------------ | ----------------------------- | --------------------------------------- |
| Header de semana         | `week-XX-header.svg`          | `week-03-header.svg`                    |
| Diagrama ER conceptual   | `er-[sistema]-conceptual.svg` | `er-ecommerce-conceptual.svg`           |
| Modelo lógico            | `modelo-logico-[sistema].svg` | `modelo-logico-biblioteca.svg`          |
| Diagrama específico      | `[concepto]-diagram.svg`      | `normalizacion-2fn-diagram.svg`         |
| Comparativo (bueno/malo) | `[concepto]-antipatron.svg`   | `dependencia-transitiva-antipatron.svg` |

### Vinculación obligatoria

Todo archivo SVG en `0-assets/` **debe estar referenciado** en al menos un
archivo de teoría o práctica usando ruta relativa:

```markdown
![Diagrama del modelo conceptual de e-commerce](../0-assets/er-ecommerce-conceptual.svg)
```

---

## Diagramas de notación ER (draw.io)

### Notación Crow's Foot — estándar del bootcamp para modelo conceptual

```
Cardinalidades:
  |o  = cero o uno      (mínimo 0, máximo 1)
  ||  = exactamente uno  (mínimo 1, máximo 1)
  o{  = cero o muchos   (mínimo 0, máximo N)
  |{  = uno o muchos    (mínimo 1, máximo N)

Ejemplo:
  CUSTOMER ||--o{ ORDER  →  un cliente tiene cero o muchos pedidos
  ORDER    ||--|{ ORDER_ITEM  →  un pedido tiene uno o muchos ítems
```

### Colores de entidades por tipo (draw.io)

| Tipo de entidad     | Color de fondo       | Uso                                   |
| ------------------- | -------------------- | ------------------------------------- |
| Entidad fuerte      | `#89b4fa` (azul)     | Entidades principales del dominio     |
| Entidad débil       | `#cba6f7` (morado)   | Dependen de otra entidad para existir |
| Entidad asociativa  | `#a6e3a1` (verde)    | Tablas pivote en relaciones M:N       |
| Entidad de catálogo | `#f9e2af` (amarillo) | Tablas de referencia / lookups        |
