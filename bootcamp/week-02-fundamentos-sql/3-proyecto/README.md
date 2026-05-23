# Proyecto Semana 02 — MercaData: Respondiendo preguntas de negocio con SQL

> **Fase:** Fundamentos &nbsp;|&nbsp; **Semana:** 02 de 14

## 📋 Contexto del Negocio

**MercaData** es una tienda de comercio electrónico latinoamericana que vende
productos electrónicos, libros y artículos del hogar. La empresa opera en
México, Colombia, Argentina y Perú, y tiene más de 3 años de historial de ventas.

El equipo de producto ha pedido un primer análisis exploratorio de sus datos.
No tienen un analista de datos dedicado, y el CTO les ha dado acceso a la base
de datos PostgreSQL de producción con la instrucción: **"respondan estas 10
preguntas con SQL documentado".**

Tu misión es construir las consultas SQL que respondan cada pregunta de negocio
de forma clara, eficiente y bien documentada.

## 🎯 Objetivo

Aplicar SELECT, JOINs, NULL, funciones de agregación y GROUP BY para extraer
información de valor a partir de un modelo de datos de e-commerce con 5 tablas.

## 🗺️ Modelo de datos

```
categories ←── products ←── order_items ──→ orders ──→ customers
```

| Tabla | Descripción |
|-------|-------------|
| `categories` | Categorías de productos (Electrónica, Libros, Hogar) |
| `products` | Catálogo de productos con precio y stock |
| `customers` | Clientes registrados con ciudad y país |
| `orders` | Cabecera de pedidos (cliente, fecha, estado) |
| `order_items` | Líneas de pedido (producto, cantidad, precio unitario) |

## ❓ Las 10 preguntas de negocio

| # | Pregunta | Conceptos |
|---|----------|-----------|
| 1 | ¿Cuántos productos hay en cada categoría? | GROUP BY, COUNT |
| 2 | ¿Cuáles son los 5 productos más vendidos por unidades? | JOIN, GROUP BY, ORDER BY, LIMIT |
| 3 | ¿Qué clientes no han realizado ningún pedido? | LEFT JOIN, IS NULL |
| 4 | ¿Cuál es el ingreso total por mes en 2026? | GROUP BY, SUM, funciones de fecha |
| 5 | ¿Qué productos tienen stock menor a 5 unidades? | WHERE, ORDER BY |
| 6 | ¿Cuál es el ticket promedio por pedido? | JOIN, AVG, ROUND |
| 7 | ¿Qué países generan más ingresos? | JOIN, GROUP BY, ORDER BY |
| 8 | ¿Cuántos pedidos hay en cada estado? | GROUP BY, COUNT |
| 9 | ¿Qué categorías no tienen ninguna venta registrada? | LEFT JOIN, HAVING |
| 10 | ¿Cuál es el top 3 de clientes por monto total comprado? | JOIN, GROUP BY, ORDER BY, LIMIT |

## 📦 Entregables

- [ ] `starter/mercadata.sql` completado: las 10 consultas funcionando en PostgreSQL 16+
- [ ] Cada consulta tiene un comentario explicando la lógica y el resultado esperado

## 🚀 Instrucciones

1. Abre el archivo `starter/mercadata.sql`
2. Lee el contexto de cada sección — el esquema ya está creado y los datos ya están cargados
3. Completa cada `-- TODO:` con la consulta SQL correcta
4. Verifica que tu consulta devuelve los resultados esperados (indicados en los comentarios)
5. Asegúrate de que cada consulta tiene un comentario explicando su lógica

## ✅ Criterios de Aceptación

- [ ] Las 10 consultas ejecutan sin errores en PostgreSQL 16+
- [ ] Cada consulta responde con exactitud la pregunta planteada
- [ ] Los alias de columnas son descriptivos (en español)
- [ ] Cada consulta tiene comentario explicando la lógica

## 🔗 Referencias

- [Semana 02 — Teoría](../1-teoria/)
- [Semana 02 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)

