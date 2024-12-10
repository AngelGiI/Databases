CREATE DATABASE IF NOT EXISTS relacionesSociales;
USE relacionesSociales;
/* **** Esquema principal **** */
CREATE TABLE IF NOT EXISTS estudiantes (
   NIF_estudiante      CHAR(9) NOT NULL PRIMARY KEY,	
   nombre_estudiante   VARCHAR(30) NOT NULL,
   apellido_estudiante VARCHAR(30) NOT NULL,
   curso_estudiante    TINYINT UNSIGNED NOT NULL DEFAULT 1
   -- CHECK (curso_estudiante<=4)
);
CREATE TABLE IF NOT EXISTS amistades (
   NIF_e1 CHAR(9) NOT NULL,
   NIF_e2 CHAR(9) NOT NULL
   -- CHECK (NIF_e1!=NIF_e2)
);
ALTER TABLE amistades
   ADD CONSTRAINT amistadesPK PRIMARY KEY (NIF_e1,NIF_e2);
CREATE TABLE IF NOT EXISTS enamoramientos (
   NIF_enamorado  CHAR(9) NOT NULL PRIMARY KEY,
   NIF_estudiante CHAR(9) NOT NULL
   -- CHECK (NIF_enamorado!=NIF_estudiante)
);
ALTER TABLE amistades
   ADD CONSTRAINT amistadesFK1 FOREIGN KEY (NIF_e1)
   REFERENCES estudiantes(NIF_estudiante)
   ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE amistades
   ADD CONSTRAINT amistadesFK2 FOREIGN KEY (NIF_e2)
   REFERENCES estudiantes(NIF_estudiante)
   ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE enamoramientos
   ADD CONSTRAINT enamoramientosFK1 FOREIGN KEY (NIF_enamorado)
   REFERENCES estudiantes(NIF_estudiante)
   ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE enamoramientos
   ADD CONSTRAINT enamoramientosFK2 FOREIGN KEY (NIF_estudiante)
   REFERENCES estudiantes(NIF_estudiante)
   ON DELETE CASCADE ON UPDATE CASCADE;
/* **** Esquema secundario **** */
CREATE TABLE IF NOT EXISTS enamoramientosTruncados (
   NIF_enamorado       CHAR(9) NOT NULL PRIMARY KEY,
   NIF_estudiante      CHAR(9) NOT NULL,
   nombre_estudiante   VARCHAR(30) NOT NULL,
   apellido_estudiante VARCHAR(30) NOT NULL,
   fecha		       TIMESTAMP NOT NULL 	
   -- CHECK (NIF_enamorado!=NIF_estudiante)
);
ALTER TABLE enamoramientosTruncados
   ADD CONSTRAINT enamoramientosTruncadosFK1 FOREIGN KEY (NIF_enamorado)
   REFERENCES estudiantes(NIF_estudiante)
   ON DELETE CASCADE ON UPDATE CASCADE;
