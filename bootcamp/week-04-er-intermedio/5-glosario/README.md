# Glosario — Semana 04: ER Intermedio

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

| Término | Definición | Ejemplo |
| ------- | ---------- | ------- |
| `aggregation` | Término en inglés para *entidad asociativa*; en algunos textos (Elmasri/Navathe) se usa para representar una relación N:M como una entidad que puede participar en otra relación. | El conjunto SUPPLIER-PRODUCT tratado como unidad que se relaciona con PROJECT. |
| `atributo compuesto` | Atributo formado por sub-atributos que describen partes de su valor. Puede descomponerse. | `direccion` → `calle`, `ciudad`, `pais`, `codigo_postal`. |
| `atributo derivado` | Atributo cuyo valor puede calcularse a partir de otros atributos o relaciones. Se marca con óvalo punteado en Chen. | `edad` calculada desde `fecha_nacimiento`; `subtotal` calculado desde `cantidad × precio_unitario`. |
| `atributo multivaluado` | Atributo que puede tener múltiples valores para una misma instancia de entidad. Viola la 1FN si se almacena en una sola columna. | `telefonos` de una empresa: `{+56 9 1111, +56 9 2222}`. En modelo físico → tabla separada. |
| `clave parcial` | Atributo que identifica instancias de una entidad débil *dentro* del conjunto de instancias asociadas a una entidad fuerte. Solo es clave cuando se combina con la PK de la entidad fuerte. | `numero_linea` en `LINEA_FACTURA`: el 1 de la Factura-001 no es el mismo que el 1 de la Factura-002. Se representa con subrayado punteado en Chen. |
| `dependencia de existencia` | Condición en que una entidad no puede existir en la base de datos sin estar asociada a otra entidad. Toda entidad débil tiene dependencia de existencia con su entidad fuerte. | `LINEA_FACTURA` no puede existir sin una `FACTURA` que la contenga. |
| `dependencia de identificación` | Dependencia más fuerte que la de existencia: la entidad no puede identificarse sin su entidad propietaria. Implica que su PK incluye la FK a la entidad fuerte. | `HABITACION` no se puede identificar solo con su número — necesita saber a qué `HOTEL` pertenece. |
| `discriminador` | Sinónimo de *clave parcial*. Atributo que discrimina (distingue) instancias de una entidad débil dentro del ámbito de su entidad fuerte. | `numero_item` en `ITEM_ORDEN` es el discriminador: distingue los ítems *dentro de* una orden. |
| `entidad asociativa` | Entidad que surge al promover una relación N:M a entidad propia porque la relación tiene atributos propios, otras entidades la referencian, o tiene ciclo de vida propio. | `INSCRIPCION` entre `ESTUDIANTE` y `SESION`; tiene `fecha_inscripcion`, `estado` y `asistio`. |
| `entidad débil` | Entidad que no puede identificarse únicamente por sus propios atributos; depende de otra entidad (entidad fuerte) para su identificación. En Chen: rectángulo de doble borde. | `LINEA_PEDIDO` (depende de `PEDIDO`), `HABITACION` (depende de `HOTEL`), `CAPITULO` (depende de `LIBRO`). |
| `entidad fuerte` | Entidad que puede identificarse por sus propios atributos sin depender de otra. Tiene una clave primaria propia. | `CLIENTE`, `PRODUCTO`, `EMPLEADO` son entidades fuertes típicas. |
| `PK compuesta` | Clave primaria formada por dos o más columnas. En entidades débiles: siempre incluye la FK a la entidad fuerte. | `PRIMARY KEY (order_id, line_number)` en `order_items`. |
| `primera forma normal (1FN)` | Regla de diseño que exige que cada celda de una tabla contenga un único valor atómico. Los atributos multivaluados violan la 1FN si se almacenan como lista en una columna. | `telefonos = "+56 9 1111, +56 9 2222"` viola la 1FN. La solución: tabla separada `company_phones`. |
| `relación de identificación` | Relación entre una entidad débil y su entidad fuerte que permite identificar a la entidad débil. En Chen: diamante de doble borde. | La relación `CONTIENE` entre `FACTURA` y `LINEA_FACTURA` es una relación de identificación. |
| `relación ternaria` | Relación que involucra a tres entidades simultáneamente. No puede descomponerse en dos relaciones binarias sin pérdida de información. Se representa con un único diamante conectado a tres entidades. | `PROVEEDOR` — `suministra` — `PRODUCTO` — `a` — `PROYECTO`: la combinación proveedor+producto+proyecto es única. |
| `tabla intermedia` | Tabla física que resuelve una relación N:M. Su PK es compuesta (las dos FKs). Si no tiene columnas propias más allá de las FKs, es una tabla pivote simple. Si tiene columnas propias, es la implementación de una entidad asociativa. | `student_courses (student_id PK/FK, course_id PK/FK)` — tabla pivote simple. `enrollments (id PK, student_id FK, course_id FK, enrollment_date, grade)` — entidad asociativa. |
| `tabla pivote` | Nombre coloquial para una tabla intermedia simple (sin atributos propios) que solo almacena las FKs de una relación N:M. | `product_categories (product_id FK, category_id FK)` con `PRIMARY KEY (product_id, category_id)`. |

---

*Última actualización: Semana 04 · Modelo Conceptual Intermedio*
