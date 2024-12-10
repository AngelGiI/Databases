-- 2. Actualización de datos. Parte 1
/* Lenguaje de Modificación de Datos o DML (Data Manipulation Language)
   - INSERT: Inserción de datos.
   - UPDATE: Modificación de datos.
   - DELETE: Eliminación de datos. 
 */  
USE gestionOrganos;

ALTER TABLE hospitales MODIFY COLUMN NIF_coordinador CHAR(9) NULL;
INSERT INTO hospitales (ID_hospital,nombre_hospital,municipio_hospital,tipo_hospital,NIF_coordinador) VALUES
   ("110012","HOSPITAL PUERTA DEL MAR","CADIZ",'I',NULL),
   ("110259","COMPLEJO HOSPITALARIO PUNTA DE EUROPA","ALGECIRAS",'II',NULL),
   ("110184","COMPLEJO HOSPITALARIO DE PUERTO REAL","PUERTO REAL",'III',NULL),
   ("140023","COMPLEJO HOSPITALARIO REGIONAL REINA SOFIA","CORDOBA",'I',NULL),
   ("220015","HOSPITAL SAN JORGE","HUESCA",'I',NULL),
   ("500016","HOSPITAL CLINICO UNIVERSITARIO LOZANO BLESA","ZARAGOZA",'I',NULL),
   ("500021","HOSPITAL UNIVERSITARIO MIGUEL SERVET","ZARAGOZA",'III',NULL),
   ("070309","HOSPITAL MANACOR","MANACOR",'III',NULL),
   ("350056","HOSPITAL UNIVERISTARIO INSULAR DE GRAN CANARIA","LAS PALMAS DE GRAN CANARIA",'I',NULL),
   ("350311","HOSPITAL UNIVERSITARIO DE GRAN CANARIA DR. NEGRIN","LAS PALMAS DE GRAN CANARIA",'II',NULL), 
   ("350271","HOSPITAL DE SAN ROQUE GUIA","LAS PALMAS DE GRAN CANARIA",'III',NULL),
   ("400019","HOSPITAL GENERAL DE SEGOVIA","SEGOVIA",'III',NULL),
   ("420040","HOSPITAL SANTA BARBARA","SORIA",'III',NULL),
   ("470014","HOSPITAL UNIVERSITARIO RIO HORTEGA","VALLADOLID",'III',NULL),
   ("470029","HOSPITAL CLINICO UNIVERSITARIO DE VALLADOLID","VALLADOLID",'I',NULL),
   ("020030","HOSPITAL GENERAL UNIVERSITARIO DE ALBACETE","ALBACETE",'I',NULL),
   ("020117","HOSPITAL UNIVERSITARIO NUESTRA SRA. DEL PERPETUO SOCORRO","ALBACETE",'II',NULL),
   ("081347","HOSPITAL UNIVERSITARI VALL D'HEBRON","BARCELONA",'I',NULL),
   ("080484","HOSPITAL DE BARCELONA","BARCELONA",'I',NULL),
   ("080446","HOSPITAL UNIVERSITARI QUIRON DEXEUS","BARCELONA",'II',NULL),
   ("080399","HOSPITAL QUIRON SALUD BARCELONA","BARCELONA",'III',NULL),
   ("430017","HOSPITAL UNIVERSITARI JOAN XXIII DE TARRAGONA","TARRAGONA",'II',NULL),
   ("060016","COMPLEJO HOSPITALARIO UNIVERSITARIO DE BADAJOZ","BADAJOZ",'II',NULL),
   ("270018","COMPLEXO HOSPITALARIO UNIVERSITARIO DE LUGO","LUGO",'I',NULL),
   ("280029","HOSPITAL RAMON Y CAJAL","MADRID",'I',NULL),
   ("280035","HOSPITAL UNIVERSITARIO 12 DE OCTUBRE","MADRID",'I',NULL),
   ("280072","HOSPITAL CLINICO SAN CARLOS","MADRID",'I',NULL),
   ("280112","HOSPITAL UNIVERSITARIO SANTA CRISTINA","MADRID",'II',NULL),
   ("280127","HOSPITAL UNIVERSITARIO DE LA PRINCESA","MADRID",'II',NULL),
   ("281270","HOSPITAL UNIVERSITARIO INFANTA LEONOR","MADRID",'III',NULL),
   ("300362","HOSPITAL GENERAL UNIVERSITARIO SANTA LUCIA","CARTAGENA",'III',NULL),
   ("480010","HOSPITAL SANTA MARINA","BILBAO",'III',NULL);
