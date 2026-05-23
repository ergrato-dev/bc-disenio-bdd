# 🤖 Instrucciones para GitHub Copilot

## 📋 Contexto del Bootcamp

Este es un **Bootcamp de Diseño de Bases de Datos Relacionales — Zero to Hero** estructurado
para llevar a estudiantes desde cero hasta dominar el diseño profesional de bases de datos
relacionales: modelo conceptual, modelo lógico y modelo físico.

### 📊 Datos del Bootcamp

- **Duración:** 14 semanas (~3.5 meses)
- **Dedicación semanal:** 8 horas
- **Total de horas:** ~112 horas
- **Nivel de salida:** Diseñador/Arquitecto de Bases de Datos Junior
- **SGBD principal:** PostgreSQL 16+
- **Herramientas:** PostgreSQL, pgAdmin 4, DBeaver, dbdiagram.io, draw.io

---

## 🎯 Objetivos de Aprendizaje

Al finalizar el bootcamp, los estudiantes serán capaces de:

- ✅ Analizar requerimientos de negocio y transformarlos en modelos de datos
- ✅ Diseñar diagramas Entidad-Relación (ER) en notaciones Chen y Crow's Foot
- ✅ Modelar relaciones avanzadas: ternarias, reflexivas, especialización/generalización
- ✅ Transformar modelos conceptuales en modelos relacionales normalizados
- ✅ Aplicar formas normales (1FN, 2FN, 3FN, FNBC, 4FN) con criterio técnico
- ✅ Implementar modelos físicos completos en PostgreSQL con DDL profesional
- ✅ Diseñar estrategias de indexación y analizar planes de ejecución (EXPLAIN ANALYZE)
- ✅ Crear objetos avanzados: vistas, funciones, procedimientos, triggers
- ✅ Aplicar patrones de diseño avanzados (soft delete, auditoría, jerarquías)
- ✅ Versionar y migrar esquemas de forma controlada

---

## 📚 Estructura del Bootcamp

### Distribución por Fases

| Fase                             | Semanas | Horas | Enfoque                                           |
| -------------------------------- | ------- | ----- | ------------------------------------------------- |
| Fundamentos Relacionales         | 1–2     | 16h   | Modelo relacional, entorno, SQL de consulta       |
| Modelo Conceptual                | 3–5     | 24h   | Diagrama ER, cardinalidades, relaciones avanzadas |
| Modelo Lógico                    | 6–9     | 32h   | Transformación ER→Relacional, normalización       |
| Modelo Físico                    | 10–12   | 24h   | DDL, índices, objetos avanzados, transacciones    |
| Diseño Avanzado + Proyecto Final | 13–14   | 16h   | Patrones, migraciones, proyecto integrador        |

**Total: 14 semanas · 112 horas de formación**

### Contenido por Semana

| Semana | Tema                                                                   | Fase        |
| ------ | ---------------------------------------------------------------------- | ----------- |
| 01     | El mundo relacional — SGBD, entorno, primera base de datos             | Fundamentos |
| 02     | Fundamentos SQL de consulta — SELECT, JOINs, tipos de datos, NULL      | Fundamentos |
| 03     | ER Básico — entidades, atributos, relaciones, cardinalidades           | Conceptual  |
| 04     | ER Intermedio — atributos multivaluados, entidades débiles, ternarias  | Conceptual  |
| 05     | ER Avanzado — herencia, especialización/generalización, herramientas   | Conceptual  |
| 06     | Del ER al modelo relacional — reglas de transformación                 | Lógico      |
| 07     | Normalización I — dependencias funcionales, 1FN, 2FN                   | Lógico      |
| 08     | Normalización II — 3FN, FNBC, cuándo desnormalizar                     | Lógico      |
| 09     | Integridad y restricciones — PRIMARY KEY, FOREIGN KEY, CHECK, UNIQUE   | Lógico      |
| 10     | DDL completo en PostgreSQL — tipos de datos, esquemas, secuencias      | Físico      |
| 11     | Índices y optimización — B-tree, Hash, GIN, EXPLAIN ANALYZE            | Físico      |
| 12     | Objetos avanzados y transacciones — vistas, funciones, triggers, ACID  | Físico      |
| 13     | Patrones de diseño — soft delete, auditoría, multi-tenancy, jerarquías | Avanzado    |
| 14     | Proyecto Final Integrador — requerimientos → ER → Relacional → DDL     | Avanzado    |

