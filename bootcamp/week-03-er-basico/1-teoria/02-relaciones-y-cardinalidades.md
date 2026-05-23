# Relaciones y Cardinalidades

Las **relaciones** conectan entidades entre sí. Las **cardinalidades** definen
**cuántas** instancias de cada entidad pueden participar en una relación. Juntas,
capturan las reglas de negocio más importantes del dominio.

![Cardinalidades 1:1, 1:N y N:M en notación Crow's Foot](../0-assets/02-cardinalidades-1-1-1-N-N-M.svg)

---

## 1. ¿Qué es una relación?

Una **relación** describe cómo las instancias de dos (o más) entidades se asocian entre sí.

| Componente | Descripción | Ejemplo |
|------------|-------------|---------|
| **Nombre** | Verbo o frase verbal que describe la asociación | `realiza`, `pertenece a`, `escribe` |
| **Entidades participantes** | Las entidades que conecta | CLIENTE — PEDIDO |
| **Cardinalidad** | Cuántas instancias de cada lado pueden participar | 1:N |
| **Participación** | Si la participación es obligatoria u opcional | total / parcial |

---

## 2. Grado de una relación

El **grado** es el número de entidades que participan en la relación.

### Relación binaria (grado 2) — la más común

```
AUTOR ——escribe—— LIBRO
```

### Relación unaria / reflexiva (grado 1)

Una entidad se relaciona consigo misma. Requiere **roles** explícitos.

```
EMPLEADO ——supervisa—— EMPLEADO
(supervisor)              (supervisado)
```

Casos típicos: jerarquías organizacionales, categorías padre-hijo,
referencias de productos similares.

### Relación ternaria (grado 3)

Tres entidades participan simultáneamente. La estudiaremos en detalle en la Semana 04.

```
MÉDICO ——prescribe——→ MEDICAMENTO
              ↑
           PACIENTE
```

> ✅ El 90 % de las relaciones en un modelo real son binarias. Las ternarias
> aparecen cuando la relación entre dos entidades **depende** de una tercera.

---

## 3. Cardinalidad

La **cardinalidad** define el número **máximo** de instancias de una entidad que
pueden asociarse con *una sola* instancia de la otra entidad.

### 3.1 Uno a uno (1:1)

Una instancia de A se asocia con **como máximo una** instancia de B y viceversa.

**Ejemplo:** Una persona tiene un único pasaporte; un pasaporte pertenece a
una única persona.

```
PERSONA ——tiene—— PASAPORTE
   1                  1
```

**Cuándo aparece:**
- Entidad principal + datos extendidos opcionales
- Relaciones legales o contractuales exclusivas
- Separación de datos de seguridad (credenciales vs. perfil)

> 💡 Las relaciones 1:1 a veces indican que las dos entidades podrían unirse en una sola.
> Se mantienen separadas cuando: los datos son opcionales, tienen ciclos de vida distintos,
> o pertenecen a dominios diferentes (ej: EMPLEADO y su CONTRATO).

### 3.2 Uno a muchos (1:N)

Una instancia de A se asocia con **múltiples** instancias de B;
cada instancia de B se asocia con **exactamente una** instancia de A.

**Ejemplo:** Un autor puede escribir muchos libros; cada libro tiene un único autor principal.

```
AUTOR ——escribe—— LIBRO
  1                 N
```

**Casos típicos:** cabecera-detalle, clasificación-ítem, padre-hijo, maestro-registro.

> ✅ La relación 1:N es la más frecuente en bases de datos relacionales.
> En el modelo físico se implementa con una **clave foránea** en el lado N.

### 3.3 Muchos a muchos (N:M)

Múltiples instancias de A se asocian con múltiples instancias de B.

**Ejemplo:** Un estudiante puede estar inscrito en muchos cursos;
un curso tiene muchos estudiantes inscritos.

```
ESTUDIANTE ——se inscribe en—— CURSO
     N                           M
```

**Casos típicos:** inscripciones, etiquetas/tags, roles de usuarios, listas de materiales.

> ⚠️ Las relaciones N:M **no se pueden implementar directamente** en el modelo relacional.
> Se resuelven creando una **tabla intermedia** (entidad de intersección) que tiene
> claves foráneas a ambas entidades. Lo veremos en la Semana 06.

---

## 4. Participación (mínimo de instancias)

La **participación** define si **todas** las instancias de una entidad *deben* participar
en la relación o si es opcional.

| Tipo | Significado | Crow's Foot (interior) |
|------|-------------|------------------------|
| **Total** (obligatoria) | Toda instancia DEBE participar — mínimo 1 | `\|` (barra vertical) |
| **Parcial** (opcional) | La instancia PUEDE no participar — mínimo 0 | `○` (círculo) |

### Notación completa: mínimo..máximo

La combinación de participación (mínimo) + cardinalidad (máximo) da cuatro patrones:

| Notación | Crow's Foot | Mínimo | Máximo | Lectura |
|----------|-------------|--------|--------|---------|
| `0..1`   | `○\|`        | 0 | 1 | cero o uno — opcional, máximo uno |
| `1..1`   | `\|\|`       | 1 | 1 | exactamente uno — obligatorio y único |
| `0..N`   | `○<`         | 0 | N | cero o muchos — opcional |
| `1..N`   | `\|<`        | 1 | N | uno o muchos — obligatorio participar |

### Ejemplo: CLIENTE y PEDIDO

**Regla de negocio:**
- Todo pedido DEBE tener un cliente (obligatorio)
- Un cliente PUEDE no tener pedidos aún (opcional)

```
CLIENTE ——realiza—— PEDIDO
  0..N                1..1
(opcional,         (obligatorio,
 muchos)            exactamente uno)
```

Lectura: *"Un cliente realiza cero o muchos pedidos. Cada pedido es realizado
por exactamente un cliente."*

---

## 5. Atributos de relación

Las relaciones N:M (y algunas 1:N) pueden tener **atributos propios** que describen
la *asociación*, no las entidades individuales.

**Ejemplo:** ¿Dónde va la `calificacion` del estudiante en un curso?

- No es del ESTUDIANTE (tiene distintas notas en distintos cursos)
- No es del CURSO (tiene distintas notas por estudiante)
- Es de la **relación INSCRIPCION** entre ambos

```
ESTUDIANTE ——(INSCRIPCION)—— CURSO
                  ├── fecha_inscripcion
                  ├── calificacion
                  └── estado
```

> En el modelo físico, los atributos de relación se convierten en columnas
> de la tabla intermedia. La relación N:M se resuelve como:
> `ESTUDIANTE` → `inscripciones` (con `calificacion`) → `CURSO`

---

## 6. Cómo leer un diagrama ER: la fórmula

> **"Cada [Entidad A] [verbo] [mínimo]..[máximo] [Entidad B]"**

Siempre leer en **ambas direcciones**. Ejemplo:

```
EDITORIAL ——publica—— LIBRO
   1..1                0..N
```

- Dirección → : *"Cada EDITORIAL publica cero o muchos LIBROS"*
- Dirección ← : *"Cada LIBRO es publicado por exactamente una EDITORIAL"*

**Regla de negocio que captura:** una editorial puede existir sin haber publicado
nada aún (nueva editorial); todo libro publicado debe tener una editorial.

---

## 7. Errores comunes

| Error | Descripción | Corrección |
|-------|-------------|-----------|
| **Cardinalidad invertida** | Poner N en el lado incorrecto | Leer la regla de negocio en ambas direcciones antes de dibujar |
| **N:M sin tabla intermedia** | Intentar implementar N:M con una FK | Crear entidad de intersección con FK a cada lado |
| **Atributos de relación mal colocados** | `calificacion` en ESTUDIANTE o en CURSO | Identificar qué datos pertenecen a la *asociación*, no a las entidades |
| **Relación sin nombre** | Línea sin etiqueta | Usar un verbo preciso que describa la asociación |
| **Participación incorrecta** | Marcar como obligatorio cuando es opcional | Revisar explícitamente las reglas de negocio: "¿puede existir X sin Y?" |

---

← [01 — Entidades y atributos](01-entidades-y-atributos.md) &nbsp;&nbsp;|&nbsp;&nbsp; [03 — Notación Crow's Foot →](03-notacion-crows-foot.md)