INSERT INTO sanitarios (NIF_sanitario,nombre_sanitario,primer_apellido_sanitario,segundo_apellido_sanitario,tipo_sanitario,ID_hospital) VALUES
   ("15641846Y","Gretchen","Munoz","Cantrell",TRUE,"110012"),
   ("43229340N","Yeo","Kerr","Owen",FALSE,"110012"),
   ("23854829B","Dillon","Goodman","Yates",FALSE,"110012"),
   ("33527488C","Vielka","Michael","Oneal",TRUE,"110259"),
   ("43947267V","Harper","Newman","Mays",FALSE,"110259"),
   ("37463430H","Chiquita","Barrett","Everett",TRUE,"110184"),
   ("37527305E","Raja","Zamora","Riddle",FALSE,"110184"),
   ("10810357N","Candice","Schwartz","King",FALSE,"140023"),
   ("50063134T","Ruth","Hernandez","Ellis",TRUE,"140023"),
   ("8258524Y","Simone","Acosta","Wiggins",TRUE,"140023"),   
   ("49949808H","Rana","Romero","Oconnor",FALSE,"220015"),
   ("21875327G","Riley","Nguyen","Baxter",TRUE,"220015"),
   ("21546950K","Fritz","Andrews","Rodgers",TRUE,"500016"),
   ("22575890X","Daria","Dawson","Harding",FALSE,"500016"),
   ("42239217Q","Octavius","Matthews","Pearson",FALSE,"500021"),
   ("34301586F","Kennedy","Bradford","Mendez",TRUE,"500021"),
   ("37684359D","Maxwell","Welch","Cote",TRUE,"500021"),
   ("36631532F","Jada","Bowen","Lynch",FALSE,"070309"),
   ("41919039K","Wylie","Washington","Cunningham",FALSE,"070309"),
   ("50391989R","Neil","Harrington","Malone",TRUE,"070309"),
   ("18545073N","Emma","Singleton","Oliver",TRUE,"350056"),
   ("7155620K","Casey","Brady","Bailey",NULL,"350056"),
   ("15469139Y","Nathan","Herring","Ward",FALSE,"350056"),
   ("49712732A","Isaac","Ramos","Pickett",TRUE,"350056"),
   ("32480015J","Maxine","Reese","Camacho",TRUE,"350271"),
   ("40917158C","Upton","Hays","Boone",FALSE,"350271"),
   ("15282482V","Allistair","Mcpherson","May",TRUE,"400019"),
   ("38783668X","Glenna","Gross","Mendez",FALSE,"400019"),
   ("8855056X","Hayfa","Gibbs","Marshall",FALSE,"400019"),
   ("29752629J","Sade","Ballard","Park",NULL,"400019"),
   ("25825753L","Savannah","Hart","Barron",TRUE,"350311"),
   ("48748795L","Aladdin","Sparks","Salinas",FALSE,"350311"),
   ("43334574K","Drake","Spears","Foster",FALSE,"420040"),
   ("25034974A","Blossom","Levy","Fuentes",TRUE,"470014"),
   ("26479227V","Troy","Prince","Harmon",FALSE,"470014"),
   ("16005543G","Amy","Harrington","Austin",TRUE,"081347"),
   ("10785237P","Urielle","Hood","Schmidt",NULL,"081347"),
   ("7713561M","Allegra","Kinney","Chase",TRUE,"081347"),
   ("38423770Q","Zachery","Vazquez","Barrera",NULL,"081347"),
   ("30385866Z","Davis","Yang","Nunez",TRUE,"081347"),
   ("12367891D","Ella","Martinez","Anderson",FALSE,"081347"),
   ("33381133Z","Buffy","Tanner","Hodge",FALSE,"081347"),
   ("43455086J","Brendan","Blanchard","Terrell",TRUE,"020030"),
   ("13589067T","Galvin","Pearson","Neal",FALSE,"020030"),
   ("11060703A","Amber","Ferguson","Ingram",FALSE,"020117"),
   ("32072695T","Len","Acevedo","Ortega",TRUE,"020117"),
   ("46031924T","Geoffrey","Knox","Holloway",TRUE,"080399"),
   ("25824910G","Hall","Wheeler","Rosa",TRUE,"080399"),
   ("11190691H","Xandra","Baker","Stevenson",FALSE,"080399"),
   ("44755402R","Brynn","Santana","Greer",FALSE,"080399"),
   ("16110411S","Reese","Oconnor","Mcdowell",TRUE,"420040"), 
   ("16801016E","Alfonso","Wolf",NULL,TRUE,"470029"),
   ("34585174M","Mary","Graham","Mueller",TRUE,"080399"),
   ("45001126Q","Deanna","Clarke","Greene",NULL,"080399"),
   ("50619768B","Claire","Vance","Horn",TRUE,"080446"),
   ("15669424F","Marah","Love","Cote",FALSE,"080446"),
   ("21231716W","Glenna","Ruiz","Allen",TRUE,"080399"),
   ("39005828J","Austin","Raymond","Delacruz",FALSE,"080399"),
   ("64029924V","Harper","Petersen","Baxter",TRUE,"430017"),
   ("27314149Q","Nigel","Tate","Fischer",FALSE,"430017"),
   ("36015536C","Yuli","Herman","Goodwin",TRUE,"060016"),
   ("46745582Z","Kaseem","Stanton","Justice",TRUE,"270018"),
   ("18558047Z","Cynthia","Wells","Clements",NULL,"270018"),
   ("21758994M","Kyra","Ware","Levy",TRUE,"270018"),
   ("8244373T","Maxine","Foreman","Nichols",FALSE,"270018"),
   ("14556976T","Raven","Clayton","Snyder",TRUE,"280029"),
   ("46798413Z","Yetta","Hardin","Willis",FALSE,"280029"),
   ("46106270X","Yeo","Fernandez","Chang",TRUE,"280029"),
   ("13677751L","Melvin","Murray","Cameron",TRUE,"280035"),
   ("12979472C","Chloe","Malone","Morin",FALSE,"280035"),
   ("31278758T","Bevis","Walters","Barr",TRUE,"280035"),
   ("45562420H","Debra","Perez","Butler",NULL,"280035"),
   ("21399985A","Kaye","Donovan","Frost",TRUE,"280072"),
   ("14798455W","Cody","Flores","Hartman",TRUE,"280072"),
   ("41386411G","Edan","Malone","Wilder",FALSE,"280072"),
   ("45309224Y","Halla","Guerrero","Cobb",FALSE,"280072"),
   ("38033773F","Rahim","Hicks","Hahn",TRUE,"280112"),
   ("40990694W","Thomas","Oliver","Alexander",FALSE,"280112"),
   ("48564527G","Raymond","House","Sexton",TRUE,"280112"),
   ("12613505Y","Doris","Moran","Weiss",FALSE,"280112"),
   ("40734434P","Lani","Kaufman","Oneal",TRUE,"280127"),
   ("21298653D","Martin","Nash","Brown",FALSE,"280127"),
   ("13226919X","Castor","Salazar","Conner",FALSE,"280127"),
   ("20969723W","Dawn","Whitaker","Mcmillan",TRUE,"281270"),
   ("48565894Z","Samantha","Hodge","Mayer",FALSE,"281270"),
   ("49946256P","Hermione","Kim","Powell",NULL,"281270"),
   ("21005642H","Holmes","Castaneda","Richards",NULL,"281270"),
   ("29422615A","Erin","Kane","Tucker",FALSE,"300362"),
   ("19573288N","Vaughan","Elliott","Ross",NULL,"300362"),
   ("41795869Q","Constance","Farley","Reyes",TRUE,"300362"),
   ("35978311D","Hasad","Burt","Scott",TRUE,"480010"),
   ("47394290F","Kelsie","Sheppard","Schroeder",FALSE,"480010"),
   ("17908589F","Cassandra","Finley","Nash",TRUE,"080484"),
   ("16390516A","Kay","Huffman","Randall",TRUE,"080484"),
   ("33393248P","Eagan","Perry","Sellers",FALSE,"080484"),
   ("39146453Q","Cedric","Adams","Riddle",FALSE,"080484");
