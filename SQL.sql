***** _SYSTEM_ *****
-- Tablespaces
CREATE TABLESPACE ts_cinema DATAFILE '[PATH]\cinemadbos.dbf' SIZE 150M;
CREATE TABLESPACE ts_lob DATAFILE '[PATH]\reviewlob.dbf' SIZE 300M;

-- USER cinemadba
CREATE USER cinemadba DEFAULT TABLESPACE ts_cinema IDENTIFIED BY 12345;
GRANT DBA, UNLIMITED TABLESPACE TO cinemadba;

***** _CINEMADBA_ *****
-- USER webapp
CREATE USER webapp DEFAULT TABLESPACE ts_cinema IDENTIFIED BY 12345;
GRANT CONNECT TO webapp;
GRANT SELECT ON cinemadba.FILM_IN_PROGRAMMAZIONE TO webapp;
GRANT SELECT ON cinemadba.ARTISTA TO webapp;
GRANT SELECT ON cinemadba.CINEMA TO webapp;
GRANT SELECT ON cinemadba.PALINSESTO TO webapp;
GRANT SELECT ON cinemadba.ARTISTA TO webapp;
GRANT SELECT ON cinemadba.POSTO TO webapp;
GRANT SELECT ON cinemadba.POSTO_SCELTO TO webapp;
GRANT SELECT ON cinemadba.SALA TO webapp;
GRANT SELECT ON cinemadba.TELEFONO TO webapp;
GRANT SELECT ON cinemadba.UTENTE TO webapp;

GRANT INSERT  ON cinemadba.UTENTE TO webapp;
GRANT INSERT  ON cinemadba.POSTO_SCELTO TO webapp;
GRANT INSERT  ON cinemadba.PRENOTAZIONI TO webapp;

-- USER admin
CREATE USER admin DEFAULT TABLESPACE ts_cinema IDENTIFIED BY 12345;
GRANT CONNECT                                                    TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.PRENOTAZIONI           TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.CINEMA                 TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.TELEFONO               TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.SALA                   TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.POSTO                  TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.PALINSESTO             TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.PROGRAMMAZIONI         TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.FILM_IN_PROGRAMMAZIONE TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.ARTISTA                TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.CASTING                TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.LOCAZIONI              TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.PRENOTAZIONI           TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.POSTO_SCELTO           TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.UTENTE                 TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.PRENOTAZIONI           TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.CINEMA                 TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.TELEFONO               TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.SALA                   TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.POSTO                  TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.PALINSESTO             TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.PROGRAMMAZIONI         TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.FILM_IN_PROGRAMMAZIONE TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.ARTISTA                TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.CASTING                TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.LOCAZIONI              TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.PRENOTAZIONI           TO admin;
GRANT SELECT, INSERT, UPDATE ON cinemadba.POSTO_SCELTO           TO admin;









-- Tables
CREATE TABLE CINEMA (
   id        NUMBER(2)    NOT NULL,
   nome      VARCHAR2(20) NOT NULL,
   via       VARCHAR2(30) NOT NULL,
   cap       NUMBER(6)    NOT NULL,
   n_civico  NUMBER(3)    NOT NULL,
   cantone   VARCHAR2(30) NOT NULL,
   n_sale    NUMBER(2)    NOT NULL,
   citta     VARCHAR(30)   NOT NULL,
   CONSTRAINT PK_CINEMA
   PRIMARY KEY (id)
)
STORAGE (INITIAL 6250K)

CREATE TABLE TELEFONO (
   numero       NUMBER(11) NOT NULL,
   codCinema    NUMBER(2)  NOT NULL,
   CONSTRAINT PK_TELEFONO
   PRIMARY KEY  (numero)
)
STORAGE (INITIAL 10K)

CREATE TABLE SALA (
  id          CHAR(1)   NOT NULL,
  superficie  NUMBER(3) NOT NULL,
  capienza    NUMBER(3) NOT NULL,
  CHECK       (capienza<400),
  codCinema   NUMBER(2) NOT NULL,
   
  CONSTRAINT PK_SALA
  PRIMARY KEY (id,codCinema)
)
STORAGE (INITIAL 10K)

