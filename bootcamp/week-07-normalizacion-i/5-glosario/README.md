# Glosario — Semana 07: Normalización I

Términos clave de dependencias funcionales, 1FN y 2FN, ordenados alfabéticamente.

---

## A

### Anomalía de actualización (`update anomaly`)

Problema que ocurre cuando un dato redundante debe actualizarse en múltiples filas.
Si se actualiza en unas filas pero no en otras, la base de datos queda inconsistente.

**Ejemplo:** En `orders_raw`, cambiar el email de Ana López requiere actualizar
todas las filas donde aparece su `order_id`. Si se olvida alguna, hay inconsistencia.

---

### Anomalía de borrado (`delete anomaly`)

Pérdida involuntaria de información al eliminar una fila. Ocurre cuando una fila
mezcla datos de dos entidades distintas.

**Ejemplo:** Si `orders_raw` solo tiene un pedido del producto "SQL Avanzado" y se
elimina ese pedido, también se pierde la información del producto.

---

### Anomalía de inserción (`insertion anomaly`)

Imposibilidad de insertar datos de una entidad sin insertar datos de otra entidad
relacionada.

**Ejemplo:** En `orders_raw` no se puede registrar un producto nuevo sin que exista
un pedido que lo contenga, porque la PK es `{order_id, product_id}`.

---

### Atómico (`atomic`)

Un valor es atómico cuando no puede descomponerse en partes más pequeñas con
significado para la base de datos. Es el requisito central de la 1FN.

**Ejemplo atómico:** `phone_number = '555-1234'` ✅  
**Ejemplo no atómico:** `customer_phones = '555-1234, 555-5678'` ❌

---

### Axiomas de Armstrong

Conjunto de tres reglas de inferencia que permiten derivar todas las dependencias
funcionales válidas a partir de un conjunto inicial:

- **Reflexividad:** Si Y ⊆ X, entonces X → Y
- **Aumento:** Si X → Y, entonces XZ → YZ
- **Transitividad:** Si X → Y e Y → Z, entonces X → Z

A partir de estos tres se derivan reglas adicionales (unión, descomposición, pseudotransitividad).

---

## C

### Cierre de atributos (`attribute closure`, X⁺)

Conjunto de todos los atributos que pueden determinarse a partir de X usando las
dependencias funcionales conocidas.

**Ejemplo:** Dado `order_id → customer_id, order_date` y `customer_id → customer_name`:  
`{order_id}⁺ = {order_id, customer_id, order_date, customer_name}`

---

### Clave candidata (`candidate key`)

Subconjunto mínimo de atributos que determina funcionalmente todos los demás
atributos de la relación. Puede haber más de una por tabla.

**Ejemplo en `customers`:** Tanto `customer_id` como `customer_email` son claves
candidatas (ambas identifican unívocamente a un cliente).

---

## D

### Dependencia funcional (`functional dependency`, FD)

Relación semántica X → Y entre conjuntos de atributos donde, para cualquier dos
tuplas con el mismo valor de X, siempre tienen el mismo valor de Y.

Se lee "X determina Y" o "Y depende funcionalmente de X".

**Ejemplo:** `product_id → product_name` (mismo product_id → siempre mismo nombre)

---

### Dependencia funcional completa (`full functional dependency`)

Una FD X → Y donde Y depende de TODO el conjunto X, no de un subconjunto propio.

**Ejemplo:** `{order_id, product_id} → quantity` es completa: sin alguno de los
dos elementos de la PK compuesta, no se puede determinar la cantidad.

---

### Dependencia funcional parcial (`partial functional dependency`)

Una FD X → Y donde Y depende de un subconjunto propio de X (cuando X es una clave
compuesta). Viola la Segunda Forma Normal.

**Ejemplo:** `{order_id, product_id} → customer_name` es parcial porque
`order_id → customer_name` ya es suficiente.

---

### Dependencia funcional transitiva (`transitive functional dependency`)

Una cadena A → B → C donde B no es una superclave. Viola la Tercera Forma Normal.

**Ejemplo:** `order_id → customer_id → customer_name` (cuando `customer_id`
no es la PK de la tabla `orders`).

---

### Dependencia funcional trivial (`trivial functional dependency`)

Una FD X → Y donde Y ⊆ X. Siempre es verdadera y no aporta información adicional.

**Ejemplo:** `{customer_id, customer_name} → customer_id` es trivial.

---

### Determinante (`determinant`)

El lado izquierdo (X) de una dependencia funcional X → Y. Es el atributo o
conjunto de atributos que determina al otro.

---

## F

### Forma Normal (`Normal Form`, NF)

Nivel de organización de una relación que garantiza la ausencia de ciertos tipos
de redundancia o anomalías. Las principales son 1FN, 2FN, 3FN, FNBC, 4FN y 5FN.
Cada forma normal incluye todos los requisitos de las anteriores.

---

## G

### Grupo repetitivo (`repeating group`)

Conjunto de columnas con el mismo significado que se repiten con numeración
(e.g., `tag_1`, `tag_2`, `tag_3`). Viola la Primera Forma Normal.

**Solución:** Crear una tabla separada con una fila por valor, enlazada por FK.

---

## N

### Normalización (`normalization`)

Proceso de organizar los atributos y tablas de una base de datos relacional para
minimizar la redundancia de datos y las anomalías de inserción, actualización y
borrado. Se realiza aplicando formas normales de manera progresiva.

---

## P

### Primera Forma Normal (1FN) — `First Normal Form`

Una relación está en 1FN cuando:

1. Todos los valores son atómicos (no multivaluados, no compuestos)
2. No hay grupos repetitivos (columnas numeradas para el mismo concepto)
3. Existe una clave primaria definida

---

## S

### Segunda Forma Normal (2FN) — `Second Normal Form`

Una relación está en 2FN cuando está en 1FN y no existen dependencias parciales
de ningún atributo no-clave sobre la clave primaria. Solo aplica cuando la PK
es compuesta.

---

### Superclave (`superkey`)

Cualquier conjunto de atributos que identifica unívocamente las filas de una
relación. Una clave candidata es la superclave mínima (sin atributos superfluos).

---

## U

### Universo de Atributos (`attribute universe`)

Conjunto completo de todos los atributos de una relación. Se usa en la notación
formal del cierre de atributos y en el algoritmo de determinación de claves candidatas.

---

← [README semana](../README.md)

*Última actualización: Semana 07 · Modelo Lógico*
