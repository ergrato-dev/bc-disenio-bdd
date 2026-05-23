# Semana 13 — Patrones de diseño avanzados

> Los patrones que usan los sistemas que ya conoces: soft delete, auditoría, multi-tenancy

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, serás capaz de:

- ✅ Implementar `soft delete` con `deleted_at` y filtrado automático via vistas
- ✅ Diseñar tablas de auditoría con trigger que registra cambios históricos
- ✅ Modelar jerarquías de categorías con el patrón `adjacency list` y `nested sets`
- ✅ Aplicar multi-tenancy a nivel de esquema o de columna `tenant_id`

## 📋 Prerequisitos

- [ ] Semana 12 — Vistas, funciones y triggers en PostgreSQL

## 🗂️ Contenido de la Semana

| #   | Tipo        | Tema                        | Tiempo |
| --- | ----------- | --------------------------- | ------ |
| 1   | 📖 Teoría   | Soft delete: patrones y trade-offs | ~Xh    |
| 2   | 📖 Teoría   | Auditoría: historia completa de cambios | ~Xh    |
| 3   | 📖 Teoría   | Jerarquías: adjacency list, path enumeration, nested sets | ~Xh    |
| 4   | 💻 Práctica | Refactorizar el e-commerce con soft delete y tabla de auditoría  | ~3h    |
| 5   | 🏗️ Proyecto | Sistema de gestión de contenido (CMS) con categorías jerárquicas y auditoría completa | ~2h    |

## ⏱️ Distribución del Tiempo (8 horas)

| Componente            | Horas |
| --------------------- | ----- |
| Teoría                | 2h    |
| Prácticas guiadas     | 3h    |
| Proyecto semanal      | 2h    |
| Evaluación / revisión | 1h    |

## 📌 Entregables

- [ ] Script DDL con patrones implementados
- [ ] Consultas de ejemplo para cada patrón
- [ ] Análisis de trade-offs documentado

## 🔗 Navegación

← [Semana 12](../week-12-objetos-avanzados/) &nbsp;&nbsp;|&nbsp;&nbsp; [Semana 14](../week-14-proyecto-final) →
