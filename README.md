<p align="center">
  <img src="assets/bootcamp-header.svg" alt="Bootcamp Diseño de Bases de Datos Relacionales — Zero to Hero" width="800">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-CC%20BY--NC--SA%204.0-lightgrey.svg" alt="License CC BY-NC-SA 4.0"></a>
  <img src="https://img.shields.io/badge/semanas-14-yellow.svg" alt="14 Semanas">
  <img src="https://img.shields.io/badge/horas-112-orange.svg" alt="112 Horas">
  <img src="https://img.shields.io/badge/PostgreSQL-16%2B-4169E1?logo=postgresql&logoColor=white" alt="PostgreSQL">
</p>

<p align="center">
  <a href="README_EN.md"><img src="https://img.shields.io/badge/🇺🇸_English-0969DA?style=for-the-badge&logoColor=white" alt="English Version"></a>
</p>

---

## 📋 Descripción

Bootcamp intensivo de **14 semanas (~3.5 meses)** enfocado en el dominio del **diseño de bases de datos relacionales**: modelo conceptual, modelo lógico y modelo físico. Diseñado para llevar a estudiantes de cero a **Diseñador/Arquitecto de Bases de Datos Junior**, con énfasis en modelado riguroso, normalización y mejores prácticas de implementación en PostgreSQL.

### 🎯 Objetivos

Al finalizar el bootcamp, los estudiantes serán capaces de:

- ✅ Analizar requerimientos de negocio y transformarlos en modelos de datos
- ✅ Diseñar diagramas Entidad-Relación (ER) en notaciones Chen y Crow's Foot
- ✅ Modelar relaciones avanzadas: ternarias, reflexivas, especialización/generalización
- ✅ Transformar modelos conceptuales en modelos relacionales normalizados
- ✅ Aplicar formas normales (1FN, 2FN, 3FN, FNBC, 4FN) con criterio técnico
- ✅ Implementar modelos físicos completos en PostgreSQL con DDL profesional
- ✅ Diseñar estrategias de indexación y analizar planes de ejecución (EXPLAIN ANALYZE)
- ✅ Crear objetos avanzados: vistas, funciones, procedimientos almacenados, triggers
- ✅ Aplicar patrones de diseño avanzados (soft delete, auditoría, jerarquías)
- ✅ Versionar y migrar esquemas de forma controlada

### 🗄️ ¿Por qué dominar el diseño de bases de datos?

> **El modelo de datos correcto desde el inicio** — un esquema mal diseñado cuesta entre 10x y 100x más corregirlo en producción.

Toda aplicación, desde una startup hasta un sistema bancario, descansa sobre una base de datos. Un diseño deficiente genera datos inconsistentes, consultas lentas, deuda técnica irreparable y migraciones dolorosas. Este bootcamp enseña a hacer las cosas bien desde el primer día:

- **Modelo conceptual:** capturar la realidad del negocio antes de escribir una sola línea de SQL
- **Modelo lógico:** estructurar los datos con normalización y sin redundancia
- **Modelo físico:** implementar en PostgreSQL con constraints, índices y objetos avanzados que garanticen rendimiento e integridad

---

## 🗓️ Estructura del Bootcamp

| Fase | Semanas | Horas | Temas Principales |
|:----:|:-------:|:-----:|-------------------|
| **Fundamentos** | 1–2 | 16h | Modelo relacional, entorno PostgreSQL, SQL de consulta |
| **Modelo Conceptual** | 3–5 | 24h | Diagrama ER, cardinalidades, relaciones avanzadas, herencia |
| **Modelo Lógico** | 6–9 | 32h | Transformación ER→Relacional, normalización 1FN–FNBC |
| **Modelo Físico** | 10–12 | 24h | DDL completo, índices, objetos avanzados, transacciones |
| **Diseño Avanzado** | 13–14 | 16h | Patrones, migraciones, proyecto final integrador |

**Total: 14 semanas** | **112 horas** de formación

### 📅 Contenido por Semana

