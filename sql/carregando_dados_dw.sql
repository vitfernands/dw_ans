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

--Importando as tabelas

IMPORT FOREIGN SCHEMA public
LIMIT TO (operadoras_ativas)
FROM SERVER stage_server INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (indice_reclamacoes)
FROM SERVER stage_server INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (mensalidade_por_faixa_etaria)
FROM SERVER stage_server INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (areas_comercializacao_planos)
FROM SERVER stage_server INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (municipios)
FROM SERVER stage_server INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (caracteristicas_produtos_suplementares)
FROM SERVER stage_server INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (taxa_resolutividade)
FROM SERVER stage_server INTO public;

IMPORT FOREIGN SCHEMA public
LIMIT TO (valor_comercial_municipio)
FROM SERVER stage_server INTO public;


