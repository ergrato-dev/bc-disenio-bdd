# Proyecto Semana 01 — Tu primera base de datos: sistema de biblioteca básico

> **Fase:** Fundamentos &nbsp;|&nbsp; **Semana:** 01 de 14

## 📋 Contexto del Negocio

La **Biblioteca Comunitaria "El Saber"** necesita digitalizar su gestión. Actualmente
llevan todo en papel: un cuaderno de libros disponibles y otro de préstamos activos.
El director quiere una base de datos que les permita saber qué libros tienen, quiénes
son sus socios y qué libros tiene prestado cada persona en este momento.

Es un sistema pequeño e intencionalmente simple: el objetivo es que te concentres en
identificar las **entidades**, elegir los **tipos de datos correctos** y aplicar las
**convenciones de nomenclatura** del bootcamp. No hay cálculos ni lógica compleja.

## 🎯 Objetivo

Diseñar e implementar el esquema de base de datos de la biblioteca con las tablas
mínimas necesarias, usando los tipos de datos apropiados y aplicando constraints
de integridad básicos.

## 📐 Requerimientos

### Requerimientos funcionales

- **RF-01:** El sistema debe registrar libros con título, autor, año de publicación
  e ISBN (código único de 13 caracteres).
- **RF-02:** El sistema debe registrar socios con nombre completo, email (único) y
  fecha de registro.
- **RF-03:** El sistema debe registrar préstamos: qué socio tomó prestado qué libro,
  en qué fecha y cuándo lo devolvió (puede ser nulo si aún no lo devuelve).

### Restricciones de diseño

- Aplicar las convenciones de nomenclatura del bootcamp (snake_case, plural para tablas)
- Usar `UUID DEFAULT gen_random_uuid()` para todas las claves primarias
- Usar `TIMESTAMPTZ` para marcas de tiempo; `DATE` para fechas sin hora
- Todas las `FOREIGN KEY` deben declarar política `ON DELETE` explícita
- Las constraints deben seguir el patrón de nombres del bootcamp (`pk_`, `fk_`, `uq_`, `ck_`)

## 📦 Entregables

- [ ] Entorno Docker funcionando con `docker compose up -d`
- [ ] Script `starter/biblioteca.sql` completado y ejecutado sin errores
- [ ] Las 3 tablas creadas: `books`, `members`, `loans`
- [ ] Al menos 3 libros, 2 socios y 2 préstamos insertados como datos de prueba
- [ ] Captura de pantalla desde pgAdmin o DBeaver mostrando las tablas

## 🚀 Instrucciones

1. Levanta tu entorno Docker (`docker compose up -d`)
2. Abre el archivo `starter/biblioteca.sql`
3. Lee cada bloque de comentarios `-- TODO:` y completa el código
4. Ejecuta los bloques **uno por uno** en pgAdmin o DBeaver
5. Verifica que cada paso funciona antes de continuar con el siguiente

## ✅ Criterios de Aceptación

- [ ] Todos los scripts SQL ejecutan sin errores en PostgreSQL 16+
- [ ] Las constraints siguen la convención `tipo_tabla_columna`
- [ ] Los tipos de datos son los apropiados (no `TEXT` para todo, no `FLOAT` para nada)
- [ ] Las 3 tablas tienen al menos una `FOREIGN KEY` con `ON DELETE` explícito
- [ ] Los datos de prueba insertan sin violar ninguna constraint

## 🔗 Referencias

- [Semana 01 — Teoría: Modelo relacional](../1-teoria/01-modelo-relacional.md)
- [Semana 01 — Teoría: Tipos de datos](../1-teoria/03-tipos-datos-postgresql.md)
- [Semana 01 — Prácticas](../2-practicas/README.md)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)
