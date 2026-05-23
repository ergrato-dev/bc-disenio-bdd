# Rúbrica de Evaluación — Semana 02: Fundamentos SQL de consulta

## Criterios de Evaluación

### 🧠 Conocimiento (30%) — Cuestionario teórico

| Criterio | Excelente (100%) | Satisfactorio (70%) | En desarrollo (<70%) |
| -------- | ---------------- | ------------------- | -------------------- |
| SELECT y filtros | Explica cláusulas WHERE, ORDER BY, LIMIT/OFFSET con precisión y da ejemplos correctos | Explica las cláusulas principales con algún error menor | Confunde la sintaxis o no distingue ORDER BY de WHERE |
| Tipos de JOIN | Diferencia correctamente INNER, LEFT, RIGHT y FULL JOIN; identifica cuándo usar cada uno | Distingue INNER de LEFT JOIN pero confunde los demás | No puede distinguir el comportamiento de los distintos JOINs |
| NULL y comparaciones | Explica que NULL ≠ NULL, usa IS NULL/IS NOT NULL y COALESCE correctamente | Sabe que NULL es especial pero comete errores con IS NULL | Usa `= NULL` como si fuera una comparación válida |
| Agregación | Usa GROUP BY, HAVING y las funciones COUNT/SUM/AVG/MIN/MAX correctamente | Usa funciones de agregación pero confunde WHERE con HAVING | No puede escribir una consulta con GROUP BY funcional |

### 💪 Desempeño (40%) — Ejercicios prácticos

| Criterio | Excelente (100%) | Satisfactorio (70%) | En desarrollo (<70%) |
| -------- | ---------------- | ------------------- | -------------------- |
| Corrección técnica | Todos los ejercicios ejecutan sin errores en PostgreSQL 16+; resultados correctos | La mayoría ejecutan; errores menores y fácilmente corregibles | Más de la mitad con errores o no ejecutan |
| Uso de JOINs | Elige siempre el JOIN correcto; la consulta no genera filas duplicadas ni perdidas inesperadamente | Usa JOINs correctamente en la mayoría de casos con alguna confusión | No elige el JOIN adecuado o no comprende el resultado |
| Calidad del código | SQL formateado (keywords en mayúsculas, indentación), comentado en español, alias descriptivos | Formateado aceptable; algunas convenciones omitidas | Sin formato, sin comentarios, identificadores crípticos |

### 📦 Producto (30%) — Proyecto semanal

| Criterio | Excelente (100%) | Satisfactorio (70%) | En desarrollo (<70%) |
| -------- | ---------------- | ------------------- | -------------------- |
| Completitud | Las 10 consultas presentes, funcionales y con resultado correcto en PostgreSQL 16+ | 7–9 consultas correctas; las restantes con error menor | Menos de 7 consultas o errores que invalidan el resultado |
| Respuesta a la pregunta de negocio | Cada consulta responde con exactitud la pregunta planteada; columnas con alias descriptivos | La mayoría responde la pregunta; algunas columnas sin alias o con alias poco claros | Las consultas devuelven datos pero no responden la pregunta |
| Documentación | Cada consulta tiene comentario explicando la lógica y el resultado esperado | La mayoría de consultas comentadas | Sin comentarios o comentarios que no aportan comprensión |

## Calificación

| Criterio       | Peso | Nota (0–100) | Ponderado |
| -------------- | ---- | ------------ | --------- |
| Conocimiento   | 30%  |              |           |
| Desempeño      | 40%  |              |           |
| Producto       | 30%  |              |           |
| **TOTAL**      |      |              |           |

> Nota mínima de aprobación: **70** en cada criterio
