# Práctica — Modelado ER: Sistema de Reservas de Hotel

> **Duración estimada:** ~3 horas  
> **Herramienta:** draw.io (app.diagrams.net) + este documento  
> **Entregable:** Análisis documentado + diagrama ER en draw.io

En esta práctica modelamos el sistema de información de una cadena hotelera llamada
**"Hotel Los Pinos"**. El proceso tiene cinco pasos: leer el negocio, identificar
entidades, definir atributos, identificar relaciones y dibujar el diagrama.

Sigue cada paso con el análisis ya resuelto. El objetivo es *entender el razonamiento*,
no encontrar la respuesta por tu cuenta (para eso es el proyecto).

---

## Paso 1 — Descripción del negocio

Lee detenidamente la siguiente descripción del sistema:

> **Hotel Los Pinos** es una cadena con múltiples hoteles. Cada hotel tiene un nombre,
> dirección (ciudad, país) y una categoría de 1 a 5 estrellas. Cada hotel tiene un
> número variable de habitaciones; cada habitación tiene un número (único dentro del hotel),
> un tipo (individual, doble, suite) y un precio por noche.
>
> Los huéspedes se registran con su nombre completo, correo electrónico, teléfono y
> país de origen. Un huésped puede hacer varias reservas a lo largo del tiempo, o
> ninguna si acaba de registrarse.
>
> Una reserva tiene una fecha de entrada, fecha de salida, un estado
> (pendiente, confirmada, cancelada, completada) y el total a pagar. Cada reserva
> corresponde a exactamente un huésped y ocupa exactamente una habitación.
>
> El sistema también registra los empleados del hotel. Cada empleado tiene nombre,
> cargo y fecha de ingreso. Cada empleado trabaja en exactamente un hotel. El sistema
> debe poder identificar qué empleado registró cada reserva.

---

## Paso 2 — Identificar entidades

**Proceso:** Subrayar los sustantivos del dominio y evaluar si merecen ser entidades.

| Sustantivo encontrado | ¿Entidad? | Justificación |
|-----------------------|-----------|---------------|
| Hotel | ✅ Sí | Tiene múltiples atributos y se relaciona con habitaciones y empleados |
| Habitación | ✅ Sí | Tiene atributos propios (número, tipo, precio) y se relaciona con reservas |
| Huésped | ✅ Sí | El sistema gestiona su ciclo de vida; participa en múltiples reservas |
| Reserva | ✅ Sí | Es un evento con atributos propios (fechas, estado, total) |
| Empleado | ✅ Sí | El sistema gestiona sus datos y registra sus acciones |
| Nombre, correo, teléfono | ❌ No | Son atributos de HUESPED, no entidades independientes |
| Fecha de entrada, salida | ❌ No | Son atributos de RESERVA |
| Tipo de habitación | ❌ No | Es un atributo simple de HABITACION (podría ser entidad si se gestiona por separado) |
| Ciudad, país | ❌ No | Atributos de dirección (compuesto) en HOTEL. Si gestionáramos ciudades con detalle, sería entidad |

> **Decisión de diseño:** `tipo_habitacion` queda como atributo porque el sistema no
> gestiona tipos de habitación de forma independiente: no tienen descripción propia,
> no participan en otras relaciones, y son un conjunto cerrado de valores.

**Entidades resultantes: HOTEL, HABITACION, HUESPED, RESERVA, EMPLEADO**

---

## Paso 3 — Atributos de cada entidad

Para cada entidad, identificamos sus atributos y marcamos el identificador (clave).

### HOTEL
| Atributo | Tipo | Notas |
|----------|------|-------|
| `id` | Identificador (clave) | Sustituto — no hay un identificador natural obvio |
| `nombre` | Simple | Ej: "Hotel Los Pinos Centro" |
| `direccion` | Compuesto | Se divide en `ciudad` + `pais` (necesitamos filtrar por ciudad) |
| `categoria` | Simple | Valor entre 1 y 5 |
| `telefono` | Simple | |

### HABITACION
| Atributo | Tipo | Notas |
|----------|------|-------|
| `id` | Identificador (clave) | El "número" de habitación solo es único dentro de un hotel, necesitamos id global |
| `numero` | Simple | "101", "202", etc. — único por hotel |
| `tipo` | Simple | individual / doble / suite |
| `precio_noche` | Simple | Numérico decimal |
| `capacidad` | Simple | Personas |

> **Nota:** `id` aquí es un identificador sustituto porque el "número" natural
> (`numero + hotel`) es compuesto. En la Semana 09 discutiremos cuándo usar cada opción.

### HUESPED
| Atributo | Tipo | Notas |
|----------|------|-------|
| `id` | Identificador (clave) | |
| `nombre` | Simple | Nombre completo (decidimos no dividirlo: no filtramos por apellido) |
| `email` | Simple | Único por huésped |
| `telefono` | Simple | Puede ser NULL — no todos proporcionan teléfono |
| `pais` | Simple | País de origen |

### RESERVA
| Atributo | Tipo | Notas |
|----------|------|-------|
| `id` | Identificador (clave) | |
| `fecha_entrada` | Simple | |
| `fecha_salida` | Simple | |
| `estado` | Simple | pendiente / confirmada / cancelada / completada |
| `total` | Simple | Podría ser derivado (noches × precio), pero se almacena por si el precio cambia |
| `noches` | Derivado | fecha_salida − fecha_entrada. No se almacena. |

