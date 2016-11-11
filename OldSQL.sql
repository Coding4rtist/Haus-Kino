***** _SYSTEM_ *****
CREATE TABLESPACE ts_cinema DATAFILE '[PATH]\cinemadbos.dbf' SIZE 150M;
CREATE TABLESPACE ts_lob DATAFILE '[PATH]\reviewlob.dbf' SIZE 300M;

CREATE USER cinemadba DEFAULT TABLESPACE ts_cinema IDENTIFIED BY 12345;
GRANT DBA, UNLIMITED TABLESPACE TO cinemadba;


***** _CINEMADBA_ *****

CREATE ROLE utente;
GRANT CONNECT TO utente;

CREATE TABLE CINEMA (
      id NUMBER(3) NOT NULL,
      via VARCHAR2(30) NOT NULL,
      cap NUMBER(4) NOT NULL,
      cantone  VARCHAR2(30) NOT NULL,
      citta VARCHAR2(30) NOT NULL,
      n_sale NUMBER(2) NOT NULL,	  	
      CONSTRAINT PK_CINEMA PRIMARY KEY(ID)
)
STORAGE (INITIAL 7500K)
   


CREATE TABLE SALA (
      id CHAR(1) NOT NULL,
      cod_cinema CHAR(2) NOT NULL,
      superficie NUMBER(3) NOT NULL,
      capienza NUMBER (3) NOT NULL
      CHECK (capienza > '0' AND capienza < '1000'),
      CONSTRAINT PK_SALA PRIMARY KEY(id,cod_cinema)
)      

CREATE TABLE POSTO (
      id NUMBER(3) NOT NULL,
      num_colonna NUMBER(2) NOT NULL,
      num_riga CHAR(1) NOT NULL,
      cod_sala CHAR(1) NOT NULL,
      disponibile NUMBER(1,0) NOT NULL,
      CONSTRAINT PK_POSTO PRIMARY KEY(id)
)

CREATE TABLE FILM_IN_PROGRAMMAZIONE (
      titolo VARCHAR2(30)  NOT NULL,
      recensione CLOB  NOT NULL,
      regia VARCHAR2(20) NOT NULL,
      anno NUMBER(4) NOT NULL,
      paese VARCHAR2(20) NOT NULL,
      durata NUMBER(3) NOT NULL,
      data_uscita DATE NOT NULL,
      tre_D NUMBER(1,0) NOT NULL,
      giorno DATE NOT NULL,
      orario DATE NOT NULL,
      id NUMBER(5) NOT NULL,
      CONSTRAINT PK_FIP PRIMARY KEY(id)
)
STORAGE(INITIAL 15000000K)