---

## 🗂️ Estructura de Carpetas

### 📁 Carpetas Raíz

- `assets/`: Recursos visuales globales (logos, headers, diagramas del bootcamp)
- `docs/`: Documentación general del bootcamp
- `scripts/`: Scripts de automatización y utilidades
- `bootcamp/`: Contenido semanal del bootcamp

### 📁 Estructura de cada Semana

Cada semana sigue esta estructura estándar:

```
bootcamp/week-XX-tema_principal/
├── README.md                 # Descripción y objetivos de la semana
├── rubrica-evaluacion.md     # Criterios de evaluación detallados
├── 0-assets/                 # Diagramas SVG, imágenes y recursos visuales
├── 1-teoria/                 # Material teórico (archivos .md)
├── 2-practicas/              # Ejercicios guiados paso a paso
├── 3-proyecto/               # Proyecto semanal integrador
│   ├── README.md             # Instrucciones del proyecto
│   ├── starter/              # Archivos iniciales para el estudiante
│   └── solution/             # ⚠️ OCULTA — Solo para instructores (.gitignore)
├── 4-recursos/               # Recursos adicionales
│   ├── ebooks-free/
│   ├── videografia/
│   └── webgrafia/
└── 5-glosario/               # Términos clave de la semana (A-Z)
    └── README.md
```

La carpeta `solution/` está en `.gitignore` y **NO** se sube al repositorio público.

---

## 🎓 Componentes de Cada Semana

### 1. Teoría (`1-teoria/`)

- Archivos markdown con explicaciones conceptuales
- Diagramas ER/relacionales embebidos como SVG o DBML
- Ejemplos SQL con comentarios educativos
- Referencias a documentación oficial de PostgreSQL

### 2. Prácticas (`2-practicas/`)

Ejercicios guiados paso a paso. **No son tareas con TODOs.** El estudiante aprende
ejecutando sentencias SQL ya provistas y observando los resultados.

#### 📋 Formato de Ejercicios SQL

Los ejercicios incluyen el SQL completo comentado para que el estudiante lo ejecute
sección por sección, no para que lo implemente:

**README.md del ejercicio:**

````markdown
### Paso 1: Crear la tabla de clientes

Ejecuta el siguiente script en pgAdmin o DBeaver:

```sql
-- Crear tabla con restricciones de integridad
CREATE TABLE customers (
    id          SERIAL       PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
```
````

Observa cómo PostgreSQL asigna el `id` automáticamente gracias a `SERIAL`.

````

**starter/ejercicio.sql:**

```sql
-- ============================================
-- PASO 1: Crear la tabla de clientes
-- ============================================
-- Descomenta y ejecuta este bloque:

-- CREATE TABLE customers (
--     id          SERIAL       PRIMARY KEY,
--     full_name   VARCHAR(100) NOT NULL,
--     email       VARCHAR(150) NOT NULL UNIQUE,
--     created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
-- );
````

> ⚠️ **IMPORTANTE:** Los ejercicios NO tienen carpeta `solution/`. El estudiante
> aprende ejecutando el código y verificando los resultados.

#### ❌ NO usar este formato en ejercicios:

```sql
-- ❌ INCORRECTO — Este formato es para PROYECTOS, no ejercicios
CREATE TABLE customers (
    id SERIAL PRIMARY KEY
    -- TODO: Agregar columnas
);
```

#### ✅ Usar este formato en ejercicios:

```sql
-- ✅ CORRECTO — Código comentado para ejecutar sección por sección
-- CREATE TABLE customers (
--     id          SERIAL       PRIMARY KEY,
--     full_name   VARCHAR(100) NOT NULL,
--     email       VARCHAR(150) NOT NULL UNIQUE
-- );
```

### 3. Proyecto (`3-proyecto/`)

- Proyecto integrador que consolida lo aprendido en la semana
- README.md con instrucciones y contexto de negocio
- Enunciado de requerimientos realistas (casos del mundo real)
- Código inicial en `starter/` (esqueleto con TODOs para el estudiante)
- Carpeta `solution/` oculta (solo para instructores)

#### 📋 Formato de Proyecto (con TODOs)

A diferencia de los ejercicios, el proyecto SÍ usa TODOs:

```sql
-- ============================================
-- PROYECTO: Sistema de Biblioteca
-- TAREA: Diseñar el modelo de datos completo
-- ============================================