### EMPLEADO
| Atributo | Tipo | Notas |
|----------|------|-------|
| `id` | Identificador (clave) | |
| `nombre` | Simple | |
| `cargo` | Simple | recepcionista, gerente, limpieza… |
| `fecha_ingreso` | Simple | |
| `antiguedad` | Derivado | Calculada de `fecha_ingreso`. No se almacena. |

---

## Paso 4 — Relaciones y cardinalidades

Para cada relación, respondemos dos preguntas:

1. ¿Cuántas instancias de A puede tener una instancia de B? (qué va al lado A)
2. ¿Cuántas instancias de B puede tener una instancia de A? (qué va al lado B)

| Relación | Pregunta → | Respuesta | Pregunta ← | Respuesta |
|----------|-----------|-----------|-----------|-----------|
| HOTEL — HABITACION | ¿Cuántas hab. tiene un hotel? | 1 o muchas `\|<` | ¿A cuántos hoteles pertenece una hab.? | Exactamente uno `\|\|` |
| HUESPED — RESERVA | ¿Cuántas reservas hace un huésped? | 0 o muchas `○<` | ¿Cuántos huéspedes tiene una reserva? | Exactamente uno `\|\|` |
| HABITACION — RESERVA | ¿En cuántas reservas aparece una hab.? | 0 o muchas `○<` | ¿Cuántas hab. ocupa una reserva? | Exactamente una `\|\|` |
| HOTEL — EMPLEADO | ¿Cuántos empleados tiene un hotel? | 0 o muchos `○<` | ¿En cuántos hoteles trabaja un empleado? | Exactamente uno `\|\|` |
| EMPLEADO — RESERVA | ¿Cuántas reservas registra un empleado? | 0 o muchas `○<` | ¿Cuántos empleados registran una reserva? | Exactamente uno `\|\|` |

> **Nota sobre HOTEL — HABITACION:** usamos `|<` (uno o muchos) porque un hotel que
> existe en el sistema debe tener al menos una habitación registrada. Si el negocio
> permite hoteles "en construcción" sin habitaciones aún, cambiaría a `○<`.

---

## Paso 5 — Diagrama ER en draw.io

### Instrucciones

Abre **[app.diagrams.net](https://app.diagrams.net)** y crea el diagrama siguiendo estos pasos:

#### 5.1 Configurar el entorno

1. Crear nuevo diagrama → seleccionar **"Entity Relationship"** como plantilla
2. Activar la biblioteca **"Entity Relation"** en el panel izquierdo
3. Desde **Extras** → **Edit Diagram** puedes insertar XML directamente

#### 5.2 Agregar las 5 entidades

Arrastra 5 formas "Entity" al canvas. Renómbralas:
- `HOTEL` · `HABITACION` · `HUESPED` · `RESERVA` · `EMPLEADO`

#### 5.3 Conectar las entidades

Dibuja las 5 relaciones de la tabla anterior. Para cada conexión:
1. Pasa el cursor por el borde de la entidad origen → arrastrar a la entidad destino
2. Selecciona la línea → panel derecho → **Connection** → elige los extremos:
   - `||` = **ERone** (barra) con modificador **ERmandOne**
   - `|<` = **ERmany** con modificador **ERmandOne**
   - `○<` = **ERmany** con modificador **ERzeroToMany**

#### 5.4 Etiquetar las relaciones

Doble clic en cada línea y escribe el verbo:
`tiene` · `realiza` · `ocupa` · `trabaja en` · `registra`

#### 5.5 Verificar el diagrama

Comprueba que tu diagrama coincide con el de referencia:

![ER Sistema de Reservas de Hotel](../0-assets/04-er-ejemplo-reservas.svg)

> **Diferencia posible:** el SVG de referencia muestra solo 4 entidades (HOTEL, HABITACION,
> HUESPED, RESERVA). Tu diagrama debe incluir también EMPLEADO con sus relaciones.
> Eso es esperado — estás un paso más allá del ejemplo simplificado.

#### 5.6 Exportar

**Archivo** → **Exportar como** → **SVG** → activar **"Incluir una copia del diagrama"**

---

## Paso 6 — Reflexión y preguntas de diseño

Responde estas preguntas después de completar el diagrama:

1. ¿Por qué `total` en RESERVA es un atributo almacenado y no derivado, siendo que
   podría calcularse como `noches × precio_noche`?

2. Si el hotel quisiera ofrecer habitaciones con precios variables por temporada
   (temporada alta / baja), ¿qué cambiaría en el modelo? ¿Aparecería una nueva entidad?

3. ¿Qué pasaría si un huésped quisiera reservar varias habitaciones en la misma
   estancia? ¿Qué cambia en la cardinalidad de RESERVA — HABITACION?

4. La relación `EMPLEADO — RESERVA` tiene un nombre de relación dirigido ("registra").
   ¿Tendría sentido que una reserva pudiera existir sin un empleado que la haya
   registrado? ¿Cómo cambiaría la participación?

> Las respuestas a estas preguntas se discuten en la clase de revisión. No hay
> una única respuesta correcta: depende de los requerimientos del negocio.

---

← [03 — Notación Crow's Foot](../1-teoria/03-notacion-crows-foot.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Proyecto →](../3-proyecto/README.md)
