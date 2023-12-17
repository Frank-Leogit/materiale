/* 
2023-02-16-LeottaGianfranco
2) Da un’analisi del database risulta che lo schema fisico del database è così rappresentato:
Iscritti(IdIscritto, Nome, Cognome,Sesso,DataDiNascita,IdNazione,IdFasciaReddito)
Nazioni(IdNazione, NomeNazione)
VotiPreUniversity(IdVoto, IdStudente, VotoSuperiori,VotoTestAmmissione)
Si richiede di creare le tabelle nel database ‘University’, utilizzando le tabelle importate nel punto 1.
Suggerimento creare una query che contiene il risultato aspettato e poi inserirla in una CREATE TABLE.
ATTENZIONE: per il campo Id, creare prima la tabella senza la primary key, poi modificare la tabella da
interfaccia creando la chiave. Per la soluzione a questo esercizio è necessario riportare anche l’istruzione SQL
per l’inserimento dell’ID. */

DROP TABLE IF EXISTS Nazioni;
CREATE TABLE Nazioni (
SELECT
1 AS IdNazione,
"Portogallo" as NomeNazione
);
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("2","Giappone");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("3","USA");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("4","Spagna");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("5","Russia");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("6","Italia");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("7","UK");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("8","Cina");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("9","Svizzera");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("10","Romania");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("11","Germania");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("12","Brasile");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("13","Austria");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("14","Belgio");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("15","Turchia");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("16","Rep. Ceca");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("17","Polonia");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("18","Norvegia");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("19","Croatia");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("20","Argentina");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("21","Slovenia");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("22","Finlandia");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("23","Cile");
INSERT INTO nazioni(IdNazione,NomeNazione) VALUES ("24","Francia");
ALTER TABLE `university`.`nazioni` 
CHANGE COLUMN `IdNazione` `IdNazione` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
ADD PRIMARY KEY (`IdNazione`);

DROP TABLE IF EXISTS Iscritti;
CREATE TABLE Iscritti (
SELECT
substring(`nome e cognome`,locate(" ",`nome e cognome`)+1,length(`nome e cognome`)-locate(" ",`nome e cognome`)) as Nome,
substring(`nome e cognome`,1,locate(" ",`nome e cognome`)-1) as Cognome,
Sesso,
`Data di nascita`,
idNazione,
`Fascia di reddito`AS IdFasciaDiReddito
FROM inputuniversity
INNER JOIN nazioni on paese=nomenazione
);
ALTER TABLE `university`.`iscritti` 
ADD COLUMN `IdIscritto` INT UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
ADD PRIMARY KEY (`IdIscritto`);

DROP TABLE IF EXISTS VotiPreUniversity;
CREATE TABLE VotiPreUniversity (
SELECT 
`Valutazione scuola superiore` AS VotoSuperiori,
`Punteggio test di ammissione` AS VotoTestAmmissione
FROM inputuniversity
);
ALTER TABLE `university`.`votipreuniversity` 
ADD COLUMN `IdIscritto` INT UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
ADD PRIMARY KEY (`IdIscritto`);

/* 3) 2023-02-16-LeottaGianfranco
Creare una VISTA chiamata ‘StudentiBorse’ composta dai seguenti campi:
IdIscritto, Nome, Cognome, Sesso, Borsa
Dove il campo Sesso contiene i valori ‘Uomo’ e ‘Donna’ se rispettivamente nella tabella di origine era
presente ‘M’ o ‘F’ e,
il campo Borsa contiene il testo ‘VERO’ se l&#39;alunno ha diritto alla borsa di studio, altrimenti restituirà
‘FALSO’.
Un alunno ha diritto alla borsa di studio se la fascia di reddito è compresa tra 1 e 5 e il punteggio è maggiore
di 800 compreso. */

DROP VIEW IF EXISTS StudentiBorse;
CREATE VIEW StudentiBorse AS (
SELECT vpu.IdIscritto Nome, Cognome, 
IF(Sesso="M","Uomo","Donna") as Sesso,
IF(VotoTestAmmissione>800 AND IdFasciaDiReddito>=1 and IdFasciaDiReddito<=5,"VERO","FALSO")AS Borsa
FROM Iscritti as i 
INNER JOIN votipreuniversity as vpu on vpu.idIscritto=i.IdIscritto
);
/*
4) 2023-02-16-LeottaGianfranco
Creare una vista chiamata ‘VotiConfronto’ che ha 2 nuove colonne RapportoVotoSuperiori ed
RapportoVotoTestAmmissione. Queste colonne sono calcolate, per esempio per la colonna
RapportoVotoSuperiori, facendo il rapporto del voto delle superiori con il voto max tra i voti delle superiori
presente nella tabella (es. VotoSuperiori iscritto/Voto Massimo superiori presente in tabella) e per la
colonna VotoPreAmmissione, facendo il rapporto del voto nel test ammissione con il voto max nel test di
ammissione presente in tabella (es. VotoTestAmmissione iscritto/Voto Massimo Test Ammissioni presente
in tabella).
*/
DROP VIEW IF EXISTS VotiConfronto;
CREATE VIEW VotiConfronto AS(
SELECT 
VotoSuperiori/(SELECT MAX(VotoSuperiori) FROM votipreuniversity) AS RapportoVotoSuperiori,
VotoTestAmmissione/(SELECT MAX(VotoTestAmmissione) FROM votipreuniversity) AS RapportoVotoTestAmmissione
FROM votipreuniversity
);
/*
5) 2023-02-16-LeottaGianfranco
Creare una nuova tabella chiamata 'Email'; composta dai seguenti campi:
-IdEmail,
-Email, sarà presente la mail dello studente generata utilizzando le colonne nome e cognome della tabella
iscritti. Esempio per lo studente &quot;Rossi Mario&quot; sarà mario.rossi@miascuola.it
-IdIscritto (chiave esterna della tabella iscritti).
*/
DROP TABLE IF EXISTS Email;
CREATE TABLE Email (
SELECT 
concat(nome,".",cognome,"@miascuola.it") as Email,
IdIscritto
FROM iscritti
);
ALTER TABLE `university`.`email` 
ADD COLUMN `IdEmail` INT UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
ADD PRIMARY KEY (`IdEmail`);

/*
6) 2023-02-16-LeottaGianfranco
Crea una nuova vista chiamata &#39;Pivot&#39; con una tabella pivot che raggruppi i dati per riga utilizzando il
campo sesso e Nazione. Per ogni nazione calcolare quante donne e quanti uomini si sono iscritti.
Campi vista:
-NomeNazione
-Sesso
-NumIscritti
*/
DROP VIEW IF EXISTS Pivot;
CREATE VIEW Pivot as (
SELECT
NomeNazione,
Sesso,
COUNT(*) as NumeroIscritti
FROM iscritti as i
 INNER JOIN nazioni as n on n.IdNazione=i.idNazione
group by NomeNazione, Sesso ORDER BY NomeNazione
)

