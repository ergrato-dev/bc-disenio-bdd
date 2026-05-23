-- ============================================
-- PROYECTO SEMANA 01 — Sistema de Biblioteca
-- Biblioteca Comunitaria "El Saber"
-- ============================================
-- INSTRUCCIONES:
--   1. Lee cada bloque de TODOs con atención
--   2. Descomenta y completa el código de cada sección
--   3. Ejecuta cada bloque UNO POR UNO en pgAdmin/DBeaver
--   4. Verifica que el bloque anterior funciona antes de continuar
-- ============================================


-- ============================================
-- SECCIÓN 0: Preparación
-- ============================================
-- Asegúrate de que estás conectado a 'bootcamp_db'
-- y de que el esquema 'bootcamp' existe.
-- Ejecuta esto para verificar:

SELECT current_database(), current_user;


-- ============================================
-- SECCIÓN 1: Tabla de libros
-- ============================================
-- RF-01: Registrar libros con título, autor,
-- año de publicación e ISBN único de 13 chars.
--
-- Pistas de tipos de datos:
--   - El título puede ser largo → TEXT o VARCHAR(300)
--   - El autor: nombre completo → VARCHAR(150)
--   - El año: un número de 4 dígitos → SMALLINT (cabe en -32k a 32k)
--   - El ISBN: siempre 13 caracteres → CHAR(13) o VARCHAR(13)
--   - La PK: siempre UUID con `DEFAULT gen_random_uuid()`
--
-- TODO: Completa la definición de la tabla books.
--       Debe incluir:
--         - PK con nombre pk_books
--         - constraint UNIQUE en isbn con nombre uq_books_isbn
--         - constraint NOT NULL en title, author
--         - constraint CHECK en publication_year > 0 con nombre ck_books_year_pos

-- CREATE TABLE bootcamp.books (
--     book_id             UUID         DEFAULT gen_random_uuid()
--                                      CONSTRAINT ??? PRIMARY KEY,
--     book_title          ???  NOT NULL,
--     book_author         ???  NOT NULL,
--     book_isbn           ???  ,
--     book_published_year ??? ,
--
--     CONSTRAINT ??? UNIQUE (book_isbn),
--     CONSTRAINT ??? CHECK (book_published_year > 0)
-- );

-- TODO: Agrega un comentario descriptivo a la tabla
-- COMMENT ON TABLE bootcamp.books IS '???';


-- ============================================
-- SECCIÓN 2: Tabla de socios
-- ============================================
-- RF-02: Registrar socios con nombre completo,
-- email único y fecha de registro.
--
-- Pistas:
--   - El email tiene un límite estándar de 254 caracteres (RFC 5321)
--   - La fecha de registro no tiene hora → DATE
--   - El nombre completo: máximo 150 caracteres
--
-- TODO: Completa la definición de la tabla members.
--       Debe incluir:
--         - PK con nombre pk_members
--         - constraint UNIQUE en email con nombre uq_members_email
--         - NOT NULL en full_name y email
--         - registration_date con DEFAULT a la fecha actual

-- CREATE TABLE bootcamp.members (
--     member_id           UUID         DEFAULT gen_random_uuid()
--                                      CONSTRAINT ??? PRIMARY KEY,
--     member_full_name    ???  NOT NULL,
--     member_email        ???  NOT NULL,
--     member_reg_date     ???  NOT NULL DEFAULT ???,
--
--     CONSTRAINT ??? UNIQUE (member_email)
-- );

-- TODO: Agrega un comentario descriptivo a la tabla
-- COMMENT ON TABLE bootcamp.members IS '???';


-- ============================================
-- SECCIÓN 3: Tabla de préstamos
-- ============================================
-- RF-03: Registrar préstamos: qué socio tomó
-- prestado qué libro, en qué fecha y cuándo
-- lo devolvió (puede ser NULL si aún no devuelve).
--
-- Pistas:
--   - Necesita FK a books y FK a members
--   - La fecha de préstamo es solo fecha (no hora) → DATE
--   - La fecha de devolución puede ser NULL → DATE (sin NOT NULL)
--   - ON DELETE RESTRICT en ambas FK: no borrar un libro que esté prestado
--
-- TODO: Completa la definición de la tabla loans.
--       Debe incluir:
--         - PK con nombre pk_loans
--         - FK a books con nombre fk_loans_book_id (ON DELETE RESTRICT)
--         - FK a members con nombre fk_loans_member_id (ON DELETE RESTRICT)
--         - loan_date con DEFAULT a la fecha actual
--         - return_date que permita NULL

-- CREATE TABLE bootcamp.loans (
--     loan_id         UUID         DEFAULT gen_random_uuid()
--                                  CONSTRAINT ??? PRIMARY KEY,
--     book_id         ???  NOT NULL,
--     member_id       ???  NOT NULL,
--     loan_date       ???  NOT NULL DEFAULT ???,
--     return_date     ???  ,
--
--     CONSTRAINT ???
--         FOREIGN KEY (book_id) REFERENCES bootcamp.books(book_id)
--         ON DELETE ???,
--
--     CONSTRAINT ???
--         FOREIGN KEY (member_id) REFERENCES bootcamp.members(member_id)
--         ON DELETE ???
-- );

-- TODO: Agrega un comentario descriptivo a la tabla
-- COMMENT ON TABLE bootcamp.loans IS '???';


-- ============================================
-- SECCIÓN 4: Datos de prueba — Libros
-- ============================================
-- TODO: Inserta al menos 3 libros en bootcamp.books
--       Incluye el ISBN real o uno ficticio de 13 dígitos

-- INSERT INTO bootcamp.books (book_title, book_author, book_isbn, book_published_year) VALUES
--     ('???', '???', '???', ???),
--     ('???', '???', '???', ???),
--     ('???', '???', '???', ???);


-- ============================================
-- SECCIÓN 5: Datos de prueba — Socios
-- ============================================
-- TODO: Inserta al menos 2 socios en bootcamp.members

-- INSERT INTO bootcamp.members (member_full_name, member_email) VALUES
--     ('???', '???'),
--     ('???', '???');


-- ============================================
-- SECCIÓN 6: Datos de prueba — Préstamos
-- ============================================
-- TODO: Inserta al menos 2 préstamos en bootcamp.loans
--       Uno con return_date (ya devuelto) y otro sin (todavía prestado)

-- INSERT INTO bootcamp.loans (book_id, member_id, loan_date, return_date) VALUES
--     ('???', '???', '????-??-??', '????-??-??'),   -- ya devuelto
--     ('???', '???', '????-??-??', NULL);            -- aún prestado


-- ============================================
-- SECCIÓN 7: Verificación
-- ============================================
-- Ejecuta estas consultas para verificar que todo funciona

-- Ver todos los libros
SELECT * FROM bootcamp.books ORDER BY book_title;

-- Ver todos los socios
SELECT * FROM bootcamp.members ORDER BY member_full_name;

-- Ver todos los préstamos con información del libro y el socio
SELECT
    l.loan_id               AS prestamo_id,
    b.book_title            AS libro,
    m.member_full_name      AS socio,
    l.loan_date             AS fecha_prestamo,
    l.return_date           AS fecha_devolucion,
    CASE
        WHEN l.return_date IS NULL THEN 'En préstamo'
        ELSE 'Devuelto'
    END                     AS estado
FROM bootcamp.loans    AS l
JOIN bootcamp.books    AS b  ON b.book_id   = l.book_id
JOIN bootcamp.members  AS m  ON m.member_id = l.member_id
ORDER BY l.loan_date DESC;
