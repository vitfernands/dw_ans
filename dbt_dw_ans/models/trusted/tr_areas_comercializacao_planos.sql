{{ config(
    indexes=[
        {'columns': ['id_plano']},
        {'columns': ['cd_operadora']},
        {'columns': ['cd_nota']},
        {'columns': ['dt_ntrp']}
    ]
) }}

WITH dados AS (

    SELECT
        TRIM(acp.id_plano)::VARCHAR(20)       AS id_plano,
        TRIM(acp.cd_plano)::INTEGER           AS cd_plano,
        TRIM(acp.cd_operadora)::INTEGER       AS cd_operadora,
        TRIM(acp.cd_nota)::INTEGER            AS cd_nota,
        TRIM(acp.dt_ntrp)::DATE               AS dt_ntrp,
        TRIM(acp.cd_municipio)::INTEGER       AS cd_municipio,
        acp.nm_municipio::VARCHAR(255)        AS nm_municipio,
        TRIM(acp.sg_uf)::VARCHAR(2)           AS sg_uf,
        acp.nm_regiao::VARCHAR(255)           AS nm_regiao,
        TRIM(acp.dt_atualizacao)::TIMESTAMP   AS dt_atualizacao,

        ROW_NUMBER() OVER (
            PARTITION BY 
                acp.id_plano,
                acp.dt_ntrp::DATE
            ORDER BY 
                acp.cd_nota DESC
        ) AS rn

    FROM {{ source('stage', 'areas_comercializacao_planos') }} acp

    WHERE acp.sg_uf = 'SC'
)

SELECT
    id_plano,
    cd_plano,
    cd_operadora,
    cd_nota,
    dt_ntrp,
    cd_municipio,
    nm_municipio,
    sg_uf,
    nm_regiao,
    dt_atualizacao

FROM dados

WHERE rn = 1