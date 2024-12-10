-- Conjuntos de caracteres (CHARACTER SET) y cotejamientos (COLLATION)
/* Conjunto de caracteres: Conjunto de los caracteres que son legales en una cadena y sus codificaciones.
   Cotejamiento: Conjunto de reglas para comparar caracteres dentro de un conjunto de caracteres.
 */
-- Muestra los conjuntos de caracteres instalados
SHOW CHARACTER SET; 
-- Muestra los cotejamientos instalados
SHOW COLLATION;

CREATE DATABASE IF NOT EXISTS pruebas;
USE pruebas;
-- Ejemplo 1
/* **** Código de una única ejecución **** */
CREATE TABLE IF NOT EXISTS pruebaCollation (
   nombre_utf1   CHAR(5) CHARSET utf8 COLLATE utf8_general_ci,
   nombre_utf2   CHAR(5) CHARSET utf8 COLLATE utf8_bin,
   nombre_ascii1 CHAR(5) CHARSET ascii COLLATE ascii_general_ci,  
   nombre_ascii2 CHAR(5) CHARSET ascii COLLATE ascii_bin,
   nombre_latin1 CHAR(5) CHARSET latin1 COLLATE latin1_general_ci, 
   nombre_latin2 CHAR(5) CHARSET latin1 COLLATE latin1_bin
);
-- El CHARSET ascii no permite insertar cadenas de caracteres con tildes o con ñ.
INSERT INTO pruebaCollation VALUES ('Ñandú','Ñandú','Nandu','Nandu','Ñandú','Ñandú');
/* *************************************** */

-- LENGTH(str): Devuelve la longitud de la cadena str, medida en bytes.
-- CHAR_LENGTH(str): Devuelve la longitud de la cadena str, medida en caracteres.
SELECT nombre_utf1, LENGTH(nombre_utf1) AS longitud_bytes, CHAR_LENGTH(nombre_utf1) AS longitud_caracteres 
   FROM pruebaCollation;
SELECT nombre_ascii1, LENGTH(nombre_ascii1) AS longitud_bytes, CHAR_LENGTH(nombre_ascii1) AS longitud_caracteres 
   FROM pruebaCollation;
SELECT nombre_latin1, LENGTH(nombre_latin1) AS longitud_bytes, CHAR_LENGTH(nombre_latin1) AS longitud_caracteres 
   FROM pruebaCollation;  

-- El cotejamiento utf8_general_ci compara cadenas usando reglas generales del idioma y comparaciones que no distinguen entre mayúsculas y minúsculas.
SELECT nombre_utf1 FROM pruebaCollation WHERE nombre_utf1 LIKE 'N%';
SELECT nombre_utf1 FROM pruebaCollation WHERE nombre_utf1 LIKE 'Ñ%';
SELECT nombre_utf1 FROM pruebaCollation WHERE nombre_utf1 LIKE 'ñ%';
-- El cotejamiento utf8_bin compara cadenas por el valor binario de cada carácter en la cadena.
SELECT nombre_utf2 FROM pruebaCollation WHERE nombre_utf2 LIKE 'N%';
SELECT nombre_utf2 FROM pruebaCollation WHERE nombre_utf2 LIKE 'Ñ%';
SELECT nombre_utf2 FROM pruebaCollation WHERE nombre_utf2 LIKE 'ñ%';

-- Ejemplo 2
/* **** Código de una única ejecución **** */
CREATE TABLE IF NOT EXISTS pruebaSpanishCollation (
    nombre1 VARCHAR(15) CHARSET utf8 COLLATE utf8_spanish_ci,
    nombre2 VARCHAR(15) CHARSET utf8 COLLATE utf8_spanish2_ci
);
INSERT INTO pruebaSpanishCollation VALUES ('baño','baño'),('camino','camino'),('cruce','cruce'),('dedo','dedo'),
                                          ('chuche','chuche'),('llamar','llamar'),('lámina','lámina'),('lobo','lobo');
/* *************************************** */

SELECT * FROM pruebaSpanishCollation;
-- El cotejamiento utf8_spanish_ci se ocupa del español moderno. 
SELECT * FROM pruebaSpanishCollation ORDER BY nombre1;
-- El cotejamiento utf8_spanish2_ci se ocupa del español tradicional.
SELECT * FROM pruebaSpanishCollation ORDER BY nombre2;