| Semana | Tema | Fase |
|:------:|------|------|
| 01 | El mundo relacional — SGBD, entorno, primera base de datos | Fundamentos |
| 02 | Fundamentos SQL de consulta — SELECT, JOINs, tipos de datos, NULL | Fundamentos |
| 03 | ER Básico — entidades, atributos, relaciones, cardinalidades | Conceptual |
| 04 | ER Intermedio — atributos multivaluados, entidades débiles, ternarias | Conceptual |
| 05 | ER Avanzado — herencia, especialización/generalización, herramientas | Conceptual |
| 06 | Del ER al modelo relacional — reglas de transformación | Lógico |
| 07 | Normalización I — dependencias funcionales, 1FN, 2FN | Lógico |
| 08 | Normalización II — 3FN, FNBC, cuándo desnormalizar | Lógico |
| 09 | Integridad y restricciones — PRIMARY KEY, FOREIGN KEY, CHECK, UNIQUE | Lógico |
| 10 | DDL completo en PostgreSQL — tipos de datos, esquemas, secuencias | Físico |
| 11 | Índices y optimización — B-tree, Hash, GIN, EXPLAIN ANALYZE | Físico |
| 12 | Objetos avanzados y transacciones — vistas, funciones, triggers, ACID | Físico |
| 13 | Patrones de diseño — soft delete, auditoría, multi-tenancy, jerarquías | Avanzado |
| 14 | Proyecto Final Integrador — requerimientos → ER → Relacional → DDL | Avanzado |

---

## 📚 Contenido por Semana

Cada semana incluye:

```
bootcamp/week-XX-tema_principal/
├── README.md                 # Descripción y objetivos
├── rubrica-evaluacion.md     # Criterios de evaluación
├── 0-assets/                 # Diagramas SVG y recursos visuales
├── 1-teoria/                 # Material teórico
├── 2-practicas/              # Ejercicios SQL guiados
├── 3-proyecto/               # Proyecto semanal
│   ├── starter/              # Esqueleto con TODOs para el estudiante
│   └── solution/             # ⚠️ Solo para instructores
├── 4-recursos/               # Recursos adicionales
│   ├── ebooks-free/
│   ├── videografia/
│   └── webgrafia/
└── 5-glosario/               # Términos clave de la semana (A-Z)
```

### 🔑 Componentes Clave

- 📖 **Teoría**: Conceptos de modelado con diagramas, ejemplos SQL y análisis de decisiones de diseño
- 💻 **Práctica**: Ejercicios SQL guiados paso a paso (código comentado para ejecutar y observar)
- 🏗️ **Proyecto**: Caso de negocio real — del enunciado al esquema implementado en PostgreSQL
- 📝 **Evaluación**: Evidencias de conocimiento, desempeño y producto
- 🎓 **Recursos**: Glosarios, referencias oficiales y material complementario

---

## 🛠️ Stack y Herramientas

| Herramienta | Versión | Uso |
|-------------|---------|-----|
| PostgreSQL | **16+** | SGBD principal |
| pgAdmin | **4+** | Administración visual de la base de datos |
| DBeaver | **Community** | Cliente SQL multiplataforma |
| dbdiagram.io | Online | Modelado lógico/físico (DBML) |
| draw.io | Online/Desktop | Diagramas ER conceptuales |
| Docker | **27+** | Entorno de desarrollo reproducible |
| Docker Compose | **2.x** | Orquestación PostgreSQL + pgAdmin |

**Entorno de desarrollo**: Docker + Docker Compose — sin necesidad de instalar PostgreSQL localmente.

---

## 🚀 Inicio Rápido

### Prerrequisitos

- **Docker** y **Docker Compose** instalados
- **Git** para control de versiones
- **VS Code** (recomendado) con extensiones incluidas
- **DBeaver** o **pgAdmin** como cliente SQL

### 1. Clonar el Repositorio

```bash
git clone https://github.com/ergrato-dev/bc-disenio-bdd.git
cd bc-disenio-bdd
```

### 2. Levantar el entorno de base de datos

```bash
# Iniciar PostgreSQL + pgAdmin
docker compose up -d

# Verificar que los contenedores están corriendo
docker compose ps
```