-- TODO: Crear la tabla de autores con las siguientes columnas:
-- - id (clave primaria auto-incremental)
-- - first_name (obligatorio, máximo 50 caracteres)
-- - last_name (obligatorio, máximo 50 caracteres)
-- - birth_date (fecha, puede ser nulo)
-- - nationality (código ISO de 2 letras)

-- TODO: Crear la tabla de libros referenciando autores

-- TODO: Agregar constraint para que ISBN sea único
```

### 4. Recursos (`4-recursos/`)

- `ebooks-free/`: Libros sobre diseño de BD, SQL y PostgreSQL
- `videografia/`: Videos y tutoriales complementarios
- `webgrafia/`: Documentación oficial, artículos y referencias

### 5. Glosario (`5-glosario/`)

- Términos técnicos de modelado de datos ordenados A-Z
- Definiciones claras y concisas en español
- Ejemplos SQL cuando aplique

---

## 📝 Convenciones de SQL

### Nomenclatura de Objetos

```sql
-- ✅ BIEN — snake_case para tablas y columnas
CREATE TABLE order_items (
    id              SERIAL          PRIMARY KEY,
    order_id        INTEGER         NOT NULL,
    product_id      INTEGER         NOT NULL,
    quantity        SMALLINT        NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10, 2)  NOT NULL CHECK (unit_price >= 0),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- ✅ BIEN — nombres de constraints explícitos (patrón: tipo_tabla_columna)
ALTER TABLE order_items
    ADD CONSTRAINT fk_order_items_order_id
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_order_items_product_id
        FOREIGN KEY (product_id) REFERENCES products(id);

-- ❌ MAL — nombre de columna ambiguo, sin constraint explícito
CREATE TABLE items (id INT, oid INT, pid INT, qty INT);
```

### Estilo SQL

```sql
-- ✅ BIEN — keywords en MAYÚSCULAS, identificadores en minúsculas
SELECT
    u.id,
    u.email,
    p.full_name,
    COUNT(o.id)  AS total_orders
FROM users         AS u
JOIN profiles      AS p  ON p.user_id   = u.id
LEFT JOIN orders   AS o  ON o.customer_id = u.id
WHERE u.is_active = TRUE
GROUP BY u.id, u.email, p.full_name
ORDER BY total_orders DESC;

-- ❌ MAL — keywords en minúsculas, sin alias, sin indentación
select u.id, u.email, count(o.id) from users u join orders o on o.customer_id=u.id group by u.id;
```

### Tipos de Datos PostgreSQL (Recomendados)

| Caso de uso                     | Tipo recomendado                               |
| ------------------------------- | ---------------------------------------------- |
| Clave primaria auto-incremental | `BIGSERIAL` (o `GENERATED ALWAYS AS IDENTITY`) |
| Texto corto (nombre, email)     | `VARCHAR(n)`                                   |
| Texto largo sin límite          | `TEXT`                                         |
| Entero pequeño (estados, flags) | `SMALLINT`                                     |
| Entero estándar                 | `INTEGER`                                      |
| Decimal exacto (dinero)         | `NUMERIC(precision, scale)`                    |
| Fecha y hora con zona           | `TIMESTAMPTZ`                                  |
| Solo fecha                      | `DATE`                                         |
| Booleano                        | `BOOLEAN`                                      |
| UUID                            | `UUID` (con `gen_random_uuid()`)               |
| JSON estructurado               | `JSONB`                                        |

### Naming Conventions

- **Tablas:** `snake_case`, plural (`users`, `order_items`, `product_categories`)
- **Columnas:** `snake_case`, singular (`user_id`, `created_at`, `is_active`)
- **Constraints:** `tipo_tabla_columna`
  - PK: `pk_users`
  - FK: `fk_orders_customer_id`
  - UQ: `uq_users_email`
  - CK: `ck_products_price_positive`
  - IX: `ix_orders_created_at`
- **Índices:** `ix_tabla_columna` o `ix_tabla_col1_col2`
- **Vistas:** `vw_nombre_descriptivo`
- **Funciones:** `fn_verbo_sustantivo` (ej: `fn_calculate_total`)
- **Procedimientos:** `sp_verbo_sustantivo` (ej: `sp_create_order`)
- **Triggers:** `trg_tabla_evento` (ej: `trg_users_before_update`)
- **Idioma:** Inglés para objetos de BD, español para documentación

---

## 🗺️ Convenciones de Diagramas ER

### Herramientas por Contexto

| Herramienta             | Cuándo usarla                                                 |
| ----------------------- | ------------------------------------------------------------- |
| **dbdiagram.io** (DBML) | Modelo lógico/físico — tablas y relaciones                    |
| **draw.io**             | Modelo conceptual — diagrama ER con notación Chen/Crow's Foot |
| **SVG**                 | Assets finales renderizados para incluir en documentación     |

### DBML — Formato estándar para modelos lógicos/físicos

```dbml
// ============================================
// Modelo Lógico: Sistema de E-Commerce
// Versión: 1.0 | Fecha: 2026-05-22
// ============================================

