-- 4. Consulta de datos. Parte 1: Consultas básicas (sobre una tabla)
/* Lenguaje de Manipulación de Datos o DML (Data Manipulation Language)
   - SELECT: Consulta de datos.
 */
USE gestionOrganos;
 
/* Ejercicios resueltos */
-- 1. Datos de los órganos que tienen un receptor asignado.
SELECT *
    FROM organos
    WHERE NIF_receptor IS NOT NULL;
-- 2. Datos de los sanitarios que no pertenecen ni al colectivo de médicos ni al colectivo de enfermeros.
SELECT * 
    FROM sanitarios
    WHERE tipo_sanitario IS NULL;
-- 3. Cantidad de médicos de cada una de las especialidades almacenadas.
SELECT especialidad_medico, COUNT(NIF_medico)
    FROM medicos
    GROUP BY especialidad_medico;
-- 4. Datos de los hospitales de tipo II cuyo nombre empieza por la palabra 'COMPLEJO'. 
SELECT *
    FROM hospitales
    WHERE (tipo_hospital = 'II') AND (nombre_hospital LIKE 'COMPLEJO%');
-- 5. Cantidad de hospitales de cada una de las categorías almacenadas.
SELECT tipo_hospital, COUNT(ID_hospital)
    FROM hospitales
    GROUP BY tipo_hospital;
-- 6. Datos de los municipios con más de dos hospitales.
SELECT municipio_hospital, COUNT(ID_hospital) AS cantidad_hospitales
    FROM hospitales
    GROUP BY municipio_hospital
    HAVING cantidad_hospitales > 2;
-- 7. Cantidad de hospitales de tipo I de cada municipio.
SELECT municipio_hospital, COUNT(ID_hospital) AS cantidad_hospitales
    FROM hospitales
    WHERE tipo_hospital = 'I'
    GROUP BY municipio_hospital;
-- 8. Datos de los municipios con más de un hospital de tipo I.
SELECT municipio_hospital, COUNT(ID_hospital) AS cantidad_hospitales
    FROM hospitales
    WHERE tipo_hospital = 'I'
    GROUP BY municipio_hospital
    HAVING cantidad_hospitales > 1;
-- 9. NIF de los pacientes que han realizado varias donaciones.
SELECT NIF_donante 
    FROM organos
    GROUP BY NIF_donante
    HAVING COUNT(ID_organo) > 1;
-- 10. Datos de los hospitales con más de dos médicos.
SELECT ID_hospital, COUNT(NIF_sanitario) AS cantidad_medicos
    FROM sanitarios
    WHERE tipo_sanitario IS TRUE
    GROUP BY ID_hospital
    HAVING cantidad_medicos > 2;