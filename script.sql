C:\Program Files\PostgreSQL\15\bin>pg_ctl -D "C:\Program Files\PostgreSQL\15\data" start
esperando o servidor iniciar....2023-04-19 11:25:05.584 -03 [17300] LOG:  redirecting log output to logging collector process
2023-04-19 11:25:05.584 -03 [17300] HINT:  Future log output will appear in directory "log".
.feito
servidor iniciado

C:\Program Files\PostgreSQL\15\bin>psql -U postgres
Password for user postgres:
psql (15.2)
WARNING: Console code page (850) differs from Windows code page (1252)
         8-bit characters might not work correctly. See psql reference
         page "Notes for Windows users" for details.
Type "help" for help.

postgres=# CREATE DATABASE empresa WITH OWNER = postgres ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252' TABLESPACE = pg_default CONNECTION LIMIT = -1 IS_TEMPLATE = False;
CREATE DATABASE
postgres=# CREATE TABLE empregado (SSN  int,pnome varchar(20),minicial varchar(50),unome int,datanasc date,endereco varchar(200),sexo varchar(1),salario real,superssn int,dno int);
CREATE TABLE
postgres=# CREATE TABLE departamento (dnumero  int,dnome varchar(20),gerssn int,gerdatainicio date);
CREATE TABLE
postgres=# CREATE TABLE depto_localizacoes (dlocalizacao  int,dnumero  int);
CREATE TABLE
postgres=# CREATE TABLE projeto (pnumero  int,pjnome varchar(20),dnum int,plocalizacao varchar(200));
CREATE TABLE
postgres=# CREATE TABLE trabalha_em (pno  int,essn int,horas time);
CREATE TABLE
postgres=# CREATE TABLE dependente (essn  int,nome_dependente varchar(20),datanasc date,parentesco varchar(50),sexo varchar(1));
CREATE TABLE
postgres=# create user usuarioA encrypted password '123';
CREATE ROLE
postgres=# create user usuarioB encrypted password '123';
CREATE ROLE
postgres=# create user usuarioC encrypted password '123';
CREATE ROLE
postgres=# create user usuarioD encrypted password '123';
CREATE ROLE
postgres=# create user usuarioE encrypted password '123';
CREATE ROLE
postgres=# SELECT * FROM pg_catalog.pg_user;
 usename  | usesysid | usecreatedb | usesuper | userepl | usebypassrls |  passwd  | valuntil | useconfig
----------+----------+-------------+----------+---------+--------------+----------+----------+-----------
 postgres |       10 | t           | t        | t       | t            | ******** |          |
 usuarioa |    24595 | f           | f        | f       | f            | ******** |          |
 usuariob |    24596 | f           | f        | f       | f            | ******** |          |
 usuarioc |    24597 | f           | f        | f       | f            | ******** |          |
 usuariod |    24598 | f           | f        | f       | f            | ******** |          |
 usuarioe |    24599 | f           | f        | f       | f            | ******** |          |
(6 rows)


postgres=# alter user postgres;
ALTER ROLE
postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON empregado, departamento, depto_localizacoes, projeto, trabalha_em TO usuarioA WITH GRANT OPTION;
GRANT
postgres=# set role usuarioA;
SET

postgres=> insert into empregado(SSN, pnome, minicial, unome, datanasc, endereco, sexo, salario, superssn,dno) values (1, 'cristia', 'teste', 1, '2000-03-12', 'apucarana', 'm', 0, 1, 6);
INSERT 0 1
postgres=> insert into empregado(SSN, pnome, minicial, unome, datanasc, endereco, sexo, salario, superssn,dno) values (2, 'felps', 'teste', 1, '1997-09-23', 'jundiai', 'm', 200, 2, 12);
INSERT 0 1
postgres=> insert into empregado(SSN, pnome, minicial, unome, datanasc, endereco, sexo, salario, superssn,dno) values (3, 'jp', 'pessoal', 1, '2000-06-14', 'botucatu', 'm', 1000000, 3, 14);
INSERT 0 1
postgres=> GRANT SELECT (ssn, pnome, minicial, unome, datanasc, endereco, sexo, superssn, dno) ON empregado TO usuarioB;
GRANT
postgres=> GRANT SELECT (dnumero, dnome) ON departamento TO usuarioB;
GRANT
postgres=> set role usuarioB;
SET
postgres=> select ssn from empregado;
 ssn
-----
   1
   2
   3
(3 rows)
postgres=> select salario from empregado;
ERROR:  permission denied for table empregado
postgres=> set role postgres;
SET
postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON trabalha_em TO usuarioC WITH GRANT OPTION;
GRANT
postgres=# GRANT SELECT (PNOME, MINICIAL, UNOME, SSN) ON empregado  TO usuarioC WITH GRANT OPTION;
GRANT
postgres=# GRANT SELECT (PJNOME, PNUMERO) ON projeto TO usuarioC WITH GRANT OPTION;
GRANT
postgres=# set role usuarioC;
SET
postgres=> select PNOME, MINICIAL, UNOME, SSN from empregado;
  pnome  | minicial | unome | ssn
---------+----------+-------+-----
 cristia | teste    |     1 |   1
 felps   | teste    |     1 |   2
 jp      | pessoal  |     1 |   3
(3 rows)


postgres=> select * from trabalha_em;
 pno | essn | horas
-----+------+-------
(0 rows)


postgres=> select PJNOME, PNUMERO from projeto;
 pjnome | pnumero
--------+---------
(0 rows)


postgres=> set role postgres;
SET
postgres=# GRANT SELECT ON empregado TO usuarioD;
GRANT
postgres=# GRANT SELECT, INSERT, UPDATE, DELETE ON dependente TO usuarioD;
GRANT
postgres=# set role usuarioD;
SET
postgres=> select * from empregado;
 ssn |  pnome  | minicial | unome |  datanasc  | endereco  | sexo | salario | superssn | dno
-----+---------+----------+-------+------------+-----------+------+---------+----------+-----
   1 | cristia | teste    |     1 | 2000-03-12 | apucarana | m    |       0 |        1 |   6
   2 | felps   | teste    |     1 | 1997-09-23 | jundiai   | m    |     200 |        2 |  12
   3 | jp      | pessoal  |     1 | 2000-06-14 | botucatu  | m    |   1e+06 |        3 |  14
(3 rows)


postgres=> select * from dependente;
 essn | nome_dependente | datanasc | parentesco | sexo
------+-----------------+----------+------------+------
(0 rows)

postgres=> insert into dependente (essn, nome_dependente, datanasc, parentesco, sexo) values (25, 'bruno', '2010-11-15', 'filho', 'm');
INSERT 0 1
postgres=> set role postgres;
SET
postgres=# CREATE VIEW empregado_dno_3 AS SELECT * FROM empregado WHERE DNO = 3;
CREATE VIEW
postgres=# GRANT SELECT ON empregado_dno_3 TO usuarioE;
GRANT
postgres=# set role usuarioE;
SET
postgres=> select * from empregado_dno_3;
 ssn | pnome | minicial | unome | datanasc | endereco | sexo | salario | superssn | dno
-----+-------+----------+-------+----------+----------+------+---------+----------+-----
(0 rows)
