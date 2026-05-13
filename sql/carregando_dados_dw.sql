--Instalando as dependencias na VM

sudo dnf install postgresql16-contrib


--Linkar o banco de dados STAGING com o DW

CREATE EXTENSION postgres_fdw;

CREATE SERVER stage_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (
    host 'localhost',
    dbname 'operadoras_saude',
    port '5432'
);

CREATE USER MAPPING FOR vitorp
SERVER stage_server
OPTIONS (
    user 'vitorp',
    password 'equi81'
);

IMPORT FOREIGN SCHEMA public
LIMIT TO (operadoras_ativas)
FROM SERVER stage_server INTO public;