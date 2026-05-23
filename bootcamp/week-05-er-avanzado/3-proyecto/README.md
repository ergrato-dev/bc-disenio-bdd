# Proyecto Semana 05 — Red Social Profesional: ConnectPro

> **Fase:** Modelo Conceptual + Lógico &nbsp;|&nbsp; **Semana:** 05 de 14

## 📋 Contexto del Negocio

**ConnectPro** es una red social profesional (similar a LinkedIn en su versión básica)
que conecta profesionales, empresas y ofertas de trabajo. La plataforma permite a los
usuarios crear perfiles, conectarse entre sí, publicar contenido y postularse a empleos.

El equipo de producto ha definido el MVP (Minimum Viable Product) con las siguientes
capacidades: gestión de usuarios con diferentes roles, perfiles profesionales,
experiencia laboral, conexiones entre usuarios, publicaciones y búsqueda de empleo.

Tu tarea es diseñar el **modelo ER conceptual** completo con jerarquías IS-A,
traducciones a DBML y documentar las decisiones de diseño.

---

## 🎯 Objetivo

Diseñar el modelo ER de ConnectPro aplicando los conceptos de la Semana 05:

- Especialización/generalización con restricciones explícitas
- Representación en draw.io (diagrama ER) y dbdiagram.io (DBML)
- Justificación de cada decisión de diseño

---

## 📐 Requerimientos Funcionales

### RF-01: Usuarios y tipos de cuenta

Todo usuario tiene: nombre completo, email (único), contraseña hasheada, fecha de
registro y foto de perfil (URL). Los usuarios pueden tener **dos tipos de cuenta**:

- **Cuenta Básica**: acceso estándar, sin costo.
- **Cuenta Premium**: tiene fecha de inicio, fecha de fin y tipo de suscripción
  (mensual o anual). Una cuenta puede pasar de básica a premium y viceversa.

> Una misma cuenta puede ser básica en un período y premium en otro,
> pero en un momento dado es uno u otro tipo.

**Restricción de jerarquía USER:** Cobertura total + disyunción exclusiva.
Todo usuario tiene exactamente un tipo de cuenta activa.

---

### RF-02: Tipos de usuario en la plataforma

Además del tipo de cuenta, los usuarios pueden asumir **roles en la plataforma**:

- **PROFESSIONAL**: tiene titular de empleo actual (headline), resumen de perfil y
  sector de industria.
- **RECRUITER**: tiene nombre de la empresa contratante, número de ofertas publicadas
  activas y área de reclutamiento.
- **Un usuario puede ser PROFESSIONAL y RECRUITER al mismo tiempo.**
  (Un reclutador que también tiene un perfil profesional activo.)
- Puede haber usuarios que no tengan ninguno de estos roles (nuevos registros).

**Restricción de jerarquía PLATFORM_ROLE:** Cobertura parcial + disyunción inclusiva.

---

### RF-03: Empresas

Las empresas tienen: nombre, industria, sitio web, descripción y tamaño
(startup, pyme, corporativo). Una empresa puede tener múltiples empleados registrados
en ConnectPro.

---

### RF-04: Experiencia laboral

Un professional puede tener múltiples experiencias laborales. Cada experiencia
registra: empresa (puede ser o no estar en ConnectPro), cargo, fecha de inicio,
fecha de fin (nula si es el empleo actual) y descripción del rol.

---

### RF-05: Conexiones entre usuarios

Los usuarios pueden conectarse entre sí. Una conexión tiene estado: pendiente,
aceptada o rechazada. Una conexión es entre dos usuarios específicos y en un
momento dado solo puede existir una conexión entre el mismo par de usuarios.

---

### RF-06: Publicaciones

Los usuarios pueden crear publicaciones con: contenido de texto, URL de imagen
opcional, fecha de publicación y contador de reacciones. Una publicación puede
ser un comentario de otra publicación (estructura auto-referencial).

---

### RF-07: Ofertas de trabajo

Los recruiters (y empresas) pueden publicar ofertas de trabajo. Una oferta tiene:
título, descripción, ubicación, modalidad (presencial/remoto/híbrido), rango salarial
opcional y estado (activa, cerrada, pausada).

Los professionals pueden postularse a ofertas. Una postulación tiene fecha, estado
(enviada, en revisión, aceptada, rechazada) y carta de presentación opcional.

---

## 📦 Entregables

- [ ] Diagrama ER en draw.io con las jerarquías IS-A correctamente notadas
- [ ] Modelo DBML en dbdiagram.io con todas las tablas y relaciones
- [ ] Archivo `starter/connectpro.dbml` completado
- [ ] Respuestas a las preguntas de diseño en la sección de decisiones

---

## 🚀 Instrucciones

1. Lee todos los requerimientos antes de empezar a dibujar
2. Completa el archivo `starter/connectpro.dbml` siguiendo los `-- TODO:` comments
3. Para el diagrama ER, usa [app.diagrams.net](https://app.diagrams.net)
4. Para el DBML, usa [dbdiagram.io](https://dbdiagram.io)
5. Documenta tus decisiones de diseño en la sección de abajo

---

## 💬 Decisiones de Diseño (completa aquí)

### Jerarquía 1: Tipo de cuenta (ACCOUNT_TYPE)

| Pregunta | Tu respuesta |
|---|---|
| ¿Cobertura total o parcial? | |
| ¿Disyunción exclusiva o inclusiva? | |
| ¿Qué estrategia de implementación elegiste? | |
| ¿Por qué? | |

### Jerarquía 2: Rol en plataforma (PLATFORM_ROLE)

| Pregunta | Tu respuesta |
|---|---|
| ¿Cobertura total o parcial? | |
| ¿Disyunción exclusiva o inclusiva? | |
| ¿Qué estrategia de implementación elegiste? | |
| ¿Por qué? | |

### ¿Debería EXPERIENCE ser entidad débil?

*Escribe tu análisis aquí.*

### ¿Cómo modelarías las conexiones entre usuarios?

*Escribe tu análisis aquí (pista: relación reflexiva).*

---

## ✅ Criterios de Aceptación

- [ ] El diagrama ER incluye al menos 2 jerarquías IS-A con restricciones declaradas
- [ ] El DBML compila sin errores en dbdiagram.io
- [ ] Las tablas usan UUID como PK (`gen_random_uuid()`)
- [ ] Las columnas siguen la convención de nombres auto-documentados
- [ ] Cada `ref` usa el operador correcto según la cardinalidad
- [ ] Las secciones de decisiones de diseño están completadas

---

## 🔗 Referencias

- [dbdiagram.io — DBML Reference](https://dbml.dbdiagram.io/docs/)
- [draw.io — Notación ER](https://www.drawio.com/blog/entity-relationship-diagrams)

← [Práctica Semana 05](../2-practicas/README.md) &nbsp;&nbsp;|&nbsp;&nbsp; [README →](../README.md)

- [Semana 05 — Teoría](../1-teoria/)
- [Semana 05 — Prácticas](../2-practicas/)
- [Documentación PostgreSQL 16](https://www.postgresql.org/docs/16/)
