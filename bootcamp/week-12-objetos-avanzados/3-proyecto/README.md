# Proyecto Semana 12 — ShopHub: Capa de Objetos Avanzados

## Contexto de Negocio

**ShopHub** es una plataforma de e-commerce en crecimiento. El equipo de
ingeniería ya diseñó el modelo de datos (Semana 10) y lo optimizó con
índices (Semana 11). Ahora necesitan construir la **capa de objetos
avanzados** que hará al sistema más robusto, observable y fácil de mantener:

- **Vistas** para simplificar el acceso de los equipos de datos y soporte
- **Funciones** para encapsular cálculos y validaciones reutilizables
- **Triggers** para garantizar la integridad sin depender de la aplicación
- **Procedimientos** para orquestar operaciones multi-paso con transacciones
- **Auditoría** automática para cumplir los requisitos del negocio

## Requerimientos Funcionales

### RF-01 — Auditoría Automática

Toda modificación en `orders` y `products` debe quedar registrada
automáticamente en una tabla de auditoría con: tabla afectada, operación
(`INSERT`/`UPDATE`/`DELETE`), estado previo (JSONB), estado nuevo (JSONB),
usuario de BD y timestamp.

### RF-02 — Vistas para el Equipo de Datos

- `vw_product_catalog`: productos activos con nombre de categoría (si existe)
  y stock actual
- `vw_customer_order_summary`: por cliente, total de órdenes, revenue total,
  promedio por orden y fecha de última compra
- `vw_low_stock`: productos con `product_stock < 10` y al menos una venta
  registrada
- `mvw_monthly_revenue`: **vista materializada** con revenue mensual total,
  número de órdenes y clientes únicos (solo órdenes en estado `delivered`)

### RF-03 — Funciones de Negocio

- `fn_apply_discount(p_product_id UUID, p_pct NUMERIC)`: devuelve el precio
  con descuento aplicado; valida que el porcentaje esté entre 0 y 100
- `fn_get_customer_stats(p_customer_id UUID)`: retorna una tabla con
  métricas del cliente (total órdenes, total gastado, promedio, primera y
  última compra)
- `fn_validate_stock(p_product_id UUID, p_qty INT)`: devuelve `TRUE` si hay
  suficiente stock para la cantidad solicitada, `FALSE` en caso contrario

### RF-04 — Triggers de Integridad

- `trg_products_before_update`: antes de actualizar un producto, verificar
  que el nuevo `product_price` no sea negativo; si lo es, lanzar excepción
- `trg_orders_after_insert`: después de crear una orden, insertar un
  registro de auditoría con el estado inicial

### RF-05 — Procedimiento para Completar Pedidos

`sp_complete_order(p_order_id UUID)`: orquesta el cierre completo de una
orden. Dentro de la misma transacción:
1. Cambia `order_status` a `'delivered'`
2. Descuenta el stock de cada producto en los `order_items`
3. Recalcula y persiste `order_total` usando `fn_calculate_order_total`
4. Si falla el descuento de stock (stock insuficiente), hace rollback de
   toda la operación

### RF-06 — Test de Transacción

Demostrar el uso de `SAVEPOINT` en el flujo de creación de una orden:
intentar aplicar un cupón (que puede fallar), y si falla, usar
`ROLLBACK TO SAVEPOINT` para deshacer solo la parte del cupón sin perder
la orden ya creada.

---

## Entregables

Al finalizar el proyecto debes tener:

1. `starter/shophub-advanced-objects.sql` con **todos los TODOs completados**
2. Evidencia de que los scripts ejecutan sin errores en PostgreSQL 16+
3. Capturas o texto de las consultas de verificación al final del script

---

← [Semana 11](../../week-11-indices-optimizacion/README.md) | → [Semana 13](../../week-13-patrones-diseno/README.md)
