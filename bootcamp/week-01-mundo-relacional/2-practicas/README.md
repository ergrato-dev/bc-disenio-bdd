# Prácticas — Semana 01: El mundo relacional

## Práctica 01 — Levantar el entorno Docker

> **Objetivo:** tener PostgreSQL 16 y pgAdmin funcionando en tu máquina local
> y ejecutar tus primeras consultas SQL.

---

### Paso 1: Crear la estructura de carpetas

Crea esta estructura en tu equipo (fuera del repositorio del bootcamp, en tu área de trabajo):

```
mi-entorno-bootcamp/
├── docker-compose.yml
├── scripts/
│   └── init/
│       └── 01-init.sql
```

---

### Paso 2: Crear el archivo `docker-compose.yml`

Copia el siguiente contenido en tu archivo `docker-compose.yml`:

```yaml
services:
  postgres:
    image: postgres:16-alpine
    container_name: bootcamp_postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB:       bootcamp_db
      POSTGRES_USER:     bootcamp_user
      POSTGRES_PASSWORD: bootcamp_pass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./scripts/init:/docker-entrypoint-initdb.d

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: bootcamp_pgadmin
    restart: unless-stopped
    environment:
      PGADMIN_DEFAULT_EMAIL:    admin@bootcamp.local
      PGADMIN_DEFAULT_PASSWORD: admin
    ports:
      - "5050:80"
    depends_on:
      - postgres

volumes:
  postgres_data:
    name: bootcamp_postgres_data

networks:
  default:
    name: bootcamp-net
```

---

### Paso 3: Crear el script de inicialización

Copia el siguiente contenido en `scripts/init/01-init.sql`:

```sql
-- ============================================
-- INICIALIZACIÓN — Bootcamp Diseño de BDD
-- Se ejecuta automáticamente al crear la BD
-- ============================================

-- Extensión para generar UUIDs
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Esquema de trabajo del bootcamp
CREATE SCHEMA IF NOT EXISTS bootcamp
    AUTHORIZATION bootcamp_user;

COMMENT ON DATABASE bootcamp_db IS
    'Base de datos del Bootcamp Diseño de BDD — Semana 01';

COMMENT ON SCHEMA bootcamp IS
    'Esquema de trabajo del bootcamp';
```

---

### Paso 4: Levantar el entorno

Abre una terminal en la carpeta `mi-entorno-bootcamp/` y ejecuta:

```bash
docker compose up -d
```

Espera unos segundos y verifica que los contenedores estén corriendo:

```bash
docker compose ps
```

Deberías ver algo como:

```
NAME                   STATUS          PORTS
bootcamp_pgadmin       running         0.0.0.0:5050->80/tcp
bootcamp_postgres      running         0.0.0.0:5432->5432/tcp
```

Observa cómo el puerto `5050` de tu máquina está mapeado al `80` del contenedor pgAdmin,
y el `5432` de tu máquina al `5432` del contenedor PostgreSQL.

---

### Paso 5: Conectarse desde pgAdmin

1. Abre `http://localhost:5050` en tu navegador
2. Inicia sesión con `admin@bootcamp.local` / `admin`
3. En el panel izquierdo, click derecho sobre **Servers** → **Register → Server...**
4. Pestaña **General**: Name = `Bootcamp`
5. Pestaña **Connection**:
   - Host: `postgres`  ← nombre del servicio Docker, no `localhost`
   - Port: `5432`
   - Database: `bootcamp_db`
   - Username: `bootcamp_user`
   - Password: `bootcamp_pass`
6. Click **Save**

---

### Paso 6: Tu primera consulta SQL

Una vez conectado, abre el **Query Tool** en pgAdmin (Tools → Query Tool) y ejecuta:

```sql
-- Verificar la versión de PostgreSQL
SELECT version();
```

Observa la respuesta: deberías ver `PostgreSQL 16.x`.

```sql
-- Verificar el contexto de conexión
SELECT
    current_database()  AS base_de_datos,
    current_user        AS usuario,
    NOW()               AS fecha_hora_actual;
```

```sql
-- Ver los esquemas disponibles en esta base de datos
SELECT schema_name
FROM information_schema.schemata
ORDER BY schema_name;
```

Observa que aparece el esquema `bootcamp` que creamos en el script de inicialización.

```sql
-- Ver las extensiones instaladas
SELECT name, installed_version, comment
FROM pg_available_extensions
WHERE installed_version IS NOT NULL
ORDER BY name;
```

---

### Paso 7: Crear tu primera tabla

Ejecuta el siguiente script en el Query Tool:

```sql
-- Crear una tabla simple de prueba
CREATE TABLE bootcamp.test_table (
    id          BIGINT      GENERATED ALWAYS AS IDENTITY
                            CONSTRAINT pk_test_table PRIMARY KEY,
    message     TEXT        NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE bootcamp.test_table IS
    'Tabla de prueba — Semana 01';
```

Ahora inserta algunos datos y consúltalos:

```sql
-- Insertar datos de prueba
INSERT INTO bootcamp.test_table (message) VALUES
    ('Hola, PostgreSQL!'),
    ('Mi primera inserción'),
    ('El entorno funciona correctamente');

-- Consultar los datos
SELECT id, message, created_at
FROM bootcamp.test_table
ORDER BY id;
```

Observa que:
- El campo `id` se generó automáticamente (1, 2, 3)
- El campo `created_at` se rellenó con la fecha y hora actuales (con zona horaria)
- El resultado viene ordenado por `id` gracias a `ORDER BY`

---

### Paso 8: Verificar desde la terminal con psql

Desde tu terminal (fuera de pgAdmin), también puedes conectarte directamente:

```bash
docker compose exec postgres psql -U bootcamp_user -d bootcamp_db
```

Dentro de `psql`, ejecuta:

```sql
-- Listar tablas del esquema bootcamp
\dt bootcamp.*

-- Ver la estructura de la tabla
\d bootcamp.test_table

-- Salir de psql
\q
```

---

### Limpieza al terminar

Cuando no necesites el entorno activo, puedes detenerlo:

```bash
# Detener los contenedores (conserva los datos)
docker compose down

# La próxima vez que hagas 'docker compose up -d', los datos siguen ahí
```

Si quieres borrar todo y empezar desde cero:

```bash
# ⚠️ Esto borra TODOS los datos de la base de datos
docker compose down -v
```

---

## ✅ Verificación

Al terminar esta práctica deberías poder responder con **Sí** a todas estas preguntas:

- [ ] ¿Están corriendo los dos contenedores (`docker compose ps`)?
- [ ] ¿Puedes conectarte a pgAdmin en `http://localhost:5050`?
- [ ] ¿El servidor `Bootcamp` aparece conectado en pgAdmin?
- [ ] ¿Ejecutaste `SELECT version()` y viste PostgreSQL 16?
- [ ] ¿Creaste la tabla `bootcamp.test_table` sin errores?
- [ ] ¿Insertaste datos y los consultaste correctamente?

---

## 🔗 Navegación

← [Teoría: Entorno de desarrollo](../1-teoria/04-entorno-desarrollo.md) &nbsp;&nbsp;|&nbsp;&nbsp; [Proyecto →](../3-proyecto/README.md)
