# Glosario — Semana 05: ER Avanzado

> Términos técnicos introducidos esta semana, ordenados alfabéticamente.

---

## C

### `class table inheritance` (CTI)
Estrategia de implementación de herencia en BD relacionales. Se crea una tabla para el
supertipo con los atributos comunes y una tabla por cada subtipo. La clave primaria del
subtipo es también clave foránea al supertipo, estableciendo una relación 1-1.

```sql
-- Supertipo
CREATE TABLE vehicles (vehicle_id UUID PRIMARY KEY, vehicle_brand VARCHAR(80) NOT NULL);
-- Subtipo: PK = FK (CTI)
CREATE TABLE cars (vehicle_id UUID PRIMARY KEY REFERENCES vehicles(vehicle_id), car_doors SMALLINT NOT NULL);
```

### `cobertura` / `coverage`
Restricción que indica si **todos** los elementos del supertipo deben pertenecer a
algún subtipo (`total`) o si pueden existir instancias del supertipo sin subtipo
asignado (`parcial`).

| Tipo | Significado | Notación ER |
|---|---|---|
| Total | Todo supertipo tiene subtipo | Doble línea entre IS-A y supertipo |
| Parcial | El subtipo es opcional | Línea simple entre IS-A y supertipo |

### `concrete table inheritance`
Estrategia de herencia donde **cada subtipo tiene su propia tabla independiente**
con todos los atributos (propios + heredados del supertipo). No existe tabla para el
supertipo. Problema: duplicación de columnas y dificultad para consultar todos los
subtipos juntos.

---

## D

### `discriminador` / `discriminator column`
Columna en la tabla del supertipo que indica a qué subtipo pertenece cada fila.
Utilizada en la estrategia `single table inheritance`.

```sql
-- Columna discriminadora en STI
CREATE TABLE staff (
    staff_id   UUID PRIMARY KEY,
    staff_type VARCHAR(10) NOT NULL CHECK (staff_type IN ('doctor', 'nurse', 'admin'))
);
```

### `disyunción` / `disjointness`
Restricción que define si una instancia del supertipo puede pertenecer a **uno solo**
de los subtipos (`exclusiva`) o a **varios subtipos simultáneamente** (`inclusiva`).

| Tipo | Significado | Notación ER |
|---|---|---|
| Exclusiva "d" | Un solo subtipo activo | Círculo con letra "d" en la IS-A |
| Inclusiva "o" | Múltiples subtipos posibles | Círculo con letra "o" en la IS-A |

---

## E

### `especialización` / `specialization`
Proceso **top-down** (de arriba a abajo) de diseño ER. Partiendo de una entidad general
(supertipo), se identifican subgrupos con atributos propios y se crean subtipos.

> Ejemplo: partiendo de `EMPLEADO`, se identifican los subtipos `MÉDICO`, `ENFERMERO`,
> `ADMINISTRATIVO`.

---

## G

### `generalización` / `generalization`
Proceso **bottom-up** (de abajo a arriba) de diseño ER. Partiendo de múltiples entidades
similares, se abstraen los atributos comunes en un supertipo.

> Ejemplo: al observar que `AUTOMÓVIL`, `CAMIÓN` y `MOTOCICLETA` comparten marca, año y
> placa, se crea el supertipo `VEHÍCULO`.

---

## H

### `herencia` / `inheritance`
Mecanismo de modelado donde un subtipo **hereda** todos los atributos y relaciones
de su supertipo, además de tener los suyos propios.

En diseño de BD relacionales, la herencia no es nativa — se implementa con patrones
como STI, CTI o Concrete Table Inheritance.

---

## I

### `IS-A`
Relación jerárquica entre un supertipo y sus subtipos. Se lee como:
*"MÉDICO IS-A EMPLEADO"* (un médico ES UN empleado).

En diagramas ER, se representa con un triángulo o círculo rotulado `IS-A` entre el
supertipo y los subtipos.

### `inclusiva` (disyunción)
Ver `disyunción`. Una instancia puede pertenecer a **múltiples subtipos** al mismo tiempo.

> Ejemplo: `USUARIO` puede ser `COMPRADOR` y `VENDEDOR` simultáneamente en un marketplace.

---

## O

### `overlapping` (subtipos solapados)
Sinónimo de disyunción inclusiva. Los subtipos se "solapan" porque una misma instancia
puede pertenecer a más de uno.

---

## P

### `parcial` (cobertura)
Ver `cobertura`. Una instancia del supertipo puede **no tener** subtipo asignado.

> Ejemplo: `PERSONA` puede ser solo persona sin ser `EMPLEADO` ni `CLIENTE`.

### `partición`
Caso especial de cobertura **total** + disyunción **exclusiva**. El conjunto de subtipos
forma una partición perfecta del supertipo: cada instancia pertenece a exactamente uno.

> Ejemplo: `EMPLEADO` → `{TIEMPO_COMPLETO, MEDIO_TIEMPO}` con cobertura total y exclusiva.

---

## S

### `single table inheritance` (STI)
Estrategia de herencia donde **toda la jerarquía** se almacena en una sola tabla.
Se usa una columna discriminadora para identificar el tipo. Las columnas de subtipos
quedan `NULL` para los tipos que no las usan.

```sql
-- Toda la jerarquía en una tabla
CREATE TABLE persons (
    person_id   UUID PRIMARY KEY,
    person_type VARCHAR(10) NOT NULL,  -- discriminador
    -- Atributos del supertipo
    person_name VARCHAR(100) NOT NULL,
    -- Atributos de subtipo DOCTOR (null para otros tipos)
    doctor_specialty VARCHAR(80),
    -- Atributos de subtipo PATIENT (null para otros tipos)
    patient_record_number VARCHAR(20)
);
```

### `supertipo` / `supertype`
La entidad genérica en la parte superior de una jerarquía IS-A. Contiene los atributos
compartidos por todos los subtipos.

### `subtipo` / `subtype`
Una especialización del supertipo. Tiene todos los atributos del supertipo más los
propios. En CTI, se implementa como una tabla cuya PK es también FK al supertipo.

---

## T

### `total` (cobertura)
Ver `cobertura`. Toda instancia del supertipo **debe** pertenecer a al menos un subtipo.
No puede existir una instancia del supertipo "sin clasificar".

> Ejemplo: en el sistema del hospital, todo `STAFF` debe ser `DOCTOR`, `NURSE` o `ADMIN`.

---

← [README](../README.md)

