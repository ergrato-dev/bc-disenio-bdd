# Proyecto Semana 13 — ContentHub

**Sistema de gestión de contenido (CMS) con soft delete, categorías jerárquicas y auditoría completa**

> **Fase:** Diseño Avanzado &nbsp;|&nbsp; **Semana:** 13 de 14

---

## Contexto del Negocio

**ContentHub** es una plataforma SaaS de gestión de contenido usada por múltiples
empresas (tenants). Cada empresa publica artículos en su sitio web, organizados
en categorías jerárquicas. El equipo de operaciones exige trazabilidad completa
de los cambios en los artículos y la capacidad de recuperar cualquier versión
anterior del contenido.

### Actores del sistema

| Actor | Rol |
|-------|-----|
| **Tenant** | Empresa suscripta a ContentHub (ej. TechBlog S.A.) |
| **Author** | Usuario que redacta y publica artículos |
| **Admin** | Usuario que administra categorías y tenants |

### Reglas de negocio clave

- Cada artículo pertenece a exactamente un tenant y una categoría.
- Un artículo eliminado **nunca se borra físicamente**: se marca como eliminado
  con `deleted_at` para conservar el historial.
- Cada cambio en un artículo (título, contenido, estado) queda registrado
  automáticamente en una tabla de historia.
- Las categorías forman una jerarquía en árbol (ej. _Tecnología → Software → PostgreSQL_).
- La plataforma implementa multi-tenancy mediante columna `tenant_id` + Row Level Security.

---

## Requerimientos Funcionales

### RF-01 — Soft delete en artículos

Los artículos eliminados deben mantener `deleted_at TIMESTAMPTZ` no nulo.
La aplicación solo trabaja con la vista `vw_active_articles`, que filtra
automáticamente los artículos eliminados. El slug de un artículo activo
debe ser único por tenant; un artículo eliminado puede liberar su slug
para que otro artículo lo reutilice.

### RF-02 — Categorías jerárquicas

Las categorías se modelan con **adjacency list** (`parent_id` auto-referencia).
Debe existir una consulta con `WITH RECURSIVE` que dado el `article_id`,
devuelva el breadcrumb completo de la categoría del artículo
(ej. `Tecnología → Software → PostgreSQL`).

### RF-03 — Historial completo de artículos

Toda operación INSERT, UPDATE o DELETE sobre `articles` debe quedar
registrada en `articles_history` con:
- Tipo de operación (`INSERT`, `UPDATE`, `DELETE`)
- Timestamp del cambio
- Usuario que realizó el cambio (leído de `current_setting('app.current_user_id')`)
- Copia de todos los valores de la fila (estado al momento del cambio)

### RF-04 — Auditoría de autoría con trigger

Las tablas `articles`, `categories` y `tenants` deben mantener
`created_by UUID` y `updated_by UUID` (FK a `authors`).
Un trigger `BEFORE UPDATE` debe asignar automáticamente
`updated_at = NOW()` y leer `updated_by` desde
`current_setting('app.current_user_id', true)::UUID`.

### RF-05 — Multi-tenancy con Row Level Security

Todas las tablas principales incluyen `tenant_id UUID NOT NULL`.
La tabla `articles` y la tabla `categories` deben tener RLS habilitado.
La política filtra las filas por `tenant_id = current_setting('app.tenant_id')::UUID`.

---

## Modelo de Datos (estructura esperada)

```
tenants          (tenant_id, tenant_name, tenant_slug, ...)
authors          (author_id, tenant_id, author_name, author_email, ...)
categories       (category_id, tenant_id, parent_id, category_name, ...)  ← jerarquía
articles         (article_id, tenant_id, author_id, category_id,
                  article_title, article_slug, article_content,
                  article_status, published_at, deleted_at, ...)
articles_history (history_id, history_operation, history_changed_at,
                  history_changed_by, [todas las columnas de articles])
```

---

## Instrucciones de Entrega

1. Abre el archivo `starter/contenthub-patrones.sql`
2. Lee cada bloque `-- TODO:` y completa el código SQL
3. Ejecuta el script completo en PostgreSQL 16+ verificando que no haya errores
4. Asegúrate de que las consultas de verificación al final devuelvan resultados coherentes

### Checklist de aceptación

- [ ] El script ejecuta sin errores en PostgreSQL 16+
- [ ] La vista `vw_active_articles` solo muestra artículos con `deleted_at IS NULL`
- [ ] El índice parcial permite reusar un slug tras un soft delete
- [ ] El trigger inserta correctamente en `articles_history` en INSERT, UPDATE y DELETE
- [ ] La CTE recursiva devuelve el breadcrumb correcto para al menos 3 niveles
- [ ] La política RLS filtra correctamente según `app.tenant_id`
- [ ] Todas las FK tienen `ON DELETE` explícito
- [ ] Los nombres de constraints siguen la convención `tipo_tabla_columna`

---

## Referencias

- [Teoría — Soft Delete](../1-teoria/01-soft-delete.md)
- [Teoría — Auditoría e Historia](../1-teoria/02-auditoria-historia.md)
- [Teoría — Jerarquías y Multi-Tenancy](../1-teoria/03-jerarquias-multi-tenancy.md)
- [Práctica guiada — ShopHub con patrones](../2-practicas/README.md)
- [PostgreSQL 16 — Row Security Policies](https://www.postgresql.org/docs/16/ddl-rowsecurity.html)
- [PostgreSQL 16 — WITH Queries (CTE)](https://www.postgresql.org/docs/16/queries-with.html)

---

← [Prácticas de la Semana](../2-practicas/README.md) | → [README de la Semana](../README.md)
