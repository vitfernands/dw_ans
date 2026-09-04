{{ config(
    indexes=[
        {'columns': ['cd_operadora']},
        {'columns': ['id_plano']},
        {'columns': ['faixa_etaria']},
        {'columns': ['cd_nota']},
        {'columns': ['dt_ntrp']}
    ]
) }}

WITH dados AS (
    SELECT
        TRIM(mfe.cd_operadora)::INT                        AS cd_operadora,
        TRIM(mfe.id_plano)::INT                            AS id_plano,
        TRIM(mfe.cd_nota)::INT                             AS cd_nota,
        TRIM(mfe.dt_ntrp)::DATE                            AS dt_ntrp,
        TRIM(mfe.id_abrg)::VARCHAR(100)                    AS id_abrg,
        TRIM(mfe.faixa_etaria)::VARCHAR(100)               AS faixa_etaria,
        TRIM(mfe.vl_comercial_mensalidade)::DECIMAL(10, 2) AS vl_comercial_mensalidade,
        TRIM(mfe.vl_desp_assistencial)::DECIMAL(10, 2)     AS vl_desp_assistencial,
        TRIM(mfe.vcm_minimo)::DECIMAL(10, 2)               AS vcm_minimo,
        TRIM(mfe.vcm_maximo)::DECIMAL(10, 2)               AS vcm_maximo,
        TRIM(mfe.dt_atualizacao)::DATE                     AS dt_atualizacao,

        ROW_NUMBER() OVER (
            PARTITION BY 
                mfe.id_plano,
                mfe.dt_ntrp,
                mfe.faixa_etaria
            ORDER BY
                mfe.cd_nota DESC
        ) AS rn

    FROM {{ source('stage', 'mensalidade_por_faixa_etaria') }} mfe
    WHERE EXISTS (
        SELECT 1 
        FROM {{ ref('tr_areas_comercializacao_planos') }} acp 
        WHERE acp.id_plano = mfe.id_plano
    )
)

SELECT
    cd_operadora,
    id_plano,
    cd_nota,
    dt_ntrp,
    id_abrg,
    faixa_etaria,
    vl_comercial_mensalidade,
    vl_desp_assistencial,
    vcm_minimo,
    vcm_maximo,
    dt_atualizacao
FROM dados
WHERE rn = 1