CREATE TABLE POSTO (
  id           NUMBER(3)   NOT NULL,
  n_fila       CHAR(1)     NOT NULL,
  n_col        NUMBER(2)   NOT NULL,
  free         NUMBER(1)  NOT NULL,
  CHECK        (free=1 OR free=0),
  codSala      CHAR(1)     NOT NULL,
  CONSTRAINT UN_fi_col_sala
  UNIQUE (n_fila,n_col,codSala),
  CONSTRAINT PK_POSTO
  PRIMARY KEY (id)
)
STORAGE (INITIAL 10K)

CREATE TABLE PALINSESTO (
  id            NUMBER(9) NOT NULL,
  data_e_ora    DATE      NOT NULL,
  codCinema     NUMBER(2) NOT NULL,
  codSala       CHAR(1)   NOT NULL,
  codFilm       CHAR(9)   NOT NULL,
  CONSTRAINT UN_pal
  UNIQUE (data_e_ora,codCinema,codSala,codFilm),
  CONSTRAINT PK_PALINSESTO
  PRIMARY KEY (id)
)
STORAGE (INITIAL 20K)

CREATE TABLE PROGRAMMAZIONI (
  codPalinsesto NUMBER(9) NOT NULL,
  codFilm       CHAR(9) NOT NULL,
  tipo          NUMBER(1) NOT NULL,
  CHECK         (tipo=1 OR tipo=0),
  CONSTRAINT PK_PROGRAMMAZIONI
  PRIMARY KEY(codPalinsesto,codFilm)
)
STORAGE (INITIAL 10k)

CREATE TABLE FILM_IN_PROGRAMMAZIONE (
  id         CHAR(9)    NOT NULL,
  titolo     VARCHAR2(40) NOT NULL,
  recensione CLOB,
  genere     VARCHAR2(30) NOT NULL,
  anno       NUMBER(4)    NOT NULL,
  paese      VARCHAR2(20) NOT NULL,
  durata     NUMBER(3)    NOT NULL,
  d_uscita   DATE,
  distrib    VARCHAR(30)  NOT NULL,
  CONSTRAINT PK_FIP
  PRIMARY KEY(id)
)
LOB(recensione) STORE AS BASICFILE LOB_rec TABLESPACE ts_lob
STORAGE (INITIAL 110000K MINEXTENTS 1 MAXEXTENTS 5 PCTINCREASE 0);

CREATE TABLE ARTISTA (
  nome     VARCHAR2(20) NOT NULL,
  cognome  VARCHAR2(20) NOT NULL,
  eta      NUMBER(2)    NOT NULL,
  attore   VARCHAR(20)  NOT NULL,
  regista  VARCHAR(20)  NOT NULL,
  CONSTRAINT PK_ARTISTA
  PRIMARY KEY(nome,cognome)
)
STORAGE (INITIAL 85K)

CREATE TABLE CASTING (
  codFilm   CHAR(9)  NOT NULL,
  n_Artista VARCHAR2(20) NOT NULL,
  c_Artista VARCHAR2(20) NOT NULL,
  ruolo     NUMBER(1) NOT NULL,
  CHECK     (ruolo=1 OR ruolo=0),
  CONSTRAINT PK_CASTING
  PRIMARY KEY (codFilm,n_Artista,c_Artista)
)
STORAGE (INITIAL 70K)

CREATE TABLE LOCAZIONI (
  codSala       CHAR(1)   NOT NULL,
  codPalinsesto NUMBER(9) NOT NULL,
  CONSTRAINT PK_LOCAZIONI
  PRIMARY KEY (codSala,codPalinsesto)
)
STORAGE (INITIAL 4K)

