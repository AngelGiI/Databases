-- 7. MySQL avanzado: Transacciones
/* Transactions are atomic units of work that can be committed or rolled back. When a transaction makes multiple changes to the database, either all the 
   changes succeed when the transaction is committed, or all the changes are undone when the transaction is rolled back. Database transactions, as 
   implemented by InnoDB, have properties that are collectively known by the acronym ACID, for atomicity, consistency, isolation, and durability. 
 */
USE relacionesSociales;
/* **** Esquema auxiliar **** */
CREATE TABLE IF NOT EXISTS mentores (
   NIF_mentor 		CHAR(9) NOT NULL PRIMARY KEY,	
   ID_departamento  CHAR(4) NOT NULL  
);
CREATE TABLE IF NOT EXISTS departamentos (
   ID_departamento  CHAR(4) NOT NULL PRIMARY KEY  
);
ALTER TABLE mentores
   ADD CONSTRAINT mentoresFK FOREIGN KEY (ID_departamento)
   REFERENCES departamentos(ID_departamento);
/* *************************************** */
/* **** Procedimiento almacenado **** */
-- DROP PROCEDURE insertDepartamento;
DELIMITER $$
CREATE PROCEDURE insertDepartamento(IN ID_depto CHAR(4), IN NIF_mtr CHAR(9), OUT error_code INT, OUT error_message VARCHAR(50)) MODIFIES SQL DATA
BEGIN
   DECLARE error_duplicate_entry CONDITION FOR 1062;
   DECLARE error_null_value CONDITION FOR 1048;
   DECLARE error_foreign_key CONDITION FOR 1452;
   DECLARE error_deadlock_found CONDITION FOR 1213;
   DECLARE error_time_exceeded CONDITION FOR 1205;
   DECLARE CONTINUE HANDLER FOR error_duplicate_entry
      BEGIN SET error_code=1062; SET error_message='Entrada duplicada'; END;
   DECLARE CONTINUE HANDLER FOR error_null_value
      BEGIN SET error_code=1048; SET error_message='Valor nulo'; END;
   DECLARE CONTINUE HANDLER FOR error_foreign_key
      BEGIN SET error_code=1452; SET error_message='Error de clave ajena'; END;
   DECLARE EXIT HANDLER FOR error_deadlock_found
      BEGIN SET error_code=1213; SET error_message='Deadlock'; END;
   DECLARE CONTINUE HANDLER FOR error_time_exceeded
      BEGIN SET error_code=1205; SET error_message='Tiempo excedido'; END;
   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
      BEGIN SET error_code=-1; SET error_message='Error'; END;
   SET error_code=0;
   START TRANSACTION;
      INSERT INTO departamentos VALUES(ID_depto);
      INSERT INTO mentores VALUES(NIF_mtr,ID_depto);
   ROLLBACK;
   IF (error_code=0)
      THEN BEGIN START TRANSACTION;
                   INSERT INTO departamentos VALUES(ID_depto);
                   INSERT INTO mentores VALUES(NIF_mtr,ID_depto);
                 COMMIT;
                 SET error_message='Nuevo departamento incorporado';
           END;
   END IF;
END; $$
DELIMITER ; 
/* *************************************** */