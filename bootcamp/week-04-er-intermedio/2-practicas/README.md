# Práctica — Modelado ER Intermedio: Sistema de Facturación InvoiceFlow

> **Duración estimada:** ~3 horas  
> **Herramienta:** draw.io (app.diagrams.net) + este documento  
> **Entregable:** Análisis documentado + diagrama ER con entidades débiles y multivaluados

**InvoiceFlow** es una plataforma SaaS de facturación para pequeñas y medianas empresas.
En esta práctica modelaremos su dominio aplicando los tres conceptos de la semana:
atributos multivaluados, entidades débiles y —como bonus— una relación con entidad asociativa.

---

## Descripción del negocio

> **InvoiceFlow** permite a múltiples empresas emitir facturas a sus clientes. Cada
> empresa tiene un nombre, NIT (identificador fiscal único), dirección (calle, ciudad,
> país), correo electrónico y una lista de teléfonos de contacto (puede tener más de uno).
>
> Los clientes son personas o empresas que compran a los emisores. Cada cliente tiene
> nombre, correo, país y teléfono. Un cliente puede ser cliente de varias empresas del sistema.
>
> Una factura es emitida por exactamente una empresa a exactamente un cliente. Tiene un
> número de factura que **solo es único dentro de la empresa que la emite** (la empresa
> A puede tener la factura "FAC-001" y la empresa B también puede tenerla). La factura
> registra la fecha de emisión, fecha de vencimiento, estado (borrador, emitida, pagada,
> anulada) y el total.
>
> Cada factura tiene una o más líneas de detalle. Cada línea tiene un número de ítem
> secuencial dentro de la factura (ítem 1, 2, 3…), la descripción del producto o
> servicio, la cantidad y el precio unitario. El subtotal de la línea es calculado.
>
> Los productos/servicios que una empresa puede facturar tienen un código, nombre,
> precio estándar y una lista de categorías (un producto puede estar en varias).

---

## Paso 1 — Identificar entidades

Lee el texto y completa el análisis:

| Sustantivo | ¿Entidad? | Justificación |
|------------|-----------|---------------|
| Empresa | ✅ Sí | Emisora de facturas; tiene múltiples atributos y relaciones propias |
| Cliente | ✅ Sí | Receptor de facturas; independiente de la empresa |
| Factura | ✅ Sí | Evento central del sistema con atributos propios |
| Línea de factura | ✅ Sí — **entidad débil** | Su número solo tiene sentido dentro de su factura |
| Producto / servicio | ✅ Sí | Tiene código, nombre, precio y categorías |
| Categoría | ⚖️ Depende | Ver decisión de diseño en Paso 3 |
| Teléfono | ❌ No es entidad | **Atributo multivaluado** de EMPRESA y CLIENTE |
| NIT, correo, dirección | ❌ No | Atributos de EMPRESA |
| Número de factura | ❌ No | Clave parcial de FACTURA (entidad débil respecto a EMPRESA) |

> **Decisión sobre FACTURA:** ¿Es realmente una entidad débil de EMPRESA?  
> Sí: el número de factura `FAC-001` solo identifica una factura *dentro de la empresa*.
> Sin saber la empresa, el número es ambiguo. → Clave = `(empresa_id + numero_factura)`.

### Entidades resultantes

`COMPANY` · `CLIENT` · `INVOICE` (débil respecto a COMPANY) · `INVOICE_LINE` (débil respecto a INVOICE) · `PRODUCT`

---

## Paso 2 — Atributos multivaluados

El enunciado menciona dos atributos multivaluados:

### COMPANY: `phone_numbers`

Una empresa puede tener uno o más teléfonos. → Tabla separada.

| Columna | Tipo | Nota |
|---------|------|------|
| `company_id` | FK + PK | Referencia a COMPANY |
| `phone` | `varchar(20)` + PK | Número de teléfono |

```sql
-- PRIMARY KEY (company_id, phone)
-- ON DELETE CASCADE — si se borra la empresa, se borran sus teléfonos
```

### PRODUCT: `categories`

Un producto puede pertenecer a varias categorías. Ver Paso 3 para la decisión.

---

## Paso 3 — Decisión: CATEGORY como atributo multivaluado o entidad propia

| Pregunta | Respuesta para InvoiceFlow |
|----------|---------------------------|
| ¿Las categorías tienen atributos propios (descripción, imagen)? | El enunciado no lo dice — asumimos que solo es un nombre |
| ¿Otras entidades referencian las categorías? | No en este dominio |
| ¿Necesitamos filtrar/buscar productos por categoría? | Sí — "mostrar todos los productos de la categoría 'Servicios'" |
| ¿El conjunto de categorías es abierto o cerrado? | Abierto — el usuario crea sus categorías |

**Decisión:** Como las categorías son creadas por el usuario (conjunto abierto) y
necesitamos buscar por ellas, las modelamos como **tabla separada** (atributo multivaluado
→ tabla `product_categories`). No como entidad propia completa ya que no tienen
atributos adicionales en este dominio.

