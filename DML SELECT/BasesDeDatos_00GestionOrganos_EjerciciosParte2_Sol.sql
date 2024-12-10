-- 5. Consulta de datos. Parte 2: Consultas de composición de tablas
/* Lenguaje de Modificación de Datos o DML (Data Manipulation Language)
   - SELECT: Consulta de datos.
 */
USE gestionOrganos;

/* Ejercicios resueltos */
-- 1. Cantidad de donaciones de corazón.
SELECT COUNT(NIF_donante) AS donacionesCorazon
   FROM organos
   WHERE ID_organo = 'C';
-- 2. Cantidad de donaciones de cada uno de los órganos.
SELECT ID_organo, COUNT(NIF_donante) AS cantidadDonaciones
   FROM organos
   GROUP BY ID_organo;
-- 3. Código de los hospitales donde se ha realizado más de una implantación.
SELECT ID_hospital, COUNT(DISTINCT NIF_donante, ID_organo) AS cantidadImplantaciones
   FROM implantaciones
   GROUP BY ID_hospital
   HAVING cantidadImplantaciones > 1;
-- 4. Datos completos de los hospitales donde se ha realizado alguna implantación no cardíaca.
SELECT DISTINCT H.*
   FROM hospitales H INNER JOIN implantaciones I ON H.ID_hospital = I.ID_hospital
   WHERE I.ID_organo != 'C';
-- 5. Datos completos de los hospitales donde no se ha realizado ninguna implantación.
SELECT H.*
   FROM hospitales H LEFT JOIN implantaciones I ON H.ID_hospital = I.ID_hospital
   WHERE I.ID_organo IS NULL;
-- 6. Código de los equipos médicos con más de un sanitario perteneciente al colectivo de enfermeros.
SELECT SE.ID_equipoMedico, COUNT(E.NIF_enfermero) AS cantidadEnfermeros
   FROM sanitarios_equiposMedicos SE INNER JOIN enfermeros E ON SE.NIF_sanitario = E.NIF_enfermero
   GROUP BY SE.ID_equipoMedico
   HAVING cantidadEnfermeros > 1;
-- 7. Datos completos de los coordinadores hospitalarios que forman parte de algún equipo médico.
SELECT S.NIF_sanitario, S.nombre_sanitario, S.primer_apellido_sanitario, COUNT(SE.ID_equipoMedico) AS cantidadEquipos
   FROM (hospitales H INNER JOIN sanitarios_equiposMedicos SE ON H.NIF_coordinador = SE.NIF_sanitario) INNER JOIN sanitarios S ON H.NIF_coordinador = S.NIF_sanitario
   GROUP BY H.NIF_coordinador;
-- 8. Datos completos de los coordinadores hospitalarios que no forman parte de ningún equipo médico.
SELECT S.NIF_sanitario, S.nombre_sanitario, S.primer_apellido_sanitario, COUNT(SE.ID_equipoMedico) AS cantidadEquipos
   FROM (hospitales H LEFT JOIN sanitarios_equiposMedicos SE ON H.NIF_coordinador = SE.NIF_sanitario) INNER JOIN sanitarios S ON H.NIF_coordinador = S.NIF_sanitario
   GROUP BY H.NIF_coordinador
   HAVING cantidadEquipos = 0;
# Consulta equivalente
SELECT S.NIF_sanitario, S.nombre_sanitario, S.primer_apellido_sanitario
   FROM (hospitales H LEFT JOIN sanitarios_equiposMedicos SE ON H.NIF_coordinador = SE.NIF_sanitario) INNER JOIN sanitarios S ON H.NIF_coordinador = S.NIF_sanitario
   WHERE SE.NIF_sanitario IS NULL;
-- 9. Datos completos de los coordinadores hospitalarios no madrileños que forman parte de algún equipo médico.
SELECT S.NIF_sanitario, S.nombre_sanitario, S.primer_apellido_sanitario, H.municipio_hospital, COUNT(SE.ID_equipoMedico) AS cantidadEquipos
   FROM (hospitales H INNER JOIN sanitarios_equiposMedicos SE ON H.NIF_coordinador = SE.NIF_sanitario) INNER JOIN sanitarios S ON H.NIF_coordinador = S.NIF_sanitario
   WHERE H.municipio_hospital != 'MADRID'
   GROUP BY H.NIF_coordinador;
-- 10. Datos completos de los coordinadores hospitalarios no madrileños que forman parte de más de un equipo médico.
SELECT S.NIF_sanitario, S.nombre_sanitario, S.primer_apellido_sanitario, H.municipio_hospital, COUNT(SE.ID_equipoMedico) AS cantidadEquipos
   FROM (hospitales H INNER JOIN sanitarios_equiposMedicos SE ON H.NIF_coordinador = SE.NIF_sanitario) INNER JOIN sanitarios S ON H.NIF_coordinador = S.NIF_sanitario
   WHERE H.municipio_hospital != 'MADRID'
   GROUP BY H.NIF_coordinador
   HAVING cantidadEquipos > 1;