INSERT INTO medicos (NIF_medico,especialidad_medico) VALUES 
   ("15641846Y",'NEFROLOGIA'),
   ("33527488C",'HEPATOLOGIA'),
   ("37463430H",'HEPATOLOGIA'),
   ("50063134T",'CARDIOLOGIA'),
   ("8258524Y",'GASTROENTEROLOGIA'),   
   ("21875327G",'NEUMOLOGIA'),
   ("21546950K",'GASTROENTEROLOGIA'),
   ("34301586F",'NEFROLOGIA'),
   ("37684359D",'GASTROENTEROLOGIA'),
   ("50391989R",'HEPATOLOGIA'),
   ("18545073N",'CARDIOLOGIA'),
   ("49712732A",'NEFROLOGIA'),
   ("32480015J",'GASTROENTEROLOGIA'),
   ("15282482V",'NEUMOLOGIA'),
   ("25825753L",'NEFROLOGIA'),
   ("16110411S",'CARDIOLOGIA'), 
   ("16801016E",'GASTROENTEROLOGIA'),
   ("25034974A",'NEFROLOGIA'),
   ("16005543G",'GASTROENTEROLOGIA'),
   ("7713561M",'NEFROLOGIA'),
   ("30385866Z",'NEFROLOGIA'),
   ("43455086J",'HEPATOLOGIA'),
   ("32072695T",'CARDIOLOGIA'),
   ("46031924T",'GASTROENTEROLOGIA'),
   ("25824910G",'HEPATOLOGIA'),
   ("34585174M",'CARDIOLOGIA'),
   ("50619768B",'GASTROENTEROLOGIA'),
   ("21231716W",'NEFROLOGIA'),
   ("64029924V",'NEUMOLOGIA'),
   ("36015536C",'NEFROLOGIA'),
   ("46745582Z",'HEPATOLOGIA'),
   ("21758994M",'NEUMOLOGIA'),
   ("14556976T",'NEFROLOGIA'),
   ("46106270X",'GASTROENTEROLOGIA'),
   ("13677751L",'CARDIOLOGIA'),
   ("31278758T",'NEUMOLOGIA'),
   ("21399985A",'HEPATOLOGIA'),
   ("14798455W",'GASTROENTEROLOGIA'),
   ("38033773F",'HEPATOLOGIA'),
   ("48564527G",'NEFROLOGIA'),
   ("40734434P",'NEUMOLOGIA'),
   ("20969723W",'HEPATOLOGIA'),
   ("41795869Q",'CARDIOLOGIA'),
   ("35978311D",'NEFROLOGIA'),
   ("17908589F",'CARDIOLOGIA'),
   ("16390516A",'NEUMOLOGIA');   