/* *************************************** */
INSERT INTO estudiantes (NIF_estudiante,nombre_estudiante,apellido_estudiante) VALUE ('10841114H','Aitor','Menta');
INSERT INTO estudiantes (NIF_estudiante,nombre_estudiante,apellido_estudiante) VALUE ('14706884V','Elena','Nito');
INSERT INTO estudiantes (NIF_estudiante,nombre_estudiante,apellido_estudiante) VALUE ('17001277E','Estela','Gartija');
INSERT INTO estudiantes (NIF_estudiante,nombre_estudiante,apellido_estudiante) VALUE ('17968395J','Igor','Dito');
INSERT INTO estudiantes (NIF_estudiante,nombre_estudiante,apellido_estudiante) VALUE ('16552609S','Ines','Queleto');
INSERT INTO estudiantes (NIF_estudiante,nombre_estudiante,apellido_estudiante) VALUE ('07283552G','Pepe','Pinillo');
INSERT INTO amistades VALUE ('17001277E','16552609S'); # Amistad (Estela,Inés) 
INSERT INTO amistades VALUE ('16552609S','17001277E'); # Amistad (Inés,Estela) 
INSERT INTO amistades VALUE ('10841114H','17968395J'); # Amistad (Aitor,Igor)
INSERT INTO amistades VALUE ('17968395J','10841114H'); # Amistad (Igor,Aitor)
INSERT INTO enamoramientos VALUE ('10841114H','07283552G'); # Enamoramiento (Aitor,Pepe)
INSERT INTO enamoramientos VALUE ('17968395J','17001277E'); # Enamoramiento (Igor,Estela)
INSERT INTO enamoramientos VALUE ('07283552G','17001277E'); # Enamoramiento (Pepe,Estela)
/* Consultas para obtener información complementaria sobre el contenido de las tablas */
-- Tabla ESTUDIANTES
SELECT * FROM estudiantes; 
-- Tabla AMISTADES
SELECT * FROM (estudiantes E1 INNER JOIN amistades A ON E1.NIF_estudiante=A.NIF_e1) INNER JOIN estudiantes E2 ON A.NIF_e2=E2.NIF_estudiante; 
-- Tabla ENAMORAMIENTOS
SELECT * FROM (estudiantes E1 INNER JOIN enamoramientos A ON E1.NIF_estudiante=A.NIF_enamorado) INNER JOIN estudiantes E2 ON A.NIF_estudiante=E2.NIF_estudiante; 
-- Tabla ENAMORAMIENTOS_TRUNCADOS
SELECT * FROM estudiantes E INNER JOIN enamoramientosTruncados MT ON E.NIF_estudiante=MT.NIF_enamorado; 
/* *************************************** */
/* **** Disparadores **** */
/* Ejercicio 1: Diseña y escribe un disparador que ante una modificación en la tabla ENAMORAMIENTOS asegure la propiedad siguiente: 
     Sea (NIF_enamorado,OLD.NIF_estudiante) la tupla que va a modificar y (NIF_enamorado,NEW.NIF_estudiante) su nuevo valor en la tabla ENAMORAMIENTOS.
     Si (OLD.NIF_estudiante,NEW.NIF_estudiante) pertenece a la tabla AMISTADES, entonces la modificación en la tabla ENAMORAMIENTOS elimina la amistad entre estos estudiantes.
     Observación: Asume que la tabla AMISTADES es simétrica (si (a,b) en AMISTADES, entonces (b,a) en AMISTADES).
   Ejemplo: Supongamos que se desea cambiar la tupla (Pepe,Estela) en ENAMORAMIENTOS por la tupla (Pepe,Inés).
     Como (Estela,Inés),(Inés,Estela) en AMISTADES, entonces la modificación en la tabla ENAMORAMIENTOS tiene como efecto (Estela,Inés),(Inés,Estela) no en AMISTADES.
*/ 
DELIMITER $$
CREATE TRIGGER deleteAmistad BEFORE UPDATE ON enamoramientos FOR EACH ROW
BEGIN
   DECLARE sonAmigos INT;
   SELECT COUNT(*) INTO sonAmigos
      FROM amistades
      WHERE (NIF_e1=OLD.NIF_estudiante) AND (NIF_e2=NEW.NIF_estudiante);
   IF (sonAmigos>0)   
      THEN BEGIN DELETE FROM amistades WHERE (NIF_e1=OLD.NIF_estudiante) AND (NIF_e2=NEW.NIF_estudiante);
                 DELETE FROM amistades WHERE (NIF_e1=NEW.NIF_estudiante) AND (NIF_e2=OLD.NIF_estudiante);
           END;
   END IF;
END; $$
DELIMITER ;
/* Ejercicio 2: Diseña y escribe un disparador que ante una eliminación en la tabla ESTUDIANTES actualice la tabla ENAMORAMIENTOS_TRUNCADOS, insertando en el 
     orden adecuado la información del estudiante eliminado (NIF,nombre,apellido) junto con el NIF de sus enamorados y la fecha de su eliminación.
     Observación: Emplea la instrucción INSERT INTO ... SELECT ... 
   Ejemplo: Supongamos que se desea eliminar la tupla ('17001277E','Estela','Gartija') en ESTUDIANTES.
     Como (Pepe,Estela),(Igor,Estela) en ENAMORAMIENTOS, entonces la eliminación en la tabla ESTUDIANTES tiene como efecto la inserción en ENAMORAMIENTOS_TRUNCADOS de 
     las tuplas siguientes:
        ('07283552G','17001277E','Estela','Gartija',fecha_eliminacion) = (NIF_Pepe,NIF_Estela,nombre_Estela,apellido_Estela,fecha_eliminacion) 
		('17968395J','17001277E','Estela','Gartija',fecha_eliminacion) = (NIF_Igor,NIF_Estela,nombre_Estela,apellido_Estela,fecha_eliminacion)
 */
