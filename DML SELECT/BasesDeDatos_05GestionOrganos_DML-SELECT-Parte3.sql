-- 6. Consulta de datos. Parte 3: Consultas anidadas
/* Lenguaje de Modificación de Datos o DML (Data Manipulation Language)
   - SELECT: Consulta de datos.
 */
USE gestionOrganos;

/* 1. Subconsultas en la cláusula WHERE/HAVING */
/* 1.1. La subconsulta anidada devuelve una tupla: = (equal), <=> (NULL-safe equal), <> (not equal), != (not equal), <=, <, >, >= */
# ¿Datos de los órganos cuya cantidad de donaciones supera la cantidad de donaciones de corazón?
SELECT COUNT(NIF_donante) # Cantidad de donaciones de corazón
   FROM organos 
   WHERE ID_organo='C';
SELECT ID_organo, COUNT(NIF_donante) AS cantidadDonaciones
   FROM organos
   GROUP BY ID_organo
   HAVING COUNT(NIF_donante) > (SELECT COUNT(NIF_donante) 
                                   FROM organos 
                                   WHERE ID_organo ='C');
# ¿Datos completos de los hospitales cuya cantidad de sanitarios contratados es mayor que la media de sanitarios contratados por hospital?
# OPCIÓN 1: TEMPORARY TABLE
# ¿Cantidad de sanitarios contratador por cada hospital?
CREATE TEMPORARY TABLE plantilla
SELECT ID_hospital, COUNT(DISTINCT NIF_sanitario) AS cantidadSanitarios
   FROM sanitarios 
   GROUP BY ID_hospital;
SELECT * FROM plantilla;  
# ¿Datos completos de los hospitales cuya cantidad de sanitarios contratados es mayor que la media de sanitarios contratados por hospital?
SELECT H.*, P.cantidadSanitarios
   FROM hospitales H INNER JOIN plantilla P ON H.ID_hospital=P.ID_hospital
   WHERE P.cantidadSanitarios > (SELECT AVG(cantidadSanitarios) FROM plantilla);
/* Error Code: 1137. Can't reopen table: 'PH' -> You cannot refer to a TEMPORARY table more than once in the same query. */
DROP TABLE plantilla;
# OPCIÓN 2: VIEW
# ¿Cantidad de sanitarios contratador por cada hospital?
CREATE OR REPLACE
ALGORITHM = TEMPTABLE
VIEW plantilla(ID_hospital, cantidadSanitarios)
AS SELECT ID_hospital, COUNT(DISTINCT NIF_sanitario)
      FROM sanitarios 
      GROUP BY ID_hospital;
SELECT * FROM plantilla;  
# ¿Datos completos de los hospitales cuya cantidad de sanitarios contratados es mayor que la media de sanitarios contratados por hospital?
SELECT H.*, P.cantidadSanitarios
   FROM hospitales H INNER JOIN plantilla P ON H.ID_hospital=P.ID_hospital
   WHERE P.cantidadSanitarios > (SELECT AVG(cantidadSanitarios) FROM plantilla);
/* [IMPORTANTE] Two different sessions can use the same temporary table name without conflicting with each other or with an existing 
   non-TEMPORARY table of the same name. The existing table is hidden until the temporary table is dropped. */
/* 1.2. La subconsulta anidada devuelve varias tuplas: [NOT] IN, [NOT] EXISTS, ANY/SOME, ALL 
        ANY/SOME: It must follow a comparison operator. It returns TRUE if the comparison is TRUE for ANY/SOME of the values in the column that the subquery returns. 
        ALL: It must follow a comparison operator. It returns TRUE if the comparison is TRUE for ALL of the values in the column that the subquery returns.
 */
# ¿Datos de los hospitales donde se han realizado implantaciones de corazón?
SELECT *
   FROM hospitales
   WHERE ID_hospital IN (SELECT ID_hospital
                            FROM implantaciones
                            WHERE ID_organo='C');
# ¿Datos de las implantaciones de órganos que son posteriores a alguna implantación de pulmón?
/* UNIX_TIMESTAMP(FECHA): Cantidad de segundos transcurridos desde la medianoche UTC del 1 de enero de 1970 hasta FECHA.
   UTC (Tiempo Universal Coordinado): Principal estándar de tiempo por el cual el mundo regula los relojes y el tiempo. 
 */
SELECT *
FROM implantaciones
WHERE UNIX_TIMESTAMP(fecha_implantacion) > ANY (SELECT UNIX_TIMESTAMP(fecha_implantacion)
                                                   FROM implantaciones
                                                   WHERE ID_organo='PU' AND fecha_implantacion IS NOT NULL);
# ¿Datos de las implantaciones de órganos que son posteriores a todas las implantaciones de pulmón?
SELECT *
FROM implantaciones
WHERE UNIX_TIMESTAMP(fecha_implantacion) > ALL (SELECT UNIX_TIMESTAMP(fecha_implantacion)
                                                   FROM implantaciones
                                                   WHERE ID_organo='PU' AND fecha_implantacion IS NOT NULL);
SELECT * FROM implantaciones WHERE ID_organo='PU' AND fecha_implantacion IS NOT NULL;

/* 2. Subconsultas en la cláusula FROM */
# ¿Nombre de la especialidad médica con mayor cantidad de médicos especialistas?
SELECT T.especialidad, MAX(T.cantidad)
   FROM (SELECT M.especialidad_medico AS especialidad, COUNT(M.NIF_medico) AS cantidad
	        FROM medicos M
            GROUP BY M.especialidad_medico) AS T;

/* 3. Subconsultas en la cláusula SELECT */ 
# ¿La cantidad de receptores es igual a la cantidad de donantes?
SELECT (SELECT COUNT(DISTINCT NIF_receptor) FROM receptores) = (SELECT COUNT(DISTINCT NIF_donante) FROM donantes);
SELECT COUNT(DISTINCT NIF_receptor) FROM receptores;
SELECT COUNT(DISTINCT NIF_donante) FROM donantes;

/* Ejercicio:
   1. Datos completos de los hospitales donde no se han realizado implantaciones de corazón.
   2. Datos completos de los hospitales con la mayor cantidad de sanitarios contratados.
   3. Datos completos de los enfermeros contratados en los hospitales con mayor cantidad de sanitarios contratados.
   4. Identificadores de los equipos médicos en que ha participado Allegra Kinney Chase.
   5. Datos completos de los sanitarios que han formado parte de algún equipo médico en que ha participado Allegra Kinney Chase.
   6. Datos completos de los sanitarios que han formado parte de los mismos equipos médicos en que ha participado Allegra Kinney Chase.
 */
INSERT INTO sanitarios_equiposMedicos VALUES ('57978','33381133Z'), ('48023','11060703A'), ('57978','11060703A'), ('21824','11060703A');