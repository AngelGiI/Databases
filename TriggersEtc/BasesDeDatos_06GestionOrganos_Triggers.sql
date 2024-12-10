-- 6. Otros objetos almacenados. Parte 2: Disparadores
/* A trigger is a named database object that is associated with a table, and that activates when a particular event occurs for the table. 
   The trigger becomes associated with the table named tbl_name, which must refer to a permanent table. You cannot associate a trigger with a TEMPORARY table or a view. 
 */
CREATE DATABASE IF NOT EXISTS prueba_triggers;
USE prueba_triggers;

/* **** Código de una única ejecución **** */
CREATE TABLE productos (
	id 		 INT AUTO_INCREMENT PRIMARY KEY,
    nombre   VARCHAR(30) NOT NULL UNIQUE,
    cantidad INT NOT NULL DEFAULT 0,
    precio   DECIMAL(6,2) NOT NULL DEFAULT 0, 
    CHECK (cantidad>=0 AND cantidad<=100),
    CHECK (precio>=0 AND PRECIO<=1000)
);
CREATE TABLE IF NOT EXISTS estadistica (
	cantidadTotal INT NOT NULL,
    fecha	      TIMESTAMP NOT NULL
);
CREATE TABLE IF NOT EXISTS historial (
	id 		         INT NOT NULL,
    nombre_antes     VARCHAR(30) NOT NULL UNIQUE,
    cantidad_antes   INT NOT NULL DEFAULT 0,
    precio_antes     DECIMAL(6,2) NOT NULL DEFAULT 0,
    nombre_despues   VARCHAR(30) NOT NULL UNIQUE,
    cantidad_despues INT NOT NULL DEFAULT 0,
    precio_despues   DECIMAL(6,2) NOT NULL DEFAULT 0,
    fecha	         TIMESTAMP NOT NULL
);
ALTER TABLE historial 
    ADD CONSTRAINT historialFK 
    FOREIGN KEY (id)
    REFERENCES productos(id)
    ON DELETE CASCADE ON UPDATE CASCADE;
DELIMITER $$
/* El delimitador se cambia a $$ para permitir que la definición completa del disparador se pase al servidor como una sola declaración. 
   Esto permite que el delimitador ; utilizado en el cuerpo del procedimiento pase al servidor en lugar de ser interpretado por mysql. */
CREATE TRIGGER calcularCantidad_beforeInsert BEFORE INSERT ON productos FOR EACH ROW
BEGIN
    DECLARE cantidadFilas INT;
    SELECT COUNT(*)
		INTO cantidadFilas
        FROM productos;
    IF (cantidadFilas>0) 
		THEN UPDATE estadistica SET cantidadTotal=cantidadTotal+NEW.cantidad, fecha=CURRENT_TIME();
		ELSE BEGIN DELETE FROM estadistica;
                   INSERT INTO estadistica (cantidadTotal,fecha) VALUE(NEW.cantidad,CURRENT_TIME());
             END;      
    END IF;
END $$
CREATE TRIGGER actualizarHistorial_afterUpdate AFTER UPDATE ON productos FOR EACH ROW
BEGIN
    INSERT INTO historial (id,nombre_antes,cantidad_antes,precio_antes,nombre_despues,cantidad_despues,precio_despues,fecha) 
        VALUE(OLD.id,OLD.nombre,OLD.cantidad,OLD.precio,NEW.nombre,NEW.cantidad,NEW.precio,CURRENT_TIME());
END $$
CREATE TRIGGER borrarHistorial_beforeDelete BEFORE DELETE on historial FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Operacion no permitida';
END $$
DELIMITER ;
/* *************************************** */
INSERT INTO productos (nombre,cantidad,precio) VALUES ("TALADRO",3,50.5),("MARTILLO",7,17.56),("LLAVE INGLESA",10,28.25);
UPDATE productos 
    SET cantidad=cantidad+1, precio=precio+0.05*precio 
    WHERE nombre="TALADRO" OR nombre="MARTILLO";
DELETE FROM productos WHERE nombre="TALADRO";
DELETE FROM historial WHERE nombre_antes="MARTILLO";