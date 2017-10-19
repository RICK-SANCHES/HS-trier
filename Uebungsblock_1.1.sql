--1)
SELECT name, matrikelnr
FROM studentische_person
INNER JOIN studiengang
ON studentische_person.studiengangnr = studiengang.studiengangnr
WHERE Bezeichnung = 'BA International Business';


--2)Ermitteln Sie alle Studenten (Name, Matrikelnr), die einem Studiengang des Fachbereichs 10 (Wirtschaft) angehören
SELECT name, matrikelnr
FROM studentische_person
INNER JOIN studiengang
ON studentische_person.studiengangnr = studiengang.studiengangnr
WHERE fachbereichnr = 10;
--ODER:
SELECT name, matrikelnr
FROM studentische_person
INNER JOIN studiengang
ON studentische_person.studiengangnr = studiengang.studiengangnr
INNER JOIN fachbereich fb
ON studiengang.fachbereichnr = fb.fachbereichnr
WHERE fb.bezeichnung = 'Wirtschaft';
--ODER:
SELECT name, matrikelnr
FROM studentische_person
WHERE studiengangnr IN(
	select studiengangnr
	FROM studiengang stg
	INNER JOIN fachbereich fb
	ON stg.fachbereichnr = fb.fachbereichnr
	WHERE fb.bezeichnung = 'Wirtschaft'
);

--3)Ermitteln Sie alle Klausuren (alle Spalten), zu denen noch keine Anmeldung vorliegt
SELECT * 
FROM klausur 
WHERE klausurnr NOT IN (SELECT klausurnr FROM anmeldung);

--4)  Ermitteln Sie alle Fächer, zu denen keine Klausur angeboten wird.

SELECT * 
FROM fach 
WHERE fachnr NOT IN (SELECT fachnr FROM klaus_bezie_angebo);

--5) Gönnen Sie dem Studenten 123456 (Hugo Mc Kinnock) in einer Klausur eine Notenverbesserung um 1 ganze Stufe (bei einer Note besser als 2 setzen Sie die Note auf 1 fest) und ändern Sie die Klausurnr in eine andere vorliegende Klausurnr.

UPDATE anmeldung 
SET note = GREATEST(note-1,1), klausurnr = 5
WHERE matrikelnr = 123456 AND klausurnr = 3;


--6)
UPDATE anmeldung
  SET note = 1.3	
  WHERE klausurnr = 3;
  
--7)Ermitteln Sie alle benoteten Leistungsscheine, die nicht im 1. oder 2. Versuch bestanden wurden.

select * from leistungsschein 
WHERE note IS NOT NULL
AND anzahl_versuche not IN (1,2);

--8) Gibt es unbenotete Leistungsscheine, bei denen die Anzahl der Versuche nicht mit 1 eingetragenFROM leistungsschein  ist? Ggf. bitte anzeigen.

SELECT * 
FROM leistungsschein
WHERE note is NULL
and (anzahl_versuche is null OR anzahl_versuche <> 1);
--9)	Ermitteln Sie alle Studenten (Matrikelnr, Note), die die Note 1,7 in mind. einer Klausur oder mind. in einem Leistungsschein haben.

SELECT matrikelnr, note
FROM anmeldung
WHERE note = 1.7
UNION SELECT matrikelnr, note FROM leistungsschein
WHERE note = 1.7;

--10) Welche Noten sind in welchem Fach (Note und Bezeichnung des Faches anzeigen) bisher an Leistungsscheinen erzielt worden?

SELECT DISTINCT note, bezeichnung 
FROM leistungsschein
INNER JOIN fach
on (leistungsschein.fachnr = fach.fachnr)
WHERE note IS NOT NULL;

--11)	Zeigen Sie alle Studenten an, deren Unix_Name mit M beginnt und kein L enthält?

SELECT name
FROM studentische_person
WHERE unix_name LIKE 'M%'
AND unix_name != '%L%';

--12)Welche Studenten studieren weder Wirtschaftsinformatik noch Betriebswirtschaft, gehören aber zum Fachbereich Wirtschaft? Zeigen Sie bitte Matrikelnr, Name, Studiengang und Fachbereich an.

SELECT matrikelnr, name, s.bezeichnung studiengang, f.bezeichnung fachbereich
FROM studentische_person st 
 	INNER JOIN studiengang s ON(st.studiengangnr=s.studiengangnr) 
 	INNER JOIN fachbereich f ON (s.fachbereichnr = f.fachbereichnr)
WHERE f.Bezeichnung = 'Wirtschaft'
AND s.bezeichnung NOT LIKE '%Wirtschaftsinformatik' and 
      s.bezeichnung not like '%Betriebswirtschaft';
	 
--13) Welche Klausuren (Klausurnr, Fachnr, Datum) gibt es in den Fächern Mathematik und Steuern?

SELECT k.klausurnr, kba.fachnr, k.datum 
FROM klausur k 
INNER JOIN klaus_bezie_angebo kba 
	ON (k.klausurnr = kba.klausurnr)
WHERE fachnr IN (SELECT fachnr FROM fach 
               WHERE bezeichnung = ’Mathematik’ or Bezeichnung like ’Steuern%’);
			
			