```sql
CREATE TABLE product_categories (
    product_id  BIGINT      NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    category    VARCHAR(60) NOT NULL,
    PRIMARY KEY (product_id, category)
);
```

> **Si el negocio creciera** y las categorías tuvieran descripción, imagen y jerarquía
> (subcategorías), se promoverían a entidad propia `CATEGORY`. Este es el tipo de
> decisión que se documenta en la hoja de análisis.

---

## Paso 4 — Relaciones y cardinalidades (análisis guiado)

### Entidades débiles: relaciones de identificación

| Relación | Símbolo lado fuerte | Símbolo lado débil | Justificación |
|----------|--------------------|--------------------|---------------|
| COMPANY ─── INVOICE | `\|\|` (exactamente una) | `\|<` (una o muchas) | Una factura pertenece a exactamente una empresa. Una empresa puede tener muchas facturas. |
| INVOICE ─── INVOICE_LINE | `\|\|` (exactamente una) | `\|<` (una o muchas) | Una línea pertenece a exactamente una factura. Una factura tiene una o más líneas. |

> **Participación en INVOICE_LINE:** `|<` (uno o muchos) porque una factura debe tener
> al menos una línea para ser válida. Si el negocio permitiera facturas vacías en borrador,
> usaríamos `○<` (cero o muchos).

### Relaciones regulares

| Relación | Cardinalidad | Notación CF | Justificación |
|----------|-------------|-------------|---------------|
| COMPANY ─── CLIENT | N:M | `○<──○<` | Una empresa factura a muchos clientes; un cliente puede recibir facturas de múltiples empresas. La relación no tiene atributos propios aquí → tabla pivote simple `company_clients`. |
| INVOICE ─── CLIENT | N:1 | `\|\|──○<` | Una factura es emitida a exactamente un cliente. Un cliente puede tener cero o muchas facturas. |
| INVOICE_LINE ─── PRODUCT | N:1 | `\|\|──○<` | Una línea describe exactamente un producto. Un producto puede aparecer en cero o muchas líneas. |

---

## Paso 5 — Diagrama completo en draw.io

### Diagrama de entidades a representar

```
COMPANY ─────||──── |< ───── INVOICE ─────||──── |< ───── INVOICE_LINE
  |                              |                                |
  | (multivaluado)               ||                              ||
  |                              |                               |
phone_numbers              CLIENT (o<)                    PRODUCT (o<)
                                                               |
                                                     (multivaluado: o<)
                                                        product_categories
```

### Instrucciones draw.io

1. Abre **[app.diagrams.net](https://app.diagrams.net)**
2. Activa la biblioteca **"Entity Relation"**
3. Dibuja las 5 entidades principales: COMPANY, INVOICE, INVOICE_LINE, CLIENT, PRODUCT
4. Agrega las 2 "tablas de multivaluados" como entidades: `company_phones`, `product_categories`
5. Conecta con las cardinalidades de la tabla del Paso 4
6. **Para las entidades débiles:** anota en los atributos cuál es la clave parcial
7. Etiqueta todas las relaciones con un verbo

### Verificación

Comprueba que tu diagrama cumple:

- [ ] INVOICE tiene atributo `numero_factura` marcado como clave parcial (no clave primaria sola)
- [ ] INVOICE_LINE tiene atributo `item_number` marcado como clave parcial
- [ ] La relación COMPANY ─── INVOICE tiene `||` en el lado de COMPANY
- [ ] La relación INVOICE ─── INVOICE_LINE tiene `||` en el lado de INVOICE
- [ ] `company_phones` y `product_categories` están conectadas con `||──|<`
- [ ] La relación COMPANY ─── CLIENT es N:M (con tabla pivote)
- [ ] Los atributos `subtotal` de INVOICE_LINE están marcados como derivados

---

## Paso 6 — Preguntas de reflexión

1. El enunciado dice que FACTURA tiene un `total`. ¿Debería almacenarse o calcularse
   como la suma de todos los `subtotales` de sus líneas? ¿Qué problemas puede causar
   almacenarlo? ¿Y no almacenarlo?

2. La relación COMPANY ─── CLIENT: ¿cambiaría a 1:N si InvoiceFlow decidiera que
   cada cliente solo puede pertenecer a una empresa del sistema? ¿Qué implicaciones
   tiene para el diseño?

3. Hemos dicho que `subtotal` en INVOICE_LINE es derivado (`cantidad × precio_unitario`).
   Pero en la práctica, ¿por qué muchos sistemas lo almacenan igualmente? Pista: piensa
   en descuentos, impuestos aplicados en el momento de la factura.

4. Si InvoiceFlow decidiera guardar un historial de cambios de estado de cada factura
   (con timestamp y usuario que hizo el cambio), ¿qué entidad nueva aparecería? ¿Sería
   débil o fuerte? ¿Entidad asociativa?

---

← [03 — Relaciones Ternarias](../1-teoria/03-relaciones-ternarias.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Proyecto →](../3-proyecto/README.md)