Table users {
  id          bigserial   [pk, note: "Clave primaria"]
  email       varchar(150) [not null, unique]
  full_name   varchar(100) [not null]
  is_active   boolean     [not null, default: true]
  created_at  timestamptz [not null, default: `now()`]

  indexes {
    email [unique, name: "uq_users_email"]
    created_at [name: "ix_users_created_at"]
  }
}

Table orders {
  id          bigserial   [pk]
  customer_id bigint      [not null, ref: > users.id]
  status      varchar(20) [not null, note: "pending|confirmed|shipped|delivered|cancelled"]
  total       numeric(10,2) [not null]
  created_at  timestamptz [not null, default: `now()`]
}
```

### SVG — Estándares visuales

- 🌙 Tema dark para todos los assets visuales
- ❌ Sin degradés (gradients) — colores sólidos únicamente
- ✅ Paleta consistente: fondo `#1e1e2e`, texto `#cdd6f4`, acento `#89b4fa` (azul PostgreSQL)
- ✅ Fuentes sans-serif: Inter, Roboto, System UI
- ✅ Todo SVG debe estar vinculado en al menos un archivo de teoría

---

## 🌐 Idioma y Nomenclatura

### Objetos de Base de Datos

```sql
-- ✅ CORRECTO — inglés para objetos de BD
CREATE TABLE product_categories (
    id          SERIAL      PRIMARY KEY,
    name        VARCHAR(80) NOT NULL UNIQUE,
    parent_id   INTEGER     REFERENCES product_categories(id)
);

-- ❌ INCORRECTO — español en nombres de objetos
CREATE TABLE categorias_productos (
    id          SERIAL      PRIMARY KEY,
    nombre      VARCHAR(80) NOT NULL UNIQUE,
    id_padre    INTEGER     REFERENCES categorias_productos(id)
);
```

### Documentación

- ✅ READMEs, teoría y guías **en español**
- ✅ Comentarios educativos en SQL **en español** (explican el "por qué")
- ✅ Nombres de objetos de BD **en inglés** (industria estándar)
- ✅ Glosarios **en español** con términos técnicos en inglés entre backticks

---

## 🔐 Mejores Prácticas de Diseño

### Integridad de Datos

- Declarar `NOT NULL` explícitamente en cada columna que lo requiera
- Preferir constraints declarativos sobre lógica en aplicación
- Definir `ON DELETE` y `ON UPDATE` en todas las foreign keys
- Usar `CHECK` constraints para reglas de negocio simples
- Nunca almacenar datos calculables que puedan derivarse

### Normalización

- Aplicar mínimo hasta 3FN en todo diseño inicial
- Desnormalizar solo con justificación de rendimiento documentada
- Mantener coherencia entre el modelo lógico y el físico implementado

### Seguridad y Auditoría

- Separar datos sensibles en tablas dedicadas
- Incluir `created_at` y `updated_at` en toda tabla de entidades
- Usar soft delete (`deleted_at`) en lugar de DELETE físico cuando aplique
- Nunca almacenar contraseñas en texto plano (hash fuera del modelo de BD)

### Rendimiento

- Indexar siempre las foreign keys
- Indexar columnas usadas frecuentemente en `WHERE`, `ORDER BY`, `GROUP BY`
- Usar `EXPLAIN ANALYZE` antes de optimizar
- Preferir vistas materializadas para consultas analíticas costosas

---

## 📊 Evaluación

Cada semana incluye tres tipos de evidencias:

1. **Conocimiento** 🧠 (30%): Cuestionarios y evaluaciones teóricas
2. **Desempeño** 💪 (40%): Ejercicios prácticos en clase
3. **Producto** 📦 (30%): Proyecto entregable funcional

### Criterios de Aprobación

