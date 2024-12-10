-- 6. Consulta de datos. Parte 3: Consultas anidadas
/* Lenguaje de Modificación de Datos o DML (Data Manipulation Language)
   - SELECT: Consulta de datos.
 */
USE gestionOrganos;
# INSERT INTO sanitarios_equiposMedicos VALUES ('57978','33381133Z'), ('48023','11060703A'), ('57978','11060703A'), ('21824','11060703A');

/* Ejercicios resueltos */
-- 1. Datos completos de los hospitales donde no se han realizado implantaciones de corazón.
SELECT *
   FROM hospitales
   WHERE ID_hospital NOT IN (SELECT ID_hospital FROM implantaciones WHERE ID_organo='C');
-- 2. Datos completos de los hospitales con la mayor cantidad de sanitarios contratados.
CREATE OR REPLACE
   ALGORITHM = TEMPTABLE
   VIEW plantilla(ID_hospital, cantidadSanitarios) # Cantidad de sanitarios contratados por cada hospital
   AS SELECT ID_hospital, COUNT(DISTINCT NIF_sanitario)
         FROM sanitarios 
         GROUP BY ID_hospital;
SELECT H.*, P.cantidadSanitarios
   FROM hospitales H INNER JOIN plantilla P ON H.ID_hospital = P.ID_hospital
   WHERE P.cantidadSanitarios = (SELECT MAX(cantidadSanitarios) FROM plantilla);     
-- 3. Datos completos de los enfermeros contratados en los hospitales con mayor cantidad de sanitarios contratados.
SELECT S.*   
   FROM sanitarios S INNER JOIN plantilla P ON S.ID_hospital = P.ID_hospital
   WHERE S.tipo_sanitario = 0 AND P.cantidadSanitarios = (SELECT MAX(cantidadSanitarios) FROM plantilla); 
-- 4. Identificadores de los equipos médicos en que ha participado Allegra Kinney Chase.
SELECT EM.ID_equipoMedico
   FROM (SELECT S.*, SEM.ID_equipoMedico
            FROM sanitarios_equiposMedicos SEM INNER JOIN sanitarios S ON SEM.NIF_sanitario = S.NIF_sanitario) AS EM
   WHERE EM.nombre_sanitario = 'Allegra' AND EM.primer_apellido_sanitario = 'Kinney' AND EM.segundo_apellido_sanitario = 'Chase';
-- 5. Datos completos de los sanitarios que han formado parte de algún equipo médico en que ha participado Allegra Kinney Chase.
SELECT T.*
   FROM (SELECT S.*, SEM.ID_equipoMedico
		    FROM sanitarios_equiposMedicos SEM INNER JOIN sanitarios S ON SEM.NIF_sanitario = S.NIF_sanitario) AS T
   WHERE T.ID_equipoMedico IN (SELECT EM.ID_equipoMedico # Equipos médicos en que ha participado Allegra Kinney Chase
                                  FROM (SELECT S.*, SEM.ID_equipoMedico
                                           FROM sanitarios_equiposMedicos SEM INNER JOIN sanitarios S ON SEM.NIF_sanitario = S.NIF_sanitario) AS EM
                                  WHERE EM.nombre_sanitario = 'Allegra' AND EM.primer_apellido_sanitario = 'Kinney' AND EM.segundo_apellido_sanitario = 'Chase')
         AND NOT (T.nombre_sanitario = 'Allegra' AND T.primer_apellido_sanitario = 'Kinney' AND T.segundo_apellido_sanitario = 'Chase');
# Consulta equivalente
CREATE OR REPLACE
   ALGORITHM = TEMPTABLE
   VIEW miembros_equiposMedicos # Datos completos de los sanitarios de los equipos médicos
   AS SELECT S.*, SEM.ID_equipoMedico
         FROM sanitarios_equiposMedicos SEM INNER JOIN sanitarios S ON SEM.NIF_sanitario = S.NIF_sanitario;
SELECT T.* 
   FROM miembros_equiposMedicos T
   WHERE T.ID_equipoMedico IN (SELECT EM.ID_equipoMedico
                                  FROM miembros_equiposMedicos EM
                                  WHERE EM.nombre_sanitario = 'Allegra' AND EM.primer_apellido_sanitario = 'Kinney' AND EM.segundo_apellido_sanitario = 'Chase')
		 AND NOT (T.nombre_sanitario = 'Allegra' AND T.primer_apellido_sanitario = 'Kinney' AND T.segundo_apellido_sanitario = 'Chase');
-- 6. Datos completos de los sanitarios que han formado parte de los mismos equipos médicos en que ha participado Allegra Kinney Chase.
# Paso 1: Equipos médicos en que ha participado Allegra Kinney Chase.
# Paso 2: Sanitarios que han participado en tales equipos médicos y conteo de los equipos médicos comunes con Allegra Kinney Chase.
# Paso 3: Selección de los sanitarios cuyo conteo coincida con el conteo de los equipos médicos en que ha participado Allegra Kinney Chase.
SELECT T.NIF_sanitario, T.nombre_sanitario, T.primer_apellido_sanitario, T.segundo_apellido_sanitario, T.tipo_sanitario, T.ID_hospital 
   FROM miembros_equiposMedicos T
   WHERE T.ID_equipoMedico IN (SELECT EM.ID_equipoMedico # Equipos médicos en que ha participado Allegra Kinney Chase
                                  FROM miembros_equiposMedicos EM
                                  WHERE EM.nombre_sanitario = 'Allegra' AND EM.primer_apellido_sanitario = 'Kinney' AND EM.segundo_apellido_sanitario = 'Chase')
		 AND NOT (T.nombre_sanitario = 'Allegra' AND T.primer_apellido_sanitario = 'Kinney' AND T.segundo_apellido_sanitario = 'Chase')
   GROUP BY T.NIF_sanitario
   HAVING COUNT(T.ID_equipoMedico) = (SELECT COUNT(EM.ID_equipoMedico) # Cantidad de equipos médicos en que ha participado Allegra Kinney Chase
                                         FROM miembros_equiposMedicos EM
                                         WHERE EM.nombre_sanitario = 'Allegra' AND EM.primer_apellido_sanitario = 'Kinney' AND EM.segundo_apellido_sanitario = 'Chase'); 