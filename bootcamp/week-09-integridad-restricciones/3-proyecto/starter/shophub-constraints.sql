-- ============================================================
-- PROYECTO SEMANA 09 — ShopHub: E-Commerce con Integridad Completa
-- ============================================================
-- Sistema:     ShopHub (plataforma de e-commerce)
-- Estudiante:  _______________________________________________
-- Fecha:       _______________________________________________
-- PostgreSQL:  16+
-- ============================================================
--
-- INSTRUCCIONES:
--   1. Lee el README.md del proyecto antes de comenzar.
--   2. Completa todos los bloques marcados con TODO.
--   3. Cada TODO incluye las constraints que debes agregar.
--   4. Al final del archivo hay una sección de pruebas para completar.
--   5. Ejecuta el script completo y verifica que no haya errores.
-- ============================================================

-- Crear esquema y establecer el search_path
CREATE SCHEMA IF NOT EXISTS shophub;
SET search_path = shophub;


-- ============================================================
-- SECCIÓN 1: CREACIÓN DE TABLAS (sin constraints — ya hecho)
-- No modifiques estas secciones. Solo agrega constraints abajo.
-- ============================================================

CREATE TABLE categories (
    category_id     UUID                    DEFAULT gen_random_uuid(),
    parent_id       UUID,
    category_name   VARCHAR(80)             NOT NULL,
    created_at      TIMESTAMPTZ             NOT NULL DEFAULT NOW()
);

CREATE TABLE products (
    product_id          UUID                DEFAULT gen_random_uuid(),
    category_id         UUID,
    product_name        VARCHAR(120)        NOT NULL,
    product_sku         VARCHAR(40)         NOT NULL,
    product_description TEXT,
    product_price       NUMERIC(10, 2)      NOT NULL,
    product_stock       INTEGER             NOT NULL DEFAULT 0,
    is_active           BOOLEAN             NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ         NOT NULL DEFAULT NOW()
);

CREATE TABLE customers (
    customer_id     UUID                    DEFAULT gen_random_uuid(),
    customer_name   VARCHAR(100)            NOT NULL,
    customer_email  VARCHAR(150)            NOT NULL,
    customer_phone  VARCHAR(20),
    created_at      TIMESTAMPTZ             NOT NULL DEFAULT NOW()
);

CREATE TABLE addresses (
    address_id      UUID                    DEFAULT gen_random_uuid(),
    customer_id     UUID                    NOT NULL,
    address_street  VARCHAR(200)            NOT NULL,
    address_city    VARCHAR(80)             NOT NULL,
    address_country CHAR(2)                 NOT NULL,
    is_default      BOOLEAN                 NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMPTZ             NOT NULL DEFAULT NOW()
);

CREATE TABLE orders (
    order_id            UUID                DEFAULT gen_random_uuid(),
    customer_id         UUID                NOT NULL,
    shipping_address_id UUID,
    order_status        VARCHAR(20)         NOT NULL DEFAULT 'pending',
    order_total         NUMERIC(12, 2)      NOT NULL DEFAULT 0,
    created_at          TIMESTAMPTZ         NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    order_item_id       UUID                DEFAULT gen_random_uuid(),
    order_id            UUID                NOT NULL,
    product_id          UUID                NOT NULL,
    order_item_quantity SMALLINT            NOT NULL,
    order_item_price    NUMERIC(10, 2)      NOT NULL
);

CREATE TABLE payments (
    payment_id      UUID                    DEFAULT gen_random_uuid(),
    order_id        UUID                    NOT NULL,
    payment_method  VARCHAR(20)             NOT NULL,
    payment_amount  NUMERIC(12, 2)          NOT NULL,
    payment_status  VARCHAR(20)             NOT NULL DEFAULT 'pending',
    paid_at         TIMESTAMPTZ
);


-- ============================================================
-- SECCIÓN 2: PRIMARY KEY CONSTRAINTS
-- ============================================================
-- TODO: Agregar PRIMARY KEY a cada tabla con nombre explícito.
-- Convención: pk_nombretabla
-- Ejemplo:
--   ALTER TABLE categories
--       ADD CONSTRAINT pk_categories PRIMARY KEY (category_id);

-- TODO pk_categories



-- TODO pk_products



-- TODO pk_customers



-- TODO pk_addresses



-- TODO pk_orders



-- TODO pk_order_items



-- TODO pk_payments




-- ============================================================
-- SECCIÓN 3: UNIQUE CONSTRAINTS
-- ============================================================
-- TODO: Agregar UNIQUE para las siguientes columnas.
-- Convención: uq_tabla_columna
--
-- · categories.category_name debe ser único en todo el catálogo
-- · products.product_sku debe ser único
-- · customers.customer_email debe ser único

-- TODO uq_categories_name



-- TODO uq_products_sku



-- TODO uq_customers_email