- Mínimo 70% en cada tipo de evidencia
- Entrega puntual de proyectos
- Scripts SQL funcionales y bien documentados
- Diagramas coherentes con el modelo implementado

---

## 🚀 Metodología de Aprendizaje

### Estrategias Didácticas

- **Aprendizaje Basado en Proyectos (ABP):** Casos reales de sistemas conocidos
- **Práctica Deliberada:** Ejercicios SQL incrementales
- **Design Reviews:** Revisión crítica de diseños entre estudiantes
- **Refactoring de Esquemas:** Identificar y corregir diseños deficientes
- **Live Modeling:** Sesiones en vivo de modelado de datos

### Distribución del Tiempo (8h/semana)

| Componente            | Horas |
| --------------------- | ----- |
| Teoría                | 2h    |
| Prácticas guiadas     | 3h    |
| Proyecto semanal      | 2h    |
| Evaluación / revisión | 1h    |

---

## 🤖 Instrucciones para Copilot

Cuando trabajes en este proyecto:

### Límites de Respuesta

1. **Divide respuestas largas**
   - ❌ NUNCA generar respuestas que superen los límites de tokens
   - ✅ SIEMPRE dividir contenido extenso en múltiples entregas
   - ✅ Crear contenido por secciones, esperar confirmación del usuario
   - ✅ Priorizar calidad sobre cantidad en cada entrega

2. **Estrategia de División**
   - Para semanas completas: dividir por carpetas (`teoria` → `practicas` → `proyecto`)
   - Para scripts SQL largos: dividir por bloques lógicos (DDL → índices → datos de prueba)
   - Siempre indicar claramente qué parte se entrega y qué falta
   - Esperar confirmación antes de continuar

### Generación de SQL

1. **Usa siempre sintaxis PostgreSQL moderna (16+)**
   - Preferir `GENERATED ALWAYS AS IDENTITY` sobre `SERIAL` en código nuevo
   - Usar `TIMESTAMPTZ` en lugar de `TIMESTAMP` para columnas de fecha/hora
   - Usar `gen_random_uuid()` para UUIDs
   - Aprovechar tipos nativos (`JSONB`, `ARRAY`, tipos enumerados)

2. **Entorno de Desarrollo**
   - ✅ Docker + docker compose para PostgreSQL y pgAdmin
   - ✅ DBeaver o pgAdmin como cliente de BD
   - ✅ dbdiagram.io para modelado visual

3. **Formato y legibilidad**
   - Keywords SQL en MAYÚSCULAS
   - Identificadores en snake_case minúsculas
   - Indentación consistente (4 espacios o alineación de columnas)
   - Comentarios educativos en español

### Creación de Contenido

1. **Estructura clara y progresiva**
   - De lo simple a lo complejo
   - Conceptos construidos sobre conocimientos previos
   - Casos de uso del mundo real (e-commerce, biblioteca, hospital, etc.)

2. **Coherencia entre modelos**
   - El modelo conceptual (ER) debe ser consistente con el lógico
   - El modelo lógico debe ser consistente con el DDL físico
   - Los datos de prueba deben respetar todas las restricciones

3. **Enfoque práctico**
   - Siempre incluir el "por qué" de cada decisión de diseño
   - Mostrar anti-patrones junto a las soluciones correctas
   - Usar ejemplos de sistemas que los estudiantes conocen

### Respuestas y Ayuda

1. **Explicaciones claras**
   - Lenguaje simple y directo
   - Analogías del mundo real cuando sean útiles
   - Señalar errores comunes en diseño de BD

2. **Código comentado**
   - Explicar cada decisión de diseño importante
   - Destacar trade-offs (normalización vs. rendimiento, etc.)
   - Señalar cuándo y por qué aplicar cada patrón

---

## 🛠️ Stack y Herramientas

| Herramienta    | Versión        | Propósito                          |
| -------------- | -------------- | ---------------------------------- |
| PostgreSQL     | 16+            | SGBD principal                     |
| pgAdmin        | 4+             | Administración visual              |
| DBeaver        | Community      | Cliente SQL multiplataforma        |
| dbdiagram.io   | Online         | Modelado lógico/físico (DBML)      |
| draw.io        | Online/Desktop | Diagramas ER conceptuales          |
| Docker         | 27+            | Entorno de desarrollo reproducible |
| Docker Compose | 2.x            | Orquestación PostgreSQL + pgAdmin  |

