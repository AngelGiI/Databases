-- 6. Otros objetos almacenados. Parte 1: Tablas temporales y vistas
/* Views are stored queries that when invoked produce a result set. A view acts as a virtual table. 
   1. The optional ALGORITHM clause is a MySQL extension to standard SQL. It affects how MySQL processes the view. 
      - For MERGE, the text of a statement that refers to the view and the view definition are merged such that parts of the view definition 
        replace corresponding parts of the statement.
      - For TEMPTABLE, the results from the view are retrieved into a temporary table, which then is used to execute the statement. 
   2. Some views are updatable (you can use them in statements such as UPDATE, DELETE, or INSERT to update the contents of the underlying table). 
      For a view to be updatable, there must be a one-to-one relationship between the rows in the view and the rows in the underlying table. 
      The use of a temporary table always makes a view nonupdatable.
 */  
USE gestionOrganos;

/* 1. Vistas actualizables */
/* 1.1. Vista actualizable con una tabla base */
# Creación de una tabla temporal
CREATE TEMPORARY TABLE IF NOT EXISTS t_sanitarios 
AS SELECT NIF_sanitario, nombre_sanitario, primer_apellido_sanitario, tipo_sanitario, ID_hospital
   FROM sanitarios; 
SELECT * FROM t_sanitarios; 
INSERT INTO t_sanitarios VALUE ('65408359Q','Armando','Casitas',0,'081347');
# Creación de una vista actualizable
CREATE OR REPLACE
   ALGORITHM = MERGE
   VIEW v_sanitarios
   AS SELECT NIF_sanitario, nombre_sanitario, primer_apellido_sanitario, tipo_sanitario, ID_hospital
      FROM sanitarios; 
# Actualización de las tablas base
INSERT INTO sanitarios VALUE ('27102624E','Aquiles','Bailo',NULL,0,'081347'); 
# Actualización de la vista
INSERT INTO v_sanitarios VALUE ('41302818Q','Aitor','Menta',0,'081347');
UPDATE v_sanitarios
   SET primer_apellido_sanitario='Mente'
   WHERE primer_apellido_sanitario='Menta';
DELETE FROM v_sanitarios
   WHERE nombre_sanitario='Aitor' AND primer_apellido_sanitario='Mente';
/* 1.2. Vista actualizable con varias tablas base */
# Creación de una tabla temporal
CREATE TEMPORARY TABLE IF NOT EXISTS t_miembros_equiposMedicos
AS SELECT S.*, SEM.NIF_sanitario NIF, SEM.ID_equipoMedico
   FROM sanitarios_equiposMedicos SEM INNER JOIN sanitarios S ON SEM.NIF_sanitario=S.NIF_sanitario;
SELECT * FROM t_miembros_equiposMedicos;
INSERT INTO t_miembros_equiposMedicos VALUE ('65408359Q','Armando','Casitas',NULL,0,'081347','00000000P','11111');
# Creación de una vista actualizable
CREATE OR REPLACE
   ALGORITHM = MERGE
   VIEW v_miembros_equiposMedicos
   AS SELECT S.*, SEM.NIF_sanitario NIF, SEM.ID_equipoMedico
      FROM sanitarios_equiposMedicos SEM INNER JOIN sanitarios S ON SEM.NIF_sanitario=S.NIF_sanitario;
# Actualización de las tablas base
INSERT INTO sanitarios_equiposMedicos VALUE ('53831','13226919X');
# Actualización de la vista
-- INSERT INTO v_miembros_equiposmedicos (NIF_sanitario, nombre_sanitario, primer_apellido_sanitario, segundo_apellido_sanitario, tipo_sanitario, ID_hospital, NIF, ID_equipoMedico) VALUE ('56889393C','Pepe','Pinillo',NULL,1,'081347','56889393C','21824');
   /* Error Code: 1393. Can not modify more than one base table through a join view 'gestionorganos.v_miembros_equiposmedicos' */
INSERT INTO v_miembros_equiposmedicos (NIF_sanitario, nombre_sanitario, primer_apellido_sanitario, segundo_apellido_sanitario, tipo_sanitario, ID_hospital) VALUE ('56889393C','Pepe','Pinillo',NULL,1,'081347');
INSERT INTO v_miembros_equiposmedicos (NIF, ID_equipoMedico) VALUE ('56889393C','21824');
UPDATE v_miembros_equiposmedicos
   SET primer_apellido_sanitario='Pinilla'
   WHERE primer_apellido_sanitario='Pinillo';
-- DELETE FROM v_miembros_equiposmedicos WHERE nombre_sanitario='Pepe' AND primer_apellido_sanitario='Pinilla';
   /* Error Code: 1395. Can not delete from join view (join views do not allow deletion) */             

/* 1. Vistas no actualizables */
CREATE OR REPLACE
   ALGORITHM = TEMPTABLE -- ALGORITHM = MERGE 
                            /* Warning 1354: View merge algorithm can't be used here for now (assumed undefined algorithm) */
   VIEW plantillaHospitales(ID_hospital, cantidad_sanitarios)
   AS SELECT ID_hospital, COUNT(DISTINCT NIF_sanitario)
      FROM sanitarios 
      GROUP BY ID_hospital;
# Actualización de las tablas base
INSERT INTO sanitarios VALUE ('41302818Q','Aitor','Menta',NULL,0,'081347');
# Actualización de la vista
-- INSERT INTO plantillaHospitales VALUE ('081347',11);
   /* Error Code: 1471. The target table plantillaHospitales of the INSERT is not insertable-into */
-- UPDATE plantillaHospitales SET cantidad_sanitarios=cantidad_sanitarios+1 WHERE ID_hospital='081347'; 
   /* Error Code: 1288. The target table plantillaHospitales of the UPDATE is not updatable */
-- DELETE FROM plantillaHospitales WHERE ID_hospital='081347';
   /* Error Code: 1288. The target table plantillaHospitales of the UPDATE is not updatable */

/* All temporary tables are created in the shared temporary tablespace named ibtmp1 (C:\ProgramData\MySQL\MySQL Server 8.0\Data).
   Stored objects (they are defined in terms of SQL code that is stored on the server for later execution) are the following:
   1. Stored procedures and functions are stored in the mysql.routines and mysql.parameters tables, which are part of the data dictionary. 
      You cannot access these tables directly. Instead, query the INFORMATION_SCHEMA ROUTINES and PARAMETERS tables. 
   2. Triggers are stored in the mysql.triggers system table, which is part of the data dictionary. 
      You cannot access this table directly. Instead, query the INFORMATION_SCHEMA TRIGGERS table.
   3. Views are stored queries that when invoked produce a result set. A view acts as a virtual table. 
      Query the INFORMATION_SCHEMA VIEWS table. 
 */