CREATE TABLE PRENOTAZIONI (
  id            NUMBER(6)    NOT NULL,
  prezzo        NUMBER(3)    NOT NULL,
  tipo          NUMBER(1)    NOT NULL,
  CHECK         (tipo=1 OR tipo=0),
  pagato        NUMBER(1)  NOT NULL,
  CHECK         (pagato=1 OR pagato=0),
  data          DATE         NOT NULL,
  codUser       NUMBER (4)   NOT NULL,
  codPalinsesto NUMBER(9)    NOT NULL,
  CONSTRAINT UN_pren
  UNIQUE     (codUser,codPalinsesto,data),
  CONSTRAINT PK_PREN
  PRIMARY KEY (id)
)
STORAGE (INITIAL 20K)

CREATE TABLE POSTO_SCELTO (
  id        NUMBER(3)  NOT NULL,
  CONSTRAINT PK_PS
  PRIMARY KEY (id)
)
STORAGE (INITIAL 10K)

CREATE TABLE UTENTE (
 id         NUMBER(4)     NOT NULL,
 username   VARCHAR2(20)  NOT NULL UNIQUE,
 CHECK      (LENGTH(username)>4),
 password   VARCHAR2(20)  NOT NULL,
CHECK       (LENGTH(password)>7),
 email      VARCHAR2(20)  NOT NULL,
 nome       VARCHAR2(20)  NOT NULL,
 cognome    VARCHAR2(20)  NOT NULL,
 CONSTRAINT PK_USER
 PRIMARY KEY (id)
)
STORAGE (INITIAL 104000K)

-- Foreign keys
ALTER TABLE TELEFONO
ADD CONSTRAINT FK_TEL_CIN FOREIGN KEY (codCinema)
REFERENCES CINEMA(id)
ON DELETE CASCADE;

ALTER TABLE SALA
ADD CONSTRAINT FK_SALA_CIN FOREIGN KEY (codCinema)
REFERENCES CINEMA(id)
ON DELETE CASCADE;

ALTER TABLE POSTO
ADD CONSTRAINT FK_SEAT_SALA FOREIGN KEY (codSala,codcinema)
REFERENCES SALA(id,codcinema)
ON DELETE CASCADE;

ALTER TABLE PALINSESTO
ADD CONSTRAINT FK_PAL FOREIGN KEY (codCinema)
REFERENCES CINEMA(id)
ON DELETE SET NULL;

ALTER TABLE PALINSESTO
ADD CONSTRAINT FK_PAL1 FOREIGN KEY (codSala)
REFERENCES SALA(id)
ON DELETE SET NULL;

ALTER TABLE PALINSESTO
ADD CONSTRAINT FK_PAL2 FOREIGN KEY (codFilm)
REFERENCES FILM_IN_PROGRAMMAZIONE(id)
ON DELETE SET NULL;

ALTER TABLE PROGRAMMAZIONI
ADD CONSTRAINT FK_PROG FOREIGN KEY (codPalinsesto)
REFERENCES PALINSESTO(id)
ON DELETE SET NULL;

ALTER TABLE PROGRAMMAZIONI
ADD CONSTRAINT FK_PROG1 FOREIGN KEY (codFilm)
REFERENCES FILM_IN_PROGRAMMAZIONE(id)
ON DELETE SET NULL;

ALTER TABLE CASTING
ADD CONSTRAINT FK_CAST FOREIGN KEY (n_Artista,c_Artista)
REFERENCES ARTISTA(nome,cognome)
ON DELETE SET NULL;

ALTER TABLE CASTING
ADD CONSTRAINT FK_CAST1 FOREIGN KEY (codFilm)
REFERENCES  FILM_IN_PROGRAMMAZIONE(id)
ON DELETE SET NULL;

ALTER TABLE LOCAZIONI
ADD CONSTRAINT FK_LOC FOREIGN KEY (codSala)
REFERENCES SALA(id)
ON DELETE SET NULL;

ALTER TABLE LOCAZIONI
ADD CONSTRAINT FK_LOC1 FOREIGN KEY (codPalinsesto)
REFERENCES PALINSESTO(id)
ON DELETE SET NULL;

ALTER TABLE PRENOTAZIONI
ADD CONSTRAINT FK_PREN FOREIGN KEY (codUser)
REFERENCES UTENTE(id)
ON DELETE SET NULL;

