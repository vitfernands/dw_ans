SELECT
    TRIM(registro_ans)::INT           as registro_ans,
    TRIM(cnpj)::VARCHAR(14)           as cnpj,
    razao_social::VARCHAR(255)        as razao_social,
    nome_fantasia::VARCHAR(255)       as nome_fantasia,
    modalidade::VARCHAR(255)          as modalidade,
    logradouro::VARCHAR(255)          as logradouro,
    numero::VARCHAR(255)              as numero,
    complemento::VARCHAR(255)         as complemento,
    bairro::VARCHAR(255)              as bairro,
    cidade::VARCHAR(255)              as cidade,
    TRIM(uf)::VARCHAR(2)              as uf,
    TRIM(REPLACE(cep, '-', ''))::VARCHAR(8) as cep,
    TRIM(ddd)::VARCHAR(2)             as ddd,
    TRIM(telefone)::varchar(20)       as telefone,
    representante::VARCHAR(255)       as representante,
    cargo_repr::VARCHAR(100)          as cargo_repr,
    TRIM(regiao_comercializacao)::INT as regiao_comercializacao,
    dt_registro_ans::DATE             as dt_registro_ans

FROM {{ source('stage', 'operadoras_ativas') }}