# Proyecto Semana 09 — ShopHub: E-Commerce con Integridad Completa

## Contexto de Negocio

**ShopHub** es una plataforma de e-commerce que conecta vendedores con
compradores. El equipo de backend ya implementó la lógica de negocio en la
API, pero la base de datos no tiene restricciones de integridad declaradas.
Han tenido varios incidentes:

- Productos con precio negativo (`-5.00`) que aparecen como "ofertas"
- Pedidos que referencian clientes eliminados
- Líneas de pedido con cantidad `0` que confunden al sistema de inventario
- Estados de pago con valores arbitrarios (`'procesando'`, `'PAGADO'`, `'ok'`)

Tu tarea es **añadir todos los constraints** al esquema existente para que
la base de datos rechace estos datos inválidos antes de que lleguen a la API.

---

## Esquema de ShopHub

```
categories (self-referenciante)
    └── products
            └── order_items ──→ orders ──→ customers
                                              └── addresses
payments ──────────────────→ orders
```

### Tablas (sin constraints — ya creadas en starter/)

```sql
-- categories: jerarquía de categorías (hasta 3 niveles)
-- products: catálogo de productos
-- customers: compradores registrados
-- addresses: direcciones de envío de los clientes
-- orders: pedidos realizados
-- order_items: líneas de cada pedido
-- payments: pagos asociados a pedidos
```

---

## Requerimientos Funcionales

### RF-01: Integridad de Categorías

- Cada categoría tiene un nombre único en todo el catálogo
- Una categoría puede tener una categoría padre (auto-referencia)
- No se puede eliminar una categoría que tiene sub-categorías o productos

### RF-02: Integridad de Productos

- Cada producto tiene un SKU único
- El precio debe ser mayor a cero
- El stock no puede ser negativo
- Todo producto debe pertenecer a una categoría existente

### RF-03: Integridad de Clientes y Direcciones

- El email de un cliente es único en el sistema
- Si se elimina un cliente, sus direcciones se eliminan en cascada
- Cada dirección tiene un código de país ISO de 2 letras

### RF-04: Integridad de Pedidos

- Todo pedido debe referenciar un cliente existente (no borrar cliente con pedidos)
- El estado del pedido es uno de: `pending`, `confirmed`, `shipped`, `delivered`, `cancelled`
- El total del pedido no puede ser negativo
- La dirección de envío puede quedar en NULL si se elimina (cliente actualizó dirección)

### RF-05: Integridad de Líneas de Pedido

- Cada línea referencia un pedido existente (si se borra el pedido, borra sus líneas)
- Cada línea referencia un producto existente (no borrar producto con pedidos)
- La cantidad debe ser mayor a cero
- El precio unitario registrado no puede ser negativo

### RF-06: Integridad de Pagos

- Cada pago referencia un pedido existente (si se borra el pedido, borra sus pagos)
- El método de pago es uno de: `credit_card`, `debit_card`, `bank_transfer`, `cash`
- El monto del pago debe ser mayor a cero
- El estado del pago es uno de: `pending`, `completed`, `failed`, `refunded`

---

## Entregables

### 1. Script DDL completo (`starter/shophub-constraints.sql`)

El archivo `starter/shophub-constraints.sql` contiene las tablas creadas
sin constraints. Debes completar:

- Todos los `PRIMARY KEY` con nombre explícito (`pk_*`)
- Todos los `FOREIGN KEY` con política `ON DELETE` documentada (`fk_*`)
- Todos los `UNIQUE` necesarios (`uq_*`)
- Todos los `CHECK` para validaciones de dominio (`ck_*`)
- Todos los índices en columnas FK (`ix_*`)

### 2. Script de pruebas

Al final del archivo, escribe una sección de pruebas con:

- Al menos 3 inserts válidos por tabla
- Al menos 1 insert que viole cada constraint definido
- Comentario explicando qué constraint debe activarse

### 3. Diagrama de integridad (opcional, +10 puntos extra)

Crea en dbdiagram.io el modelo DBML de ShopHub con todas las relaciones
y exporta el PNG. Colócalo en `../0-assets/` como `05-shophub-modelo.png`.

---

## Criterios de Evaluación

| Criterio                                           | Puntos |
|----------------------------------------------------|--------|
| PKs nombradas correctamente para las 7 tablas      | 14     |
| FKs con política ON DELETE justificada en comentario | 20   |
| UNIQUEs para email, SKU, nombre categoría          | 9      |
| CHECKs para precios, cantidades, estados           | 24     |
| Índices en todas las columnas FK                   | 13     |
| Script de pruebas con violaciones por constraint   | 20     |
| **Total**                                          | **100**|

---

← [Práctica](../2-practicas/README.md) | → [README de la Semana](../README.md)
- [ ] RF-02:
- [ ] RF-03:

### Restricciones de diseño

- [ ] Aplicar las convenciones de nomenclatura del bootcamp
- [ ] Normalizar hasta mínimo 3FN (salvo justificación documentada)
- [ ] Todas las `FOREIGN KEY` deben tener política `ON DELETE` explícita

## 📦 Entregables

- [ ] Script DDL con todas las constraints nombradas explícitamente
- [ ] Pruebas de integridad: scripts que violan y respetan cada constraint

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

- [Semana 09 — Teoría](../1-teoria/)
- [Semana 09 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)
