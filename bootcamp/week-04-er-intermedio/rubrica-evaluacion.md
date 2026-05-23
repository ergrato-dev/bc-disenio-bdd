# Rúbrica de Evaluación — Semana 04: ER Intermedio

## Criterios de Evaluación

### 🧠 Conocimiento (30%) — Cuestionario teórico

| Criterio | Excelente (100%) | Satisfactorio (70%) | En desarrollo (<70%) |
| -------- | ---------------- | ------------------- | -------------------- |
| Atributos multivaluados y compuestos | Distingue ambos tipos, explica el impacto en el modelo físico y cuándo crear tabla separada vs columna | Distingue los tipos con alguna imprecisión en la transformación al modelo físico | Confunde multivaluado con compuesto o no sabe cómo transformarlos |
| Entidades débiles | Define entidad débil, identifica la clave parcial, la relación de identificación y el impacto en la PK física | Define el concepto con algún error en la representación Crow's Foot o la PK compuesta | No puede identificar entidades débiles o confunde con entidad fuerte |
| Relaciones ternarias | Distingue cuándo se necesita una ternaria vs dos binarias, y cómo leer su cardinalidad | Identifica la ternaria pero tiene dificultad para justificar su necesidad frente a binarias | Confunde la ternaria con la binaria o no puede definirla |
| Entidad asociativa | Explica cuándo promover una relación N:M a entidad y enumera 3+ atributos que la justifican | Identifica el patrón con alguna imprecisión sobre cuándo promover | No distingue la entidad asociativa de una relación N:M simple |

### 💪 Desempeño (40%) — Ejercicios prácticos

| Criterio | Excelente (100%) | Satisfactorio (70%) | En desarrollo (<70%) |
| -------- | ---------------- | ------------------- | -------------------- |
| Identificación de atributos multivaluados | Identifica correctamente todos los atributos multivaluados del dominio y los transforma en tablas separadas con FK correcta | Identifica la mayoría; alguna transformación con FK incorrecta o faltante | No identifica los atributos multivaluados o no sabe transformarlos |
| Modelado de entidades débiles | Ubica correctamente las entidades débiles, define la clave parcial y la relación de identificación con `\|\|` obligatorio | Modela la entidad débil con algún error en la participación del lado fuerte | No puede modelar la relación de identificación o la clave parcial |
| Representación de relaciones ternarias | Dibuja la ternaria correctamente en draw.io con cardinalidad en los tres extremos y la etiqueta de relación | Dibuja la ternaria con algún error en cardinalidad o sin etiqueta | No logra representar la ternaria o la reduce a binarias incorrectamente |

### 📦 Producto (30%) — Proyecto semanal

| Criterio | Excelente (100%) | Satisfactorio (70%) | En desarrollo (<70%) |
| -------- | ---------------- | ------------------- | -------------------- |
| Completitud del diagrama | El diagrama incluye todas las entidades, la entidad débil, la relación ternaria y la entidad asociativa con sus atributos | La mayoría de los elementos presentes; faltan uno o dos atributos o una relación secundaria | Faltan entidades clave, la ternaria o la entidad débil |
| Decisiones de diseño documentadas | La hoja de análisis justifica cada decisión no trivial (entidad débil, ternaria, asociativa) con referencia al enunciado | La mayoría de decisiones justificadas; alguna sin referencia al enunciado | Las decisiones no están justificadas o son contradictorias con el enunciado |
| Calidad del diagrama | Diagrama legible, entidades nombradas en inglés, cardinalidades visibles, exportado correctamente como SVG | Diagrama funcional con algunos problemas de legibilidad o nomenclatura | Diagrama ilegible, sin cardinalidades o no exportado |

## Calificación

| Criterio       | Peso | Nota (0–100) | Ponderado |
| -------------- | ---- | ------------ | --------- |
| Conocimiento   | 30%  |              |           |
| Desempeño      | 40%  |              |           |
| Producto       | 30%  |              |           |
| **TOTAL**      |      |              |           |

> Nota mínima de aprobación: **70** en cada criterio