Accede a pgAdmin en [http://localhost:5050](http://localhost:5050):
- **Email:** `admin@bootcamp.local`
- **Password:** `admin`

### 3. Conectar a PostgreSQL desde DBeaver o pgAdmin

```
Host:     localhost
Puerto:   5432
BD:       bootcamp_db
Usuario:  bootcamp_user
Password: bootcamp_pass
```

### 4. Navegar a la Semana Actual

```bash
cd bootcamp/week-01-el_mundo_relacional
```

Cada semana contiene un `README.md` con instrucciones detalladas.

---

## 📊 Metodología de Aprendizaje

### Estrategias Didácticas

- 🎯 **Aprendizaje Basado en Proyectos (ABP)**: Casos reales de sistemas conocidos
- 🧩 **Práctica Deliberada**: Ejercicios SQL incrementales con feedback inmediato
- 🔍 **Design Reviews**: Revisión crítica de diseños con análisis de trade-offs
- 🔄 **Refactoring de Esquemas**: Identificar y corregir diseños deficientes
- 🎮 **Live Modeling**: Sesiones en vivo de modelado de datos desde cero

### Distribución del Tiempo (8h/semana)

| Componente | Horas |
|------------|-------|
| Teoría | 2h |
| Prácticas guiadas | 3h |
| Proyecto semanal | 2h |
| Evaluación / revisión | 1h |

### Evaluación

Cada semana incluye tres tipos de evidencias:

1. **Conocimiento 🧠** (30%): Cuestionarios y evaluaciones teóricas
2. **Desempeño 💪** (40%): Ejercicios prácticos en clase
3. **Producto 📦** (30%): Proyecto entregable funcional

**Criterio de aprobación**: Mínimo 70% en cada tipo de evidencia

---

## 📞 Soporte

- 💬 **Discussions**: [GitHub Discussions](https://github.com/ergrato-dev/bc-disenio-bdd/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/ergrato-dev/bc-disenio-bdd/issues)

---

## ⚠️ Exención de Responsabilidad

Este repositorio es un recurso **educativo** creado con fines de aprendizaje. Al utilizarlo, aceptas los siguientes términos:

- **Solo fines educativos**: El contenido, los scripts SQL y los proyectos están diseñados exclusivamente para la enseñanza y el aprendizaje. No constituyen asesoramiento profesional, legal ni de seguridad.
- **Sin garantías**: El material se proporciona **"tal cual"**, sin garantías de ningún tipo, expresas o implícitas.
- **Código en producción**: Los ejemplos SQL son ilustrativos. Antes de usarlos en entornos productivos, realiza revisiones de seguridad, rendimiento y adaptación a tu contexto específico.
- **Versiones de software**: Las versiones de herramientas mencionadas pueden quedar desactualizadas. Siempre consulta la documentación oficial más reciente.
- **Limitación de responsabilidad**: Los autores y contribuidores no se responsabilizan por pérdidas de datos, daños directos o indirectos, interrupciones de servicio ni cualquier otro perjuicio derivado del uso de este material.
- **Responsabilidad del estudiante**: Cada estudiante es responsable de sus propias implementaciones, entornos de desarrollo y decisiones técnicas.

---

## 📄 Licencia

Este proyecto está bajo la licencia **[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International).

**Puedes:** compartir y adaptar el material, incluso crear forks educativos.<br>
**No puedes:** usar este material con fines comerciales.<br>
**Debes:** dar crédito apropiado y distribuir las adaptaciones bajo la misma licencia.

Ver el archivo [LICENSE](LICENSE) para el texto completo.

---

## 🏆 Agradecimientos

- [PostgreSQL](https://www.postgresql.org/) — Por ser el SGBD relacional más avanzado y de código abierto
- [pgAdmin](https://www.pgadmin.org/) — Por la herramienta de administración visual más completa para PostgreSQL
- [dbdiagram.io](https://dbdiagram.io) — Por hacer el modelado de datos accesible y visual
- [Use The Index, Luke](https://use-the-index-luke.com/) — Referencia imprescindible sobre índices en BD relacionales
- Comunidad PostgreSQL — Por los recursos, documentación y ejemplos de clase mundial
- Todos los contribuidores

---

## 📚 Documentación Adicional

- [🤖 Instrucciones de Copilot](.github/copilot-instructions.md)
- [📜 Código de Conducta](CODE_OF_CONDUCT.md)
- [🔒 Política de Seguridad](SECURITY.md)

---

<p align="center">
  <strong>🎓 Bootcamp Diseño de Bases de Datos Relacionales — Zero to Hero</strong><br>
  <em>De cero a diseñador de bases de datos en 3.5 meses</em>
</p>

<p align="center">
  <a href="bootcamp/week-01-el_mundo_relacional">Comenzar Semana 1</a> •
  <a href="docs">Ver Documentación</a> •
  <a href="https://github.com/ergrato-dev/bc-disenio-bdd/issues">Reportar Issue</a>
</p>

<p align="center">
  Hecho con ❤️ para la comunidad de diseñadores de datos
</p>
