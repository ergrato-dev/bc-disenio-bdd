# Semana 09 — Integridad y restricciones

> Las reglas del contrato entre tu aplicación y tus datos

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, serás capaz de:

- ✅ Declarar `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL` y `CHECK` en PostgreSQL
- ✅ Definir políticas `ON DELETE` / `ON UPDATE` apropiadas para cada relación
- ✅ Nombrar constraints explícitamente siguiendo la convención del bootcamp
- ✅ Diseñar un esquema con integridad referencial completa y verificable

## 📋 Prerequisitos

- [ ] Semana 08 — Esquema normalizado hasta 3FN

## 🗂️ Contenido de la Semana

| #   | Tipo        | Tema                        | Tiempo |
| --- | ----------- | --------------------------- | ------ |
| 1   | 📖 Teoría   | `PRIMARY KEY` y `UNIQUE`: garantías de identidad | ~Xh    |
| 2   | 📖 Teoría   | `FOREIGN KEY`: integridad referencial y políticas de cascada | ~Xh    |
| 3   | 📖 Teoría   | `CHECK` y `NOT NULL`: restricciones de dominio | ~Xh    |
| 4   | 💻 Práctica | Añadir constraints completos al esquema del hospital (semana 06)  | ~3h    |
| 5   | 🏗️ Proyecto | Modelo lógico completo con todas las constraints para un sistema de e-commerce | ~2h    |

## ⏱️ Distribución del Tiempo (8 horas)

| Componente            | Horas |
| --------------------- | ----- |
| Teoría                | 2h    |
| Prácticas guiadas     | 3h    |
| Proyecto semanal      | 2h    |
| Evaluación / revisión | 1h    |

## 📌 Entregables

- [ ] Script DDL con todas las constraints nombradas explícitamente
- [ ] Pruebas de integridad: scripts que violan y respetan cada constraint

## 🔗 Navegación

← [Semana 08](../week-08-normalizacion-ii/) &nbsp;&nbsp;|&nbsp;&nbsp; [Semana 10](../week-10-ddl-postgresql) →
