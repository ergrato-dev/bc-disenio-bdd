# Glosario — Semana 03: ER Básico

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.
> Los nombres técnicos en inglés se mantienen entre backticks.

---

## A

### Atributo

Propiedad o característica que describe una entidad. Representa un dato que el
sistema almacena sobre la entidad.

**Ejemplo:** La entidad `LIBRO` tiene los atributos `isbn`, `titulo` y `precio`.

---

### Atributo compuesto

Atributo que puede descomponerse en sub-atributos con significado propio.
En Chen se dibuja como un óvalo conectado a otros óvalos.

**Ejemplo:** `dirección` se descompone en `calle`, `ciudad` y `país`.

---

### Atributo derivado

Atributo cuyo valor puede calcularse a partir de otros datos del sistema. Se
representa en Chen con un óvalo de borde discontinuo. No se almacena físicamente.

**Ejemplo:** `antigüedad` se deriva de `fecha_ingreso` y la fecha actual.

---

### Atributo identificador (clave)

Atributo que identifica unívocamente cada instancia de una entidad. En Chen se
representa con el texto subrayado dentro del óvalo.

**Ejemplo:** `isbn` identifica de forma única a cada `LIBRO`.

---

### Atributo multivaluado

Atributo que puede tener más de un valor para la misma instancia de entidad.
En Chen se dibuja con un óvalo de doble borde. En el modelo físico se resuelve
con una tabla separada.

**Ejemplo:** `idiomas` de un `LIBRO` (un libro puede estar en español, inglés y francés).

---

### Atributo simple

Atributo atómico: no se puede ni se necesita descomponer. Es el tipo más común.

**Ejemplo:** `precio`, `email`, `fecha_nacimiento`.

---

## C

### Cardinalidad

Restricción numérica que define cuántas instancias de una entidad pueden
relacionarse con cuántas instancias de otra. Los tres tipos básicos son 1:1, 1:N
y N:M.

**Ejemplo:** La relación `EDITORIAL — LIBRO` tiene cardinalidad 1:N: una editorial
publica muchos libros, pero cada libro tiene solo una editorial.

---

### `Crow's Foot` (Pata de cuervo)

Notación gráfica para diagramas ER, creada por Gordon Everest (1976) y popularizada
por Richard Barker. Representa la cardinalidad con símbolos en los extremos de las
líneas de relación: barras verticales para "uno", líneas convergentes para "muchos" y
círculo para "cero".

---

## D

### Diagrama ER

Representación gráfica de un modelo Entidad-Relación. Muestra las entidades,
sus atributos y las relaciones entre ellas con sus cardinalidades. Existen
múltiples notaciones: Chen, Crow's Foot, IDEF1X, Martin, entre otras.

---

## E

### Entidad

Objeto del mundo real distinguible de otros objetos, del que el sistema necesita
almacenar información. En el diagrama ER se representa como un rectángulo.

**Ejemplo:** `CLIENTE`, `PRODUCTO`, `PEDIDO`.

---

### Entidad débil

Entidad que no puede identificarse por sus propios atributos: necesita de
otra entidad (llamada entidad fuerte) para ser identificada. Se dibuja con un
rectángulo de doble borde en Chen.

**Ejemplo:** `HABITACION` puede ser débil respecto a `HOTEL` si su número
solo es único dentro de un hotel específico.

---

### Entidad fuerte

Entidad que tiene su propio atributo identificador y no depende de otra entidad
para ser identificada. La mayoría de las entidades son fuertes.

**Ejemplo:** `HOTEL`, `CLIENTE`, `PRODUCTO`.

---

## G

### Grado de relación

Número de tipos de entidad que participan en una relación.

- **Unaria (grado 1):** una entidad se relaciona consigo misma. Ej: `EMPLEADO` supervisa `EMPLEADO`.
- **Binaria (grado 2):** dos entidades distintas. El tipo más común.
- **Ternaria (grado 3):** tres entidades participan en la misma relación. (Semana 04)

---

## I

### Instancia

Cada fila o registro concreto de una entidad. Se distingue del *tipo de entidad*,
que es la definición abstracta.

