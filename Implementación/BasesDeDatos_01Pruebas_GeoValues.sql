-- Información geográfica (SRID)
/* SRID (Spatial Reference System Identifier): Identificador estándar único que hace referencia a un sistema de coordenadas concreto. 
   - The Well-Known Text (WKT) representation of geometry values is designed for exchanging geometry data in ASCII form. 
   - The Well-Known Binary (WKB) representation of geometric values is used for exchanging geometry data as binary streams. 
 */
-- Muestra los identificadores de referencia espacial (SRID) disponibles
SELECT `srs_name`, `srs_id`
   FROM INFORMATION_SCHEMA.ST_SPATIAL_REFERENCE_SYSTEMS;

CREATE DATABASE IF NOT EXISTS pruebas;
USE pruebas;
/* Sistema de Coordenadas Cartesianas: SRID = 0 */
SET @punto=POINT(0,0);
SELECT ST_SRID(@punto) as SRID;
SELECT @punto; -- Una variable de tipo BLOB (Binary Large Object) puede almacenar un volumen variable de datos.
-- Conversión de tipos: BLOB a texto en formato WKT, BLOB a binario en formato WKB y BLOB a texto en formato JSON
SELECT ST_AsText(@punto) AS punto_texto,     -- Formato WKT
       ST_AsBinary(@punto) AS punto_binario, -- Formato WKB
       ST_AsGeoJson(@punto) AS punto_json;   -- Formato JSON
-- Conversión de tipos: texto en formato WKT a BLOB, binario en formato WKB a BLOB y texto en formato JSON a BLOB
SET @punto_wkt=ST_GeomFromText(ST_AsText(@punto));   -- Coordenadas a partir de WKT
   -- SET @punto_wkt=ST_GeomFromText('POINT(0 0)');     
SET @punto_wkb=ST_GeomFromWKB(ST_AsBinary(@punto));  -- Coordenadas a partir de WKB
SET @punto_wkb=ST_GeomFromWKB(ST_AsGeoJson(@punto)); -- Coordenadas a partir de JSON
   -- SET @punto_json=ST_GeomFromGeoJson('{"type": "Point", "coordinates": [0.0, 0.0]}'); 
SELECT ST_AsText(@punto_wkt) AS desde_texto,
       ST_AsText(@punto_wkb) AS desde_binario,
       ST_AsText(@punto_json) AS desde_json;
-- Otras funciones útiles
SET @origen=ST_GeomFromText('POINT(0 0)');            
SET @destino=ST_GeomFromText('POINT(3 4)');     
SELECT ST_Distance(@origen, @destino) AS distancia,
       ST_X(@destino) AS destino_coorX,
       ST_Y(@destino) AS destino_coorY;
-- Tabla de coordenadas cartesianas
CREATE TABLE IF NOT EXISTS localizaciones_C (
    id       INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre   VARCHAR(10),
    posicion POINT NOT NULL SRID 0
); /* Error Code: 3728. Spatial indexes can't be primary or unique indexes */
CREATE SPATIAL INDEX index_posicion ON localizaciones_C(posicion);
SHOW INDEXES FROM localizaciones_C;
/* A spatial index can only be created on a column with geometry type. It must be a not null column and should contain data of only one SRID. */
INSERT INTO localizaciones_C (nombre,posicion) values ("P1",POINT(65.1383492, 57.1903905));
INSERT INTO localizaciones_C (nombre,posicion) values ("P2",POINT(43.0429124, 1.9038837));
INSERT INTO localizaciones_C (nombre,posicion) values ("P3",POINT(22.879419, 112.292967));
INSERT INTO localizaciones_C (nombre,posicion) values ("P4",POINT(13.513211, 122.469352));
INSERT INTO localizaciones_C (nombre,posicion) values ("P5",POINT(4.6096768, 101.1064003));
INSERT INTO localizaciones_C (nombre,posicion) values ("P6",POINT(27.861901, 83.5443287));
INSERT INTO localizaciones_C (nombre,posicion) values ("P7",POINT(34.0112004, 71.9795856));
INSERT INTO localizaciones_C (nombre,posicion) values ("P8",POINT(57.1785037, 14.0676645));
INSERT INTO localizaciones_C (nombre,posicion) values ("P9",POINT(15.1786657, 101.7637775));
INSERT INTO localizaciones_C (nombre,posicion) values ("P10",POINT(-10.0745443, -77.1449212));
INSERT INTO localizaciones_C (nombre,posicion) values ("P11",POINT(44.0970463, 21.4322091));
INSERT INTO localizaciones_C (nombre,posicion) values ("P12",POINT(32.052539, 35.125431));
INSERT INTO localizaciones_C (nombre,posicion) values ("P13",POINT(-33.6740514, -54.2101894));
INSERT INTO localizaciones_C (nombre,posicion) values ("P14",POINT(44.7800716, 44.1646857));
INSERT INTO localizaciones_C (nombre,posicion) values ("P15",POINT(49.0261841, 1.1518478));
# ¿Posiciones que se encuentran a una distancia del origen igual o inferior que 100?
SET @origenUsuario_C=ST_GeomFromText('POINT(0 0)');
SELECT id, nombre, ST_AsText(posicion), ST_Distance(posicion, @origenUsuario_C) AS distancia
FROM localizaciones_C
WHERE ST_Distance(posicion, @origenUsuario_C) <= 100;

/* Sistema de Coordenadas Geográficas: SRID = 4326 */
-- Tabla de coordenadas geográficas
CREATE TABLE IF NOT EXISTS localizaciones_G (
    id       INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre   VARCHAR(10),
    posicion POINT NOT NULL SRID 4326
); 
CREATE SPATIAL INDEX index_posicion ON localizaciones_G(posicion);
SHOW INDEXES FROM localizaciones_G;
INSERT INTO localizaciones_G (nombre,posicion) values ("P1",ST_GeomFromText('POINT(65.1383492 57.1903905)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P2",ST_GeomFromText('POINT(43.0429124 1.9038837)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P3",ST_GeomFromText('POINT(22.879419 112.292967)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P4",ST_GeomFromText('POINT(13.513211 122.469352)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P5",ST_GeomFromText('POINT(4.6096768 101.1064003)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P6",ST_GeomFromText('POINT(27.861901 83.5443287)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P7",ST_GeomFromText('POINT(34.0112004 71.9795856)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P8",ST_GeomFromText('POINT(57.1785037 14.0676645)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P9",ST_GeomFromText('POINT(15.1786657 101.7637775)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P10",ST_GeomFromText('POINT(-10.0745443 -77.1449212)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P11",ST_GeomFromText('POINT(44.0970463 21.4322091)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P12",ST_GeomFromText('POINT(32.052539 35.125431)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P13",ST_GeomFromText('POINT(-33.6740514 -54.2101894)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P14",ST_GeomFromText('POINT(44.7800716 44.1646857)', 4326));
INSERT INTO localizaciones_G (nombre,posicion) values ("P15",ST_GeomFromText('POINT(49.0261841 1.1518478)', 4326));
# ¿Posiciones que se encuentran a una distancia del origen igual o inferior que 900*9000?
SET @origenUsuario_G=ST_GeomFromText('POINT(0 0)', 4326);
SELECT id, nombre, ST_AsText(posicion), ST_Distance_Sphere(posicion, @origenUsuario_G) AS distancia
FROM localizaciones_G
WHERE ST_Distance_Sphere(posicion, @origenUsuario_G) <= 900*9000;