### Configuración Docker de Referencia

```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: bootcamp_db
      POSTGRES_USER: bootcamp_user
      POSTGRES_PASSWORD: bootcamp_pass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init:/docker-entrypoint-initdb.d

  pgadmin:
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@bootcamp.local
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "5050:80"
    depends_on:
      - postgres

volumes:
  postgres_data:
```

---

## 📚 Referencias Oficiales

- **PostgreSQL Documentation:** <https://www.postgresql.org/docs/16/>
- **DBML Spec:** <https://dbml.dbdiagram.io/docs/>
- **dbdiagram.io:** <https://dbdiagram.io>
- **draw.io:** <https://app.diagrams.net>
- **PostgreSQL Tutorial:** <https://www.postgresqltutorial.com/>
- **Use The Index, Luke:** <https://use-the-index-luke.com/>

---

## ✅ Checklist para Nuevas Semanas

### Orden de Generación de Contenido

El contenido de cada semana **debe generarse en este orden estricto**:

1. **`README.md`** — Descripción general, objetivos de aprendizaje y estructura de la semana
2. **`rubrica-evaluacion.md`** — Criterios de evaluación detallados (conocimiento, desempeño, producto)
3. **Archivos de teoría** (`1-teoria/`) — Material conceptual completo, sin referencias a SVG aún
4. **Assets SVG** (`0-assets/`) — Diagramas de apoyo a la comprensión, nombrados en orden lógico de lectura:
   - Formato obligatorio: `01-nombre-descriptivo.svg`, `02-nombre-descriptivo.svg`, …
   - El número refleja el orden en que el estudiante los encontrará al leer la teoría
5. **Renderizar SVGs en teoría** — Insertar las referencias `![](../0-assets/0N-nombre.svg)` en los archivos de teoría donde corresponda
6. **Prácticas** (`2-practicas/`) — Ejercicios guiados con código SQL comentado
7. **Proyecto** (`3-proyecto/`) — Proyecto integrador con `starter/` (TODOs) y `solution/` (oculta)
8. **Recursos** (`4-recursos/`) — Ebooks, videografía y webografía complementaria
9. **Glosario** (`5-glosario/README.md`) — Términos clave de la semana en orden A-Z
10. eliminar .gitkeep innecesarios
11. commit + push con conventional commits en inglés + what? for? impact? (ej: `feat(week-01): add initial theory content and SVG assets`)

### Checklist de Verificación Final

- [ ] `README.md` con objetivos, tabla de contenido y navegación ← / →
- [ ] `rubrica-evaluacion.md` con los tres tipos de evidencia (conocimiento, desempeño, producto)
- [ ] Archivos de teoría en `1-teoria/` (mínimo 1 archivo por tema, con navegación al final)
- [ ] SVGs en `0-assets/` numerados (`01-`, `02-`, …) en orden lógico de lectura
- [ ] SVGs referenciados con `![descripción](../0-assets/0N-nombre.svg)` en los archivos de teoría
- [ ] Prácticas en `2-practicas/README.md` (código SQL comentado, paso a paso ejecutable)
- [ ] Proyecto en `3-proyecto/README.md` (contexto de negocio real, RFs concretos, sin TODOs en README)
- [ ] Proyecto `starter/` con TODOs guiados para el estudiante
- [ ] Recursos en `4-recursos/ebooks-free/README.md` (libros gratuitos con URL y justificación)
- [ ] Recursos en `4-recursos/videografia/README.md` (videos con URL, duración e idioma)
- [ ] Recursos en `4-recursos/webgrafia/README.md` (referencias web organizadas por tema)
- [ ] Glosario en `5-glosario/README.md` (términos A-Z con definición y ejemplo)
- [ ] `.gitkeep` eliminados de carpetas que ya tienen contenido
- [ ] Verificar coherencia con semanas anteriores
- [ ] Probar que todos los scripts SQL ejecutan correctamente en PostgreSQL 16+
- [ ] Commit + push: `feat(week-XX): <what> for <for> — <impact>`

---

## 💡 Notas Finales

- **Prioridad:** Claridad del diseño sobre optimización prematura
- **Enfoque:** Modelado correcto antes de performance
- **Objetivo:** Diseñadores de BD capaces de trabajar en proyectos reales
- **Filosofía:** _"Un buen diseño de BD es la base de cualquier sistema escalable"_

---

_Última actualización: Mayo 2026 · Versión: 1.0_
