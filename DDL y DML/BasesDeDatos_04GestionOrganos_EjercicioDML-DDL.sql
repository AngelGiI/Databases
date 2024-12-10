-- 4. Actualización de datos. Parte 3
/* Lenguaje de Modificación de Datos o DML (Data Manipulation Language)
   - LOAD DATA INFILE: Inserción de datos de un archivo.
 */ 
USE gestionOrganos;

-- 1. Definición de tablas
CREATE TABLE IF NOT EXISTS donantes (
   NIF_donante              CHAR(9) NOT NULL,
   nombre_donante           VARCHAR(30) NOT NULL,
   primer_apellido_donante  VARCHAR(30) NOT NULL,
   segundo_apellido_donante VARCHAR(30) NULL
);
CREATE TABLE IF NOT EXISTS receptores (
   NIF_receptor              CHAR(9) NOT NULL,
   nombre_receptor           VARCHAR(30) NOT NULL,
   primer_apellido_receptor  VARCHAR(30) NOT NULL,
   segundo_apellido_receptor VARCHAR(30) NULL
);
CREATE TABLE IF NOT EXISTS organos (
   NIF_donante  CHAR(9) NOT NULL,             
   ID_organo    ENUM('R','H','C','PA','E','I','PU') NOT NULL,
   NIF_receptor CHAR(9) NULL
);
/* ID_organo: riñones (nefrología), hígado (hepatología), corazón (cardiología), 
   páncreas, estómago e intestino (gastroenterología) y pulmones (neumología).
 */
-- 2. Definición de claves primarias
ALTER TABLE donantes
   ADD CONSTRAINT donantesPK PRIMARY KEY (NIF_donante);
ALTER TABLE receptores
   ADD CONSTRAINT receptoresPK PRIMARY KEY (NIF_receptor);
ALTER TABLE organos
   ADD CONSTRAINT organosPK PRIMARY KEY (NIF_donante,ID_organo);
-- 3. Definición de claves ajenas
ALTER TABLE organos
   ADD CONSTRAINT organosFK1 FOREIGN KEY (NIF_donante)
   REFERENCES donantes(NIF_donante)
   ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE organos
   ADD CONSTRAINT organosFK2 FOREIGN KEY (NIF_receptor)
   REFERENCES receptores(NIF_receptor)
   ON DELETE RESTRICT ON UPDATE CASCADE;
-- 4. Carga de los datos
/* LOAD DATA INFILE 'H:/BBDDOrganos/dataset_donantes.csv' INTO TABLE donantes
      FIELDS TERMINATED BY ',' 
      LINES TERMINATED BY '\r\n'
      IGNORE 1 LINES;
   [ERROR DE SEGURIDAD] Error Code: 1290. The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
   Archivo de configuración: C:\ProgramData\MySQL\MySQL Server 8.0\my.ini
   Opción: # Secure File Priv
           secure-file-priv="C:/ProgramData/MySQL/MySQL Server 8.0/Uploads"
 */  
/* Duplicate-Key Handling: 
   - REPLACE: If you specify REPLACE, input rows replace existing rows.
   - IGNORE: If you specify IGNORE, rows that duplicate an existing row on a unique key value are discarded.
 */
-- DELETE FROM organos; DELETE FROM donantes; DELETE FROM receptores;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dataset_donantes.csv' IGNORE INTO TABLE donantes
   FIELDS TERMINATED BY ',' 
   LINES TERMINATED BY '\r\n'	
   IGNORE 1 LINES
   (NIF_donante,nombre_donante,primer_apellido_donante,@segundo_apellido_donante)
   SET segundo_apellido_donante = IF(@segundo_apellido_donante='', NULL, @segundo_apellido_donante);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dataset_receptores.csv' IGNORE INTO TABLE receptores
   FIELDS TERMINATED BY ',' 
   LINES TERMINATED BY '\r\n'	
   IGNORE 1 LINES
   (NIF_receptor,nombre_receptor,primer_apellido_receptor,@segundo_apellido_receptor)
   SET segundo_apellido_receptor = IF(@segundo_apellido_receptor='', NULL, @segundo_apellido_receptor);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dataset_organos.csv' IGNORE INTO TABLE organos
   FIELDS TERMINATED BY ',' 
   LINES TERMINATED BY '\r\n'	
   IGNORE 1 LINES
   (NIF_donante,ID_organo,@nif_receptor)
   SET NIF_receptor = IF(@nif_receptor='', NULL, @nif_receptor);