**Ejemplo:** El tipo de entidad es `LIBRO`; una instancia es el libro con
`isbn = '978-0-13-468599-1'`.

---

## M

### Modelo Entidad-Relación (ER)

Modelo conceptual de datos propuesto por Peter Chen en 1976. Describe el mundo
real en términos de entidades, atributos y relaciones, independientemente de
la tecnología de base de datos utilizada.

---

## N

### Notación Chen

Notación original del modelo ER, creada por Peter Chen (1976). Usa rectángulos
para entidades, óvalos para atributos y rombos para relaciones. Es más expresiva
para el modelo conceptual pero más verbosa que Crow's Foot.

---

### `1:1` (Uno a uno)

Cardinalidad donde una instancia de A se relaciona con como máximo una instancia
de B, y viceversa.

**Ejemplo:** `PERSONA — PASAPORTE`: una persona tiene un pasaporte, y un pasaporte
pertenece a una persona.

---

### `1:N` (Uno a muchos)

Cardinalidad donde una instancia de A puede relacionarse con muchas instancias de
B, pero cada instancia de B se relaciona con exactamente una A.

**Ejemplo:** `DEPARTAMENTO — EMPLEADO`: un departamento tiene muchos empleados,
pero cada empleado pertenece a un solo departamento.

---

### `N:M` (Muchos a muchos)

Cardinalidad donde una instancia de A puede relacionarse con muchas instancias
de B, y una instancia de B puede relacionarse con muchas instancias de A. En el
modelo físico se resuelve con una tabla intermedia.

**Ejemplo:** `ESTUDIANTE — CURSO`: un estudiante toma varios cursos, y un curso
tiene varios estudiantes.

---

## P

### Participación

Restricción que indica si la participación de una entidad en una relación es
obligatoria u opcional. Se acompaña de la notación de mínimo:

- **Participación total:** toda instancia de la entidad debe participar en la relación (mínimo 1). Símbolo: `||`.
- **Participación parcial:** una instancia puede o no participar (mínimo 0). Símbolo: `○`.

---

### Participación parcial

Ver **Participación**. Una entidad tiene participación parcial cuando algunas
instancias no tienen por qué participar en la relación.

**Ejemplo:** `HUESPED` tiene participación parcial en `realiza → RESERVA`: un huésped
puede estar registrado sin haber hecho ninguna reserva todavía.

---

### Participación total

Ver **Participación**. Una entidad tiene participación total cuando *toda*
instancia debe participar en la relación.

**Ejemplo:** `HABITACION` tiene participación total en `pertenece → HOTEL`: toda
habitación pertenece a algún hotel; no puede existir una habitación sin hotel.

---

## R

### Relación

Asociación con significado entre dos o más entidades. En Chen se dibuja como un
rombo; en Crow's Foot como una línea con símbolos en los extremos. Una relación
puede tener atributos propios.

**Ejemplo:** La relación `realiza` entre `HUESPED` y `RESERVA`.

---

### Relación binaria

Relación entre exactamente dos tipos de entidad. Es el tipo de relación más
frecuente en diseño ER.

---

### Relación reflexiva (o recursiva)

Relación donde una entidad se relaciona consigo misma. Útil para modelar jerarquías
o redes dentro de la misma clase de objetos.

**Ejemplo:** `EMPLEADO` supervisa `EMPLEADO`, o `CURSO` es prerequisito de `CURSO`.

---

### Relación ternaria

Relación que involucra exactamente tres tipos de entidad simultáneamente. Se estudia
en detalle en la Semana 04.

**Ejemplo:** `PROVEEDOR` suministra `PRODUCTO` a `PROYECTO`.

---

## T

### Tipo de entidad

La definición abstracta de una clase de objetos: el nombre y la lista de atributos.
Se distingue de la *instancia*, que es un objeto concreto.

**Ejemplo:** `LIBRO` es el tipo de entidad; el libro con ISBN `978-0-13-468599-1` es
una instancia.

---

*Última actualización: Semana 03 · Modelo Conceptual*
