SELECT
    TRIM(id_plano)::VARCHAR(20)     AS id_plano,
    TRIM(cd_plano)::INTEGER         AS cd_plano,
    TRIM(cd_operadora)::INT         AS cd_operadora,
    TRIM(cd_nota)::INT              AS cd_nota,
    TRIM(dt_ntrp)::TIMESTAMP        AS dt_ntrp,
    TRIM(cd_municipio)::INT         AS cd_municipio,
    nm_municipio::VARCHAR(255)      AS nm_municipio,
    TRIM(sg_uf)::VARCHAR(2)         AS sg_uf,
    nm_regiao::VARCHAR(255)         AS nm_regiao,
    TRIM(dt_atualizacao)::TIMESTAMP AS dt_atualizacao

FROM {{source('stage', 'areas_comercializacao_planos') }}
