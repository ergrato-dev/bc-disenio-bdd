# Glosario — Semana 08: Normalización II

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

## A

**Anomalía residual** (`residual anomaly`)  
Anomalía de actualización, inserción o borrado que persiste en un esquema
en 3FN porque involucra atributos primos. La FNBC elimina este tipo de anomalía.  
_Ejemplo:_ en `cursa(estudiante_id, materia_id, profesor_id)` en 3FN,
cambiar el profesor de una materia sigue requiriendo actualizar múltiples filas.

**Atributo no primo** (`non-prime attribute`)  
Atributo que no forma parte de ninguna clave candidata de la relación.
Las dependencias transitivas de los atributos no-primos sobre la clave son
exactamente lo que elimina la 3FN.  
_Ejemplo:_ en `customers(customer_id, customer_name, city_id)`, si
`customer_id` es la única CK, entonces `customer_name` y `city_id` son no-primos.

**Atributo primo** (`prime attribute`)  
Atributo que pertenece a al menos una clave candidata. Su participación en una
FD recibida de un no-superclave es la excepción que permite que 3FN y FNBC difieran.  
_Ejemplo:_ en `cursa(estudiante_id, materia_id, profesor_id)`, los tres
atributos son primos porque cada uno aparece en alguna de las dos CKs.

## B

**BCNF / FNBC** (Forma Normal de Boyce-Codd)  
Forma normal más estricta que 3FN. Requiere que para toda FD no-trivial `X → A`,
`X` sea una superclave — sin excepciones para atributos primos.  
_Ejemplo:_ `professor_subject(profesor_id PK, materia_id)` satisface FNBC
porque `profesor_id` es la PK (superclave).

## C

**Cadena transitiva** (`transitive chain`)  
Secuencia de FDs del tipo `PK → B → C` donde `B` no es superclave. Representa
una dependencia transitiva que viola 3FN.  
_Ejemplo:_ `invoice_id → customer_id → customer_name` — `customer_id` no es
la PK de `invoices`, así que la cadena es transitiva.

**Cierre de un conjunto de atributos** (`attribute closure`)  
Conjunto de todos los atributos que pueden determinarse a partir de un conjunto
inicial `X` aplicando repetidamente las FDs del esquema. Se denota `X⁺`.
Si `X⁺` contiene todos los atributos de la relación, `X` es superclave.  
_Ejemplo:_ si `{customer_id}⁺ = {customer_id, customer_name, city_id}`,
entonces `customer_id` es superclave de `customers`.

**Clave candidata** (`candidate key`)  
Conjunto mínimo de atributos que identifica unívocamente cada fila de una
relación. Una relación puede tener más de una CK; la que se elige como
identificador principal es la clave primaria.  
_Ejemplo:_ en `cursa(est, mat, prof)`, tanto `{est, mat}` como `{est, prof}`
son claves candidatas.

## D

**Dependencia funcional transitiva** (`transitive functional dependency`)  
FD de la forma `A → C` que se da indirectamente a través de un intermediario
`B` no-superclave: `A → B → C`. Viola 3FN cuando `C` es un atributo no-primo.  
_Ejemplo:_ `invoice_id → salesperson_id → salesperson_name`.

**Desnormalización** (`denormalization`)  
Decisión deliberada de introducir redundancia en un esquema normalizado para
mejorar el rendimiento de lectura o simplificar consultas. Requiere documentación
técnica con razón, trade-off y mecanismo de sincronización.  
_Ejemplo:_ mantener `invoice_total` pre-calculado en `invoices` en lugar de
calcularlo con `SUM(invoice_lines)` en cada consulta.

**Determinante** (`determinant`)  
Lado izquierdo de una dependencia funcional. En `X → A`, `X` es el determinante.
Si `X` no es superclave, la FD puede violar 3FN o FNBC.  
_Ejemplo:_ en `customer_id → customer_name`, `customer_id` es el determinante.

## F

**Forma Normal de Boyce-Codd** → ver **BCNF / FNBC**

## P

**Pérdida de dependencia** (`dependency loss`)  
Fenómeno que ocurre cuando una descomposición a FNBC hace imposible reconstruir
una FD original a través de un JOIN natural. Es el principal trade-off de FNBC
respecto a 3FN.  
_Ejemplo:_ al descomponer `cursa(est, mat, prof)` a FNBC, la FD
`{est, mat} → prof` ya no es directamente comprobable en las tablas descompuestas.

## S

**Sin pérdida de información** (`lossless-join decomposition`)  
Propiedad de una descomposición que garantiza que el JOIN de las tablas
resultantes produce exactamente la relación original — sin filas espurias.
Es requisito indispensable de cualquier normalización válida.  
_Ejemplo:_ descomponer `customers` e `invoices` por `customer_id` garantiza
lossless join porque `customer_id` es PK en `customers`.

**Superclave** (`superkey`)  
Cualquier conjunto de atributos cuyo cierre (`X⁺`) contiene todos los
atributos de la relación. Toda clave candidata es superclave, pero no
toda superclave es mínima (clave candidata).  
_Ejemplo:_ `{customer_id, customer_name}` es superclave de `customers`,
pero no es mínima — `{customer_id}` sola ya es superclave.

## T

**Tabla de resumen** / **Vista materializada** (`summary table / materialized view`)  
Estructura desnormalizada que pre-computa agregados (`SUM`, `COUNT`, `AVG`)
para consultas analíticas frecuentes. En PostgreSQL se implementa con
`CREATE MATERIALIZED VIEW`.  
_Ejemplo:_ `mv_sales_by_region` que agrupa `invoice_total` por país y mes.

**Tercera Forma Normal** (3FN)  
Forma normal que extiende 2FN eliminando dependencias transitivas de atributos
no-primos. Formal: para toda FD no-trivial `X → A`, o bien `X` es superclave
o bien `A` es primo.  
_Ejemplo:_ `invoices(invoice_id, customer_id FK, salesperson_id FK, invoice_date,
invoice_total)` está en 3FN porque todas las columnas no-clave dependen
directamente de `invoice_id`.

---

← [Recursos](../4-recursos/webgrafia/README.md) | → [README](../README.md)

_Última actualización: Semana 08 · Modelo Lógico_
