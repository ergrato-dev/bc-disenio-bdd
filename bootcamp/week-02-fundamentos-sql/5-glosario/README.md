# Glosario — Semana 02: Fundamentos SQL de consulta

Términos técnicos ordenados alfabéticamente.

---

## A

**Agregación** (`aggregation`)
Operación que resume múltiples filas en un único valor. Las funciones de agregación
en SQL son `COUNT`, `SUM`, `AVG`, `MIN` y `MAX`.

```sql
SELECT COUNT(*), AVG(price) FROM products;
```

**Alias** (`alias`)
Nombre alternativo asignado a una columna o tabla con la cláusula `AS`. Mejora
la legibilidad del resultado y es obligatorio cuando hay columnas calculadas.

```sql
SELECT price * 1.16 AS precio_con_iva FROM products;
```

**Anti-join**
Patrón de consulta que devuelve filas de una tabla que **no tienen** correspondencia
en otra tabla. Se implementa con `LEFT JOIN` + `WHERE col IS NULL`.

```sql
SELECT c.* FROM customers c LEFT JOIN orders o ON o.customer_id = c.id WHERE o.id IS NULL;
```

---

## B

**BETWEEN**
Operador de rango que evalúa si un valor está entre dos límites, ambos inclusivos.

```sql
WHERE price BETWEEN 100 AND 500
-- equivale a: WHERE price >= 100 AND price <= 500
```

---

## C

**COALESCE**
Función que devuelve el primer argumento no-NULL de una lista. Esencial para
asignar valores por defecto cuando una columna puede ser NULL.

```sql
SELECT COALESCE(phone, 'Sin teléfono') AS contacto FROM customers;
```

**COUNT**
Función de agregación que cuenta filas. `COUNT(*)` cuenta todas las filas;
`COUNT(col)` ignora los NULL de esa columna.

```sql
SELECT COUNT(*) AS total, COUNT(phone) AS con_telefono FROM customers;
```

**CROSS JOIN**
Tipo de JOIN que produce el producto cartesiano: cada fila de la tabla A con
cada fila de la tabla B. Sin condición ON. Raramente usado en producción.

---

## D

**DISTINCT**
Cláusula que elimina filas duplicadas del resultado de un SELECT.

```sql
SELECT DISTINCT city FROM customers;
```

---

## F

**FROM**
Cláusula obligatoria que especifica la(s) tabla(s) de donde provienen los datos.
Es la primera en el orden de evaluación del motor SQL.

**FULL JOIN** (`FULL OUTER JOIN`)
Tipo de JOIN que devuelve todas las filas de ambas tablas, con NULL donde no
hay correspondencia. Equivale a la unión de LEFT JOIN y RIGHT JOIN.

---

## G

**GROUP BY**
Cláusula que divide las filas en grupos según los valores de una o más columnas
y aplica funciones de agregación a cada grupo.

```sql
SELECT category_id, COUNT(*) FROM products GROUP BY category_id;
```

---

## H

**HAVING**
Cláusula que filtra **grupos** después de aplicar `GROUP BY`. Equivale a un `WHERE`
para resultados de funciones de agregación.

```sql
SELECT category_id, COUNT(*) FROM products GROUP BY category_id HAVING COUNT(*) > 5;
```

---

## I

**ILIKE**
Variante de `LIKE` en PostgreSQL que no distingue entre mayúsculas y minúsculas.

```sql
WHERE name ILIKE '%laptop%'  -- encuentra "Laptop", "LAPTOP", "laptop"
```

**INNER JOIN**
Tipo de JOIN que devuelve solo las filas que tienen correspondencia en **ambas**
tablas. Es el tipo de JOIN más común. `JOIN` a secas equivale a `INNER JOIN`.

**IS NULL / IS NOT NULL**
Operadores para comparar con NULL. La comparación `= NULL` siempre produce
`UNKNOWN`; se debe usar `IS NULL` en su lugar.

---

## L

**LEFT JOIN** (`LEFT OUTER JOIN`)
Tipo de JOIN que devuelve **todas** las filas de la tabla izquierda (FROM),
más las coincidencias de la tabla derecha. Donde no hay coincidencia, las columnas
de la derecha son NULL.

**LIKE**
Operador de comparación de patrones de texto. Usa `%` para cualquier secuencia
de caracteres y `_` para exactamente un carácter.

```sql
WHERE sku LIKE 'PRD-%'  -- empieza con "PRD-"
```

**LIMIT**
Cláusula que restringe la cantidad de filas devueltas por una consulta.
Siempre usar junto a `ORDER BY` para resultados consistentes.

---

## N

**NULL**
Marcador especial que representa un valor desconocido, ausente o no aplicable.
No es cero, no es cadena vacía. Cualquier operación con NULL produce NULL.

**NULLIF**
Función que devuelve NULL si los dos argumentos son iguales; de lo contrario,
devuelve el primer argumento. Útil para evitar división por cero.

```sql
SELECT total / NULLIF(quantity, 0) AS precio_unitario FROM order_items;
```

---

## O

**OFFSET**
Cláusula que salta N filas antes de empezar a devolver resultados. Se usa junto
a `LIMIT` para implementar paginación.

```sql
-- Página 3 de resultados (10 por página)
LIMIT 10 OFFSET 20
```

**ORDER BY**
Cláusula que especifica el orden del resultado. `ASC` (ascendente) es el default;
`DESC` es descendente. Soporta `NULLS FIRST` / `NULLS LAST`.

---

## P

**Paginación** (`pagination`)
Técnica para dividir resultados de una consulta en páginas de N filas.
Se implementa con `LIMIT` + `OFFSET` + `ORDER BY`.

**Predicado de JOIN** (`join predicate`)
La condición `ON ...` que especifica cómo se relacionan las filas de dos tablas
en un JOIN. Casi siempre es una igualdad entre clave foránea y clave primaria.

**Proyección** (`projection`)
Selección de las columnas específicas que se quieren ver en el resultado de un SELECT.
Contrario a `SELECT *` que proyecta todas las columnas.

---

## R

**RIGHT JOIN** (`RIGHT OUTER JOIN`)
Tipo de JOIN que devuelve todas las filas de la tabla derecha más las coincidencias
de la izquierda. Se puede reescribir siempre como LEFT JOIN con tablas invertidas.

---

## S

**Self JOIN**
JOIN en el que una tabla se une a sí misma. Requiere usar alias distintos.
Útil para relaciones reflexivas (empleado → supervisor, categoría → subcategoría).

```sql
SELECT e.full_name, m.full_name AS supervisor
FROM employees e LEFT JOIN employees m ON m.id = e.manager_id;
```

**SELECT**
Sentencia SQL para consultar datos. Puede incluir proyección, filtros, JOINs,
ordenamiento, paginación y agregación. Es la instrucción DML más utilizada.

**SUM**
Función de agregación que suma los valores numéricos de un grupo. Ignora NULL.

---

## U

**UNKNOWN**
Tercer valor lógico en SQL (junto a TRUE y FALSE). Resultado de cualquier
comparación que involucre NULL. En WHERE, UNKNOWN se trata como FALSE.

---

## W

**WHERE**
Cláusula que filtra filas **antes** de agrupar. Acepta cualquier expresión
booleana. Se evalúa después de FROM y antes de GROUP BY en el motor SQL.

---

← [README Semana 02](../README.md)

*Última actualización: Semana 02 · Fundamentos*