DELIMITER $$
CREATE TRIGGER updateEnamoramientoTruncado BEFORE DELETE ON estudiantes FOR EACH ROW
BEGIN
   INSERT INTO enamoramientosTruncados (NIF_enamorado,NIF_estudiante,nombre_estudiante,apellido_estudiante,fecha)
   SELECT M.NIF_enamorado,E.NIF_estudiante,E.nombre_estudiante,E.apellido_estudiante, CURRENT_TIMESTAMP()
      FROM enamoramientos M INNER JOIN estudiantes E ON M.NIF_estudiante=E.NIF_estudiante 
      WHERE (M.NIF_estudiante=OLD.NIF_estudiante);
END; $$
DELIMITER ;
/* Ejercicio 3: Diseña y escribe un disparador que ante una inserción en la tabla ENAMORAMIENTOS_TRUNCADOS lance un error indicando que la operación no está permitida.
   Ejemplo: La inserción en la tabla ENAMORAMIENTOS_TRUNCADOS tiene como efecto el error cuya descripción es 'Operacion no permitida'.
 */
DELIMITER $$
CREATE TRIGGER insertEnamoramientoTruncado BEFORE INSERT ON enamoramientosTruncados FOR EACH ROW
BEGIN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Operacion no permitida';
END; $$
DELIMITER ;
/* Ejercicio 4: Diseña y escribe un procedimiento almacenado que asegure la simetría de la tabla AMISTAD.
   Ejemplo: Supongamos que se ha insertado la tupla ('17001277E','16552609S') en AMISTADES. 
     El procedimiento tiene como efecto la inserción en AMISTADES de la tupla ('16552609S','17001277E').
 */
DELIMITER $$
CREATE PROCEDURE updateAmistad_proc(IN NIF_estudiante1 CHAR(9), IN NIF_estudiante2 CHAR(9)) READS SQL DATA MODIFIES SQL DATA
BEGIN
   DECLARE amigo1de2 INT;
   DECLARE amigo2de1 INT; 
   SELECT COUNT(*) INTO amigo1de2
      FROM amistades
      WHERE (NIF_e1=NIF_estudiante1) AND (NIF_e2=NIF_estudiante2);
   SELECT COUNT(*) INTO amigo2de1
      FROM amistades
      WHERE (NIF_e1=NIF_estudiante2) AND (NIF_e2=NIF_estudiante1);   
   IF (amigo1de2=1 AND amigo2de1=0)
      THEN INSERT INTO amistades VALUE(NIF_estudiante2,NIF_estudiante1);
      ELSE IF (amigo1de2=0 AND amigo2de1=1)
              THEN INSERT INTO amistades VALUE(NIF_estudiante1,NIF_estudiante2);
           END IF;
   END IF;
END; $$
DELIMITER ; 
/* *************************************** */
/* Consultas para el test del procedimiento almacenado y de los disparadores */
# Test del procedimiento almacenado updateAmistad_proc 
DELETE FROM amistades WHERE NIF_e1='16552609S' AND NIF_e2='17001277E';
CALL updateAmistad_proc('17001277E','16552609S'); # Equivalente a INSERT INTO amistades VALUE ('16552609S','17001277E');
DELETE FROM amistades WHERE NIF_e1='17968395J' AND NIF_e2='10841114H';
CALL updateAmistad_proc('10841114H','17968395J'); # Equivalente a INSERT INTO amistades VALUE ('17968395J','10841114H');
# Test del disparador deleteAmistad
UPDATE enamoramientos # Cambio del enamoramiento (Igor,Estela) a (Igor,Inés)
   SET NIF_estudiante='16552609S'
   WHERE NIF_enamorado='17968395J';
# Test del disparador updateEnamoramientoTruncado antes de incluir el disparador insertEnamoramientoTruncado
DELETE FROM estudiantes WHERE NIF_estudiante='17001277E'; # Eliminación de Estela
# Test del disparador updateEnamoramientoTruncado después de incluir el disparador insertEnamoramientoTruncado
DELETE FROM estudiantes WHERE NIF_estudiante='07283552G'; # Eliminación de Pepe