-- ============================================================
-- SECCIÓN 4: FOREIGN KEY CONSTRAINTS
-- ============================================================
-- TODO: Agregar FK con política ON DELETE.
-- Para cada FK, agrega un comentario con la justificación:
-- -- Razón: [por qué elegiste esa política]
-- Convención: fk_tablaHija_columna

-- categories.parent_id → categories.category_id
-- Política sugerida: RESTRICT (no borrar categoría con hijos)
-- TODO fk_categories_parent_id



-- products.category_id → categories.category_id
-- Política sugerida: RESTRICT (RF-01: no borrar categoría con productos)
-- TODO fk_products_category_id



-- addresses.customer_id → customers.customer_id
-- Política sugerida: CASCADE (RF-03: dirección sin cliente no tiene sentido)
-- TODO fk_addresses_customer_id



-- orders.customer_id → customers.customer_id
-- Política sugerida: RESTRICT (RF-04: no borrar cliente con pedidos)
-- TODO fk_orders_customer_id



-- orders.shipping_address_id → addresses.address_id
-- Política sugerida: SET NULL (RF-04: el pedido se conserva aunque la dirección cambie)
-- TODO fk_orders_shipping_address_id



-- order_items.order_id → orders.order_id
-- Política sugerida: CASCADE (RF-05: líneas sin pedido no tienen sentido)
-- TODO fk_order_items_order_id



-- order_items.product_id → products.product_id
-- Política sugerida: RESTRICT (RF-05: no borrar producto con pedidos)
-- TODO fk_order_items_product_id



-- payments.order_id → orders.order_id
-- Política sugerida: CASCADE (RF-06: pago sin pedido no tiene sentido)
-- TODO fk_payments_order_id




-- ============================================================
-- SECCIÓN 5: CHECK CONSTRAINTS
-- ============================================================
-- TODO: Agregar CHECK para cada regla de negocio.
-- Convención: ck_tabla_descripcion

-- products: precio > 0
-- TODO ck_products_price



-- products: stock >= 0
-- TODO ck_products_stock



-- orders: estado en conjunto válido ('pending','confirmed','shipped','delivered','cancelled')
-- TODO ck_orders_status



-- orders: total >= 0
-- TODO ck_orders_total



-- order_items: cantidad > 0
-- TODO ck_order_items_quantity



-- order_items: precio_unitario >= 0
-- TODO ck_order_items_price



-- payments: método en conjunto válido ('credit_card','debit_card','bank_transfer','cash')
-- TODO ck_payments_method



-- payments: monto > 0
-- TODO ck_payments_amount



-- payments: estado en conjunto válido ('pending','completed','failed','refunded')
-- TODO ck_payments_status



-- addresses: country_code = exactamente 2 caracteres en mayúsculas
-- TODO ck_addresses_country




-- ============================================================
-- SECCIÓN 6: ÍNDICES EN COLUMNAS FK
-- ============================================================
-- TODO: Crear un índice por cada FK del lado hijo.
-- PostgreSQL NO los crea automáticamente.
-- Convención: ix_tabla_columna

-- TODO ix_products_category_id



-- TODO ix_addresses_customer_id



-- TODO ix_orders_customer_id



-- TODO ix_orders_shipping_address_id



-- TODO ix_order_items_order_id



-- TODO ix_order_items_product_id



-- TODO ix_payments_order_id




-- ============================================================
-- SECCIÓN 7: DATOS DE PRUEBA
-- ============================================================
-- TODO A: Insertar al menos 3 filas válidas por tabla.
--         Las filas deben respetar todas las constraints definidas.

-- Ejemplo (categoría raíz):
-- INSERT INTO shophub.categories (category_name)
-- VALUES ('Electrónica');

-- Continúa con las demás tablas...



-- ============================================================
-- SECCIÓN 8: PRUEBAS DE VIOLACIÓN DE CONSTRAINTS
-- ============================================================
-- TODO B: Para cada constraint importante, escribe un INSERT
--         que lo viole y explica qué error esperas.
--
-- Formato:
-- -- PRUEBA: Describe qué constraint se viola
-- -- INSERT INTO ...
-- -- → ERROR esperado: mensaje del error

-- TODO: Violación de pk_products (duplicate key)


-- TODO: Violación de uq_products_sku (duplicate SKU)


-- TODO: Violación de fk_products_category_id (categoría inexistente)


-- TODO: Violación de ck_products_price (precio negativo)


-- TODO: Violación de ck_orders_status (estado inválido)


-- TODO: Violación de fk_orders_customer_id + RESTRICT (borrar cliente con pedidos)


-- TODO: Violación de ck_payments_amount (monto = 0)


-- ============================================================
-- FIN DEL SCRIPT
-- Recuerda ejecutar: pnpm run ... / psql -f shophub-constraints.sql
-- y verificar que todas las inserciones válidas funcionan
-- y todos los INSERTs de prueba fallan como se espera.
-- ============================================================
