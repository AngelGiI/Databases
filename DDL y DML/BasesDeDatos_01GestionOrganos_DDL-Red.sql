-- 1. Creación y modificación de un esquema relacional
/* Lenguaje de Definición de Datos o DDL (Data Definition Language)
   - CREATE: Creación de tablas, campos e índices.
   - ALTER: Modificación de tablas. 
   - DROP: Eliminación de tablas e índices.
 */
CREATE DATABASE IF NOT EXISTS gestionOrganos;
USE gestionOrganos;

-- 1. Definición de tablas
CREATE TABLE IF NOT EXISTS hospitales (
   ID_hospital        CHAR(6) NOT NULL,  
   nombre_hospital    VARCHAR(60) NOT NULL UNIQUE,
   municipio_hospital VARCHAR(30) NOT NULL,
   tipo_hospital      ENUM('I','II','III') NOT NULL,
   NIF_coordinador    CHAR(9) NOT NULL
);
/* ID_hospital: Seis dígitos. De izquierda a derecha, dos corresponden a la provincia, 
   tres a un número de orden dentro de la provincia y el último es un dígito de control.
 */
CREATE TABLE IF NOT EXISTS sanitarios (
   NIF_sanitario              CHAR(9) NOT NULL,
   nombre_sanitario           VARCHAR(30) NOT NULL,
   primer_apellido_sanitario  VARCHAR(30) NOT NULL,
   segundo_apellido_sanitario VARCHAR(30) NULL,
   tipo_sanitario             BOOL NULL,
   ID_hospital                CHAR(6) NOT NULL
);
CREATE TABLE IF NOT EXISTS medicos (
   NIF_medico          CHAR(9) NOT NULL,
   especialidad_medico ENUM('NEFROLOGIA','HEPATOLOGIA','CARDIOLOGIA','GASTROENTEROLOGIA','NEUMOLOGIA') NOT NULL 
);
CREATE TABLE IF NOT EXISTS enfermeros (
   NIF_enfermero  CHAR(9) NOT NULL,
   NIF_supervisor CHAR(9) NULL
);
-- 2. Definición de claves primarias
ALTER TABLE hospitales
   ADD CONSTRAINT hospitalesPK PRIMARY KEY (ID_hospital);
ALTER TABLE sanitarios
   ADD CONSTRAINT sanitariosPK PRIMARY KEY (NIF_sanitario);
ALTER TABLE medicos
   ADD CONSTRAINT medicosPK PRIMARY KEY (NIF_medico);
ALTER TABLE enfermeros
   ADD CONSTRAINT enfermerosPK PRIMARY KEY (NIF_enfermero);
-- 3. Definición de claves ajenas
ALTER TABLE sanitarios
   ADD CONSTRAINT sanitariosFK FOREIGN KEY (ID_hospital)
   REFERENCES hospitales(ID_hospital)
   ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE medicos
   ADD CONSTRAINT medicosFK FOREIGN KEY (NIF_medico)
   REFERENCES sanitarios(NIF_sanitario)
   ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE enfermeros
   ADD CONSTRAINT enfermerosFK1 FOREIGN KEY (NIF_enfermero)
   REFERENCES sanitarios(NIF_sanitario)
   ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE enfermeros
   ADD CONSTRAINT enfermerosFK2 FOREIGN KEY (NIF_supervisor)
   REFERENCES enfermeros(NIF_enfermero)
   ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE hospitales
   ADD CONSTRAINT hospitalesFK FOREIGN KEY (NIF_coordinador)
   REFERENCES medicos(NIF_medico)
   ON DELETE RESTRICT ON UPDATE CASCADE;