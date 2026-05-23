# Semana 10 — DDL completo en PostgreSQL

> Del modelo lógico al código SQL que corre en producción

## 🎯 Objetivos de Aprendizaje

Al finalizar esta semana, serás capaz de:

- ✅ Elegir el tipo de dato PostgreSQL más apropiado para cada atributo
- ✅ Crear esquemas (`CREATE SCHEMA`) para organizar objetos de BD
- ✅ Usar `GENERATED ALWAYS AS IDENTITY` y secuencias para claves primarias
- ✅ Escribir scripts DDL idempotentes con `CREATE ... IF NOT EXISTS` y `DROP ... IF EXISTS`

## 📋 Prerequisitos

- [ ] Semana 09 — Modelo lógico con integridad referencial completa

## 🗂️ Contenido de la Semana

| #   | Tipo        | Tema                        | Tiempo |
| --- | ----------- | --------------------------- | ------ |
| 1   | 📖 Teoría   | Tipos de datos en PostgreSQL 16: guía de selección | ~Xh    |
| 2   | 📖 Teoría   | `CREATE SCHEMA`: organización y namespacing | ~Xh    |
| 3   | 📖 Teoría   | Identidades, secuencias y `DEFAULT` | ~Xh    |
| 4   | 💻 Práctica | Implementación física del e-commerce (semana 09) en PostgreSQL  | ~3h    |
| 5   | 🏗️ Proyecto | Script DDL completo y probado para un sistema de gestión de proyectos | ~2h    |

## ⏱️ Distribución del Tiempo (8 horas)

| Componente            | Horas |
| --------------------- | ----- |
| Teoría                | 2h    |
| Prácticas guiadas     | 3h    |
| Proyecto semanal      | 2h    |
| Evaluación / revisión | 1h    |

## 📌 Entregables

- [ ] Script DDL idempotente ejecutable en PostgreSQL 16+
- [ ] Script de datos de prueba (`INSERT`s) que respetan todas las constraints

## 🔗 Navegación

← [Semana 09](../week-09-integridad-restricciones/) &nbsp;&nbsp;|&nbsp;&nbsp; [Semana 11](../week-11-indices-optimizacion) →
