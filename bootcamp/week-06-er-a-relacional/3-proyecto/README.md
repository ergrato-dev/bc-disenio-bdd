# Proyecto Semana 06 — ConnectPro: Modelo Relacional

> **Fase:** Modelo Lógico &nbsp;|&nbsp; **Semana:** 06 de 14
> **Duración estimada:** ~2 horas

## Contexto del Negocio

En la Semana 05 diseñaste el diagrama ER de **ConnectPro**, una red social profesional.
Modelaste entidades como `USER`, `COMPANY`, `JOB_POSTING`, `EXPERIENCE`, la jerarquía
IS-A de tipos de cuenta (`FREE_ACCOUNT`, `PREMIUM_ACCOUNT`, `RECRUITER_ACCOUNT`), y las
relaciones reflexivas N:M de conexiones y seguimiento entre usuarios.

En esta semana aplicarás las **7 reglas de transformación ER → Relacional** para
convertir ese modelo conceptual en un **modelo relacional completo** expresado en DBML,
documentando cada decisión de diseño.

---

## Objetivo

Transformar el diagrama ER de ConnectPro en un modelo relacional completo usando las
reglas vistas en la Semana 06, con justificación explícita de cada decisión.

---

## Requerimientos Funcionales

| # | Elemento ER | Regla | Decisión esperada |
|---|---|---|---|
| RF-01 | `USER` (entidad fuerte) | R1 | Tabla `users` con atributos simples |
| RF-02 | `ACCOUNT_TYPE` IS-A (TOTAL + EXCLUSIVA) | R7 — CTI | Tabla `users` + tablas `free_accounts`, `premium_accounts`, `recruiter_accounts` |
| RF-03 | `COMPANY` (entidad fuerte) | R1 | Tabla `companies` |
| RF-04 | `JOB_POSTING` (entidad fuerte) | R1 | Tabla `job_postings` |
| RF-05 | `EXPERIENCE` (entidad débil de USER) | R2 | Tabla `experiences` con FK `user_id` NOT NULL + ON DELETE CASCADE |
| RF-06 | `USER` ← trabaja_en → `COMPANY` (1:N) | R4 | FK `company_id` en `users` (lado N) |
| RF-07 | `COMPANY` ← publica → `JOB_POSTING` (1:N) | R4 | FK `company_id` en `job_postings` |
| RF-08 | `USER` ← postula_a → `JOB_POSTING` (N:M) | R5 | Tabla de intersección `job_applications` |
| RF-09 | `USER` ← conecta_con → `USER` (N:M reflexiva) | R5 | Tabla `connections(user_id_a, user_id_b)` + CHECK sin auto-conexión |
| RF-10 | `USER` ← publica → `POST` (1:N) | R4 | FK `author_user_id` en `posts` |

### Restricciones de diseño

- Todas las tablas usan `UUID DEFAULT gen_random_uuid()` como PK
- Columnas auto-documentadas con prefijo de entidad (`user_name`, `post_content`, etc.)
- Toda FK declara `ON DELETE` explícitamente con justificación en un comentario
- El modelo DBML refleja fielmente las cardinalidades del ER de la Semana 05
- Constraints con nombre explícito: `pk_`, `fk_`, `uq_`, `ck_`

---

## Entregables

| Archivo | Descripción |
|---|---|
| `starter/connectpro-relacional.dbml` | Modelo relacional completo en DBML |

---

## Instrucciones

### 1. Prepara tu entorno

Abre `starter/connectpro-relacional.dbml` en [dbdiagram.io](https://dbdiagram.io).

### 2. Aplica cada regla en orden

Para cada elemento del ER, identifica la regla correspondiente y completa el DBML:

```
R1 → entidades fuertes (users, companies, posts, job_postings)
R2 → entidades débiles (experiences)
R4 → relaciones 1:N (company → users, company → job_postings, user → posts)
R5 → relaciones N:M (user ↔ user connections, user → job_applications)
R7 → jerarquía IS-A de tipos de cuenta (CTI)
```

### 3. Documenta tus decisiones

En el archivo DBML, agrega un comentario `// Decision:` sobre cada tabla o referencia
que implique una elección de diseño. Por ejemplo:

```dbml
// Decision R4: FK en users (lado N) ya que un usuario pertenece a una sola empresa.
// ON DELETE SET NULL porque el usuario permanece aunque la empresa se elimine.
Table users {
  user_id    uuid [pk, default: `gen_random_uuid()`]
  company_id uuid [ref: > companies.company_id, note: "nullable — usuario puede ser independiente"]
  ...
}
```

### 4. Verifica la consistencia con el ER de Semana 05

Compara tu DBML con el diagrama ER de la Semana 05:
- ¿Cada entidad tiene su tabla?
- ¿Cada relación N:M tiene su tabla de intersección?
- ¿Los subtipos de IS-A están representados con CTI (PK = FK)?

---

## Criterios de Evaluación

| Criterio | Peso |
|---|---|
| Todas las entidades transformadas correctamente (R1/R2) | 25% |
| Jerarquía IS-A con CTI implementada (R7) | 25% |
| Relaciones 1:N con FK correcta (R4) | 20% |
| Tabla de intersección N:M con PK compuesta o UUID+UNIQUE (R5) | 15% |
| ON DELETE explícito con justificación en comentario | 10% |
| Nomenclatura auto-documentada y constraints con nombre | 5% |

---

← [Práctica Semana 06](../2-practicas/README.md) &nbsp;&nbsp;|&nbsp;&nbsp; [→ Semana 07](../../week-07-normalizacion-i/README.md)
