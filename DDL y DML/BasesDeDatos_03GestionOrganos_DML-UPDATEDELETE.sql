-- 3. Actualización de datos. Parte 2
/* Lenguaje de Modificación de Datos o DML (Data Manipulation Language)
   - INSERT: Inserción de datos.
   - UPDATE: Modificación de datos.
   - DELETE: Eliminación de datos. 
 */  
USE gestionOrganos;

/* INSERT: Inserción de datos */
-- Inserción simple de datos
INSERT INTO sanitarios VALUE ("37554590Y","Pepe","Pinillo","Cebolleta",FALSE,"080484"); 
-- INSERT INTO sanitarios VALUE ("37554590Y","Pepa","Pinillos","Cebolletas",FALSE,"080484"); 
   /* [ERROR DE CLAVE PRIMARIA] Error Code: 1062. Duplicate entry '37554590Y' for key 'PRIMARY' */
-- Inserción múltiple de datos con interrupción por fallo
INSERT INTO sanitarios VALUE ("01496635W","Ana","Tomia",NULL,NULL,"080484"), ("83498545N","Armando","Casas",NULL,NULL,"080484"); 
-- INSERT INTO sanitarios VALUE ("01496635W","Ana","Tomia",NULL,NULL,"080484"), ("14811670S","Elena","Nito",NULL,NULL,"080484");        
   /* [ERROR DE CLAVE PRIMARIA] Error Code: 1062. Duplicate entry '01496635W' for key 'PRIMARY' */
-- Inserción múltiple de datos sin interrupción por fallo
INSERT IGNORE INTO sanitarios VALUE ("01496635W","Ana","Tomia",NULL,NULL,"080484"), ("14811670S","Elena","Nito",NULL,NULL,"080484");        
/* 1 row(s) affected, 1 warning(s): 1062 Duplicate entry '01496635W' for key 'PRIMARY'
   Records: 2  Duplicates: 1  Warnings: 1
 */
-- Inserción de datos incompletos
INSERT INTO sanitarios (NIF_sanitario,nombre_sanitario,primer_apellido_sanitario,ID_hospital) 
   VALUE ("15827415B","Aitor","Menta","080484");     
-- INSERT INTO sanitarios (NIF_sanitario,nombre_sanitario,primer_apellido_sanitario) VALUE ("85061854B","Aquiles","Bailo");     
   /* [ERROR DE VALOR POR DEFECTO] Error Code: 1364. Field 'ID_hospital' doesn't have a default value */
-- Inserción de datos en una tabla hijo de clave ajena
INSERT INTO enfermeros VALUE ("37554590Y",NULL); 
-- INSERT INTO enfermeros VALUE ("37554590Z",NULL); 
   /* [ERROR DE CLAVE AJENA] Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails */

/* UPDATE: Modificación de datos */
/* Modificaciones y eliminaciones seguras: 
   Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column
                     To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect
 */
-- Modificación de datos en una tabla padre de clave ajena
UPDATE sanitarios -- Modificación sin tuplas relacionadas en la tabla hijo
   SET NIF_sanitario = "33469951Y"
   WHERE primer_apellido_sanitario = "Casas";
UPDATE sanitarios -- Modificación sin tuplas relacionadas en la tabla hijo
   SET primer_apellido_sanitario = "CASITAS"
   WHERE primer_apellido_sanitario = "Casas";
UPDATE sanitarios -- Modificación con tuplas relacionadas en la tabla hijo
   SET NIF_sanitario = "43814784Z"
   WHERE primer_apellido_sanitario = "Pinillo";
-- Modificación en cascada: Revisión de la tabla ENFERMEROS */

/* DELETE: Eliminación de datos */
-- Eliminación de datos en una tabla padre de clave ajena
DELETE FROM sanitarios -- Eliminación sin tuplas relacionadas en la tabla hijo
    WHERE nombre_sanitario = "Ana" AND primer_apellido_sanitario = "Tomia";
/* DELETE FROM sanitarios -- Eliminación con tuplas relacionadas en la tabla hijo
      WHERE NIF_sanitario = "11060703A";
   [ERROR DE CLAVE AJENA] Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails   
   Eliminación restringida: Revisión de la tabla ENFERMEROS
 */
-- Eliminación de datos en una tabla hijo de clave ajena
DELETE FROM enfermeros
    WHERE NIF_enfermero = "11190691H";
-- Eliminación del contenido de una tabla
DELETE FROM enfermeros;