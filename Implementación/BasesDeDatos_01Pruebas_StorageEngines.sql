-- Motores de almacenamiento (STORAGE ENGINES) 
/* Motor de almacenamiento: Módulo de software dentro del servidor de la base de datos que se encarga de almacenar, manejar y recuperar información de una tabla. 
   La elección de los motores de almacenamiento se realiza a nivel de tabla. No afecta al modo en que el servidor interactúa con el cliente.
 */
-- Muestra los motores de almacenamiento
SHOW ENGINES;
-- Muestra el motor de almacenamiento por defecto
SELECT @@default_storage_engine;

CREATE DATABASE IF NOT EXISTS pruebas;
USE pruebas;
/* **** Código de una única ejecución **** */
CREATE TABLE IF NOT EXISTS tablaPrimaria (
   clavePri_tp    CHAR(5), 	
   atributo_tp VARCHAR(20)
);
CREATE TABLE IF NOT EXISTS tablaSecundaria (
   clavePri_ts  CHAR(5),
   atributo1_ts CHAR(5),
   atributo2_ts VARCHAR(20)
);
ALTER TABLE tablaPrimaria 
   ADD CONSTRAINT tablaPrimariaPK PRIMARY KEY (clavePri_tp);
ALTER TABLE tablaSecundaria
   ADD CONSTRAINT tablaSecundariaFK FOREIGN KEY (atributo1_ts)
   REFERENCES tablaPrimaria(clavePri_tp);
-- Revisión de los índices de las tablas
/* MySQL Reference Manual: MySQL requires that foreign key columns be indexed; if you create a table with a 
   foreign key constraint but no index on a given column, an index is created. */
/* *************************************** */
-- Muestra un comando CREATE TABLE que crea la tabla especificada
SHOW CREATE TABLE tablaPrimaria;
-- Muestra el motor de almacenamiento de la tabla especificada
SELECT ENGINE 
   FROM information_schema.TABLES
   WHERE TABLE_NAME='tablaPrimaria' AND TABLE_SCHEMA='pruebas';
-- Integridad referencial
-- INSERT INTO tablaSecundaria (clavePri_ts,atributo1_ts,atributo2_ts) VALUE ('11111','abcde','ABCDE'); 
   /* Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails */
-- Revisión de la carpeta de almacenamiento de las tablas: C:\ProgramData\MySQL\MySQL Server 8.0\Data\pruebas

-- Modificación del motor de almacenamiento de la tabla especificada
-- MyISAM no soporta la definición de claves ajenas. 
   /* Error Code: 1217. Cannot delete or update a parent row: a foreign key constraint fails */
ALTER TABLE tablaSecundaria -- Eliminación de las claves ajenas relacionadas
   DROP FOREIGN KEY tablaSecundariaFK;
ALTER TABLE tablaPrimaria ENGINE=MyISAM;
-- Revisión de la carpeta de almacenamiento de las tablas: C:\ProgramData\MySQL\MySQL Server 8.0\Data\pruebas
-- CSV no soporta la definición de índices.
   /* Error Code: 1069. Too many keys specified; max 0 keys allowed	*/
DROP INDEX tablaSecundariaFK ON tablaSecundaria; -- Eliminación de los índices relacionados
-- CSV no soporta la definición de columnas con valores nulos.
   /* Error Code: 1178. The storage engine for the table doesn't support nullable columns */
ALTER TABLE tablaSecundaria -- Modificación de las columnas con valores nulos
   MODIFY COLUMN clavePri_ts CHAR(5) NOT NULL;
ALTER TABLE tablaSecundaria
   MODIFY COLUMN atributo1_ts VARCHAR(20) NOT NULL;
ALTER TABLE tablaSecundaria
   MODIFY COLUMN atributo2_ts VARCHAR(20) NOT NULL;
ALTER TABLE tablaSecundaria ENGINE=CSV;
INSERT INTO tablaSecundaria (clavePri_ts,atributo1_ts,atributo2_ts) VALUE ('11111','abcde','ABCDE'); 
-- Revisión de la carpeta de almacenamiento de las tablas: C:\ProgramData\MySQL\MySQL Server 8.0\Data\pruebas

-- Muestra el motor de almacenamiento de la tabla especificada
SELECT ENGINE 
   FROM information_schema.TABLES
   WHERE TABLE_NAME='tablaPrimaria' AND TABLE_SCHEMA='pruebas';
SELECT ENGINE 
   FROM information_schema.TABLES
   WHERE TABLE_NAME='tablaSecundaria' AND TABLE_SCHEMA='pruebas';
-- Revisión de la carpeta de almacenamiento de las tablas: C:\ProgramData\MySQL\MySQL Server 8.0\Data\pruebas