ALTER TABLE POSTO_SCELTO
ADD CONSTRAINT FK_PS FOREIGN KEY(id)
REFERENCES POSTO(id)

--Sequenze
CREATE SEQUENCE utenti_auto_incr START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE posti_auto_incr START WITH 1
INCREMENT BY 1;

--Trigger
CREATE OR REPLACE TRIGGER utenti_trigger
BEFORE INSERT ON utente
FOR EACH ROW
BEGIN
:new.id := utenti_auto_incr.nextval;
END;

CREATE OR REPLACE TRIGGER posti_trigger
BEFORE INSERT ON posto
FOR EACH ROW
BEGIN
:new.id := posti_auto_incr.nextval;
END;

--Query
/* Inserimento di un nuova prenotazione da parte di un utente */
INSERT INTO cinemadba.PRENOTAZIONI (PREZZO, TIPO, PAGATO, DATA, CODUSER, CODPALINSESTO) VALUES ( '...','...','...','...','...','...');

/* Trova dati della prenotazione e titolo del film prenotato effettuata dall'utente(nome) */
SELECT Fip.titolo, Pren.prezzo, Pren.tipo, Pren.pagato, Pren.data
FROM ((cinemadba.PRENOTAZIONI Pren JOIN cinemadba.UTENTE Ute ON Pren.CODUSER = Ute.ID) JOIN 
cinemadba.PALINSESTO Pal ON Pal.id = Pren.codpalinsesto) JOIN cinemadba.FILM_IN_PROGRAMMAZIONE Fip ON
Fip.id = Pal.CODFILM
WHERE Ute.Username = 'Sadra'
ORDER BY Pren.data;

/* Seleziona data, sala, cinema, e titolo di un film che verrà proiettato */
SELECT Pal.data_e_ora,Pal.codsala as Sala,Cin.nome as Cinema,Fip.titolo as TitoloFilm
FROM (cinemadba.Palinsesto Pal JOIN cinemadba.Cinema Cin ON Pal.codcinema = Cin.id) JOIN
cinemadba.FILM_IN_PROGRAMMAZIONE Fip ON Pal.codfilm = Fip.id;

/* Mostra quante prenotazioni sono state effettuate per un determinato film */
SELECT COUNT(Pren.id) AS Prenotazioni
FROM (cinemadba.PRENOTAZIONI Pren JOIN cinemadba.PALINSESTO Pal ON Pren.codpalinsesto = Pal.id) JOIN
cinemadba.FILM_IN_PROGRAMMAZIONE Fip ON Pal.CODFILM = Fip.id
WHERE Fip.titolo='...';

/* Mostra gli incassi per un determinato film */
SELECT SUM(Pren.prezzo) AS Incassi
FROM(cinemadba.PRENOTAZIONI Pren JOIN cinemadba.PALINSESTO Pal ON Pren.codpalinsesto = Pal.id) JOIN
cinemadba.FILM_IN_PROGRAMMAZIONE Fip ON Pal.CODFILM = Fip.id
WHERE Fip.titolo='....';


/* Cinema a Zurigo */
SELECT Cin.Nome, Cin.Citta
FROM cinemadba.Cinema Cin
WHERE Cin.Cantone='Zurigo';


/* Seleziona tutti gli utenti che non hanno prenotato alcun film */
SELECT Ute.Nome, Ute.Cognome
FROM cinemadba.UTENTE Ute
WHERE Ute.id NOT IN(
   SELECT Pren.CODUSER
   FROM cinemadba.PRENOTAZIONI Pren
   )
ORDER BY Ute.Cognome;

/* ??? */
SELECT Pal.id,Pal.data_e_ora,Pal.codsala as Sala,  Cin.nome as Cinema,  FIP.titolo, PROG.tipo
FROM ((PALINSESTO Pal JOIN  CINEMA Cin ON Pal.codcinema=Cin.id) JOIN
FILM_IN_PROGRAMMAZIONE FIP ON Pal.codfilm=FIP.id) JOIN
PROGRAMMAZIONI PROG ON FIP.id=PROG.codfilm
ORDER BY PAL.id



