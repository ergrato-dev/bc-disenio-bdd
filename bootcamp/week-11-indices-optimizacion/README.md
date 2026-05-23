# Semana 11 — Índices y optimización

> Diseña para velocidad: entiende cómo PostgreSQL ejecuta tus consultas

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, serás capaz de:

- ✅ Explicar cómo funciona un índice `B-tree` y cuándo crearlo
- ✅ Elegir entre `B-tree`, `Hash`, `GIN` y `BRIN` según el caso de uso
- ✅ Leer e interpretar la salida de `EXPLAIN ANALYZE`
- ✅ Diseñar una estrategia de indexación para un esquema real

## 📋 Prerequisitos

- [ ] Semana 10 — DDL completo ejecutable en PostgreSQL

## 🗂️ Contenido de la Semana

| #   | Tipo        | Tema                        | Tiempo |
| --- | ----------- | --------------------------- | ------ |
| 1   | 📖 Teoría   | Índices B-tree: estructura interna y selectividad | ~Xh    |
| 2   | 📖 Teoría   | Índices especializados: Hash, GIN, BRIN | ~Xh    |
| 3   | 📖 Teoría   | `EXPLAIN ANALYZE`: leer el plan de ejecución | ~Xh    |
| 4   | 💻 Práctica | Comparativa de rendimiento con y sin índices en 100K filas  | ~3h    |
| 5   | 🏗️ Proyecto | Estrategia de indexación para el sistema de gestión de proyectos con benchmark | ~2h    |

## ⏱️ Distribución del Tiempo (8 horas)

| Componente            | Horas |
| --------------------- | ----- |
| Teoría                | 2h    |
| Prácticas guiadas     | 3h    |
| Proyecto semanal      | 2h    |
| Evaluación / revisión | 1h    |

## 📌 Entregables

- [ ] Script con `CREATE INDEX` justificados
- [ ] Reporte `EXPLAIN ANALYZE` antes/después de índices
- [ ] Tabla comparativa de tiempos de consulta

## 🔗 Navegación

← [Semana 10](../week-10-ddl-postgresql/) &nbsp;&nbsp;|&nbsp;&nbsp; [Semana 12](../week-12-objetos-avanzados) →