INSERT INTO enfermeros (NIF_enfermero,NIF_supervisor) VALUES
   ("43229340N",NULL),
   ("23854829B","43229340N"),
   ("43947267V",NULL),
   ("37527305E",NULL),
   ("10810357N",NULL),
   ("49949808H",NULL),
   ("22575890X",NULL),
   ("42239217Q",NULL),
   ("36631532F",NULL),
   ("41919039K","36631532F"),
   ("15469139Y",NULL),
   ("40917158C",NULL),
   ("38783668X",NULL),
   ("8855056X","38783668X"),
   ("48748795L",NULL),
   ("43334574K",NULL),
   ("26479227V",NULL),
   ("12367891D",NULL),
   ("33381133Z","12367891D"),
   ("13589067T",NULL),
   ("11060703A",NULL),
   ("11190691H",NULL),
   ("44755402R","11190691H"),
   ("15669424F",NULL),
   ("39005828J","11190691H"),
   ("27314149Q",NULL),
   ("8244373T",NULL),
   ("46798413Z",NULL),
   ("12979472C",NULL),
   ("41386411G",NULL),
   ("45309224Y","41386411G"),
   ("40990694W",NULL),
   ("12613505Y","40990694W"),
   ("21298653D",NULL),
   ("13226919X","21298653D"),
   ("48565894Z",NULL),
   ("29422615A",NULL),
   ("19573288N","29422615A"),
   ("41795869Q","29422615A"),
   ("35978311D",NULL),
   ("47394290F","35978311D"),
   ("33393248P",NULL),
   ("39146453Q","33393248P");
CREATE TEMPORARY TABLE coordinadores (
   NIF_coordinador CHAR(9) NOT NULL,
   ID_hospital     CHAR(6) NOT NULL  
);
SHOW CREATE TABLE coordinadores;
INSERT INTO coordinadores (NIF_coordinador,ID_hospital) VALUES
   ("15641846Y","110012"),
   ("33527488C","110259"),
   ("37463430H","110184"),
   ("8258524Y","140023"),
   ("21875327G","220015"),
   ("21546950K","500016"),
   ("37684359D","500021"),
   ("50391989R","070309"),
   ("18545073N","350056"),
   ("25825753L","350311"),
   ("32480015J","350271"),
   ("15282482V","400019"),
   ("25034974A","470014"),
   ("43455086J","020030"),
   ("32072695T","020117"),
   ("16005543G","081347"),
   ("16390516A","080484"),
   ("50619768B","080446"),
   ("34585174M","080399"),
   ("64029924V","430017"),
   ("36015536C","060016"),
   ("21758994M","270018"),
   ("14556976T","280029"),
   ("31278758T","280035"),
   ("21399985A","280072"),
   ("48564527G","280112"),
   ("40734434P","280127"),
   ("20969723W","281270"),
   ("41795869Q","300362"),
   ("35978311D","480010"),
   ("16110411S","420040"),
   ("16801016E","470029");
SELECT * FROM coordinadores;
UPDATE hospitales
   INNER JOIN coordinadores ON hospitales.ID_hospital = coordinadores.ID_hospital
   SET hospitales.NIF_coordinador = coordinadores.NIF_coordinador;
DROP TABLE coordinadores; 
ALTER TABLE hospitales MODIFY COLUMN NIF_coordinador CHAR(9) NOT NULL;