{{ config(
    indexes=[
        {'columns': ['cd_operadora']},
        {'columns': ['id_plano']},
        {'columns': ['faixa_etaria']},
        {'columns': ['cd_nota']},
        {'columns': ['dt_ntrp']}
    ]
) }}

SELECT
    TRIM(cd_operadora)::INT                        AS cd_operadora,
    TRIM(id_plano)::INT                            AS id_plano,
    TRIM(cd_nota)::INT                             AS cd_nota,
    TO_DATE(dt_ntrp, 'DD/MM/YYYY')                 AS dt_ntrp,
    TRIM(id_abrg)::VARCHAR(100)                    AS id_abrg,
    TRIM(faixa_etaria)::VARCHAR(100)               AS faixa_etaria,
    TRIM(vl_comercial_mensalidade)::DECIMAL(10, 2) AS vl_comercial_mensalidade,
    TRIM(vl_desp_assistencial)::DECIMAL(10, 2)     AS vl_desp_assistencial,
    TRIM(vcm_minimo)::DECIMAL(10, 2)               AS vcm_minimo,
    TRIM(vcm_maximo)::DECIMAL(10, 2)               AS vcm_maximo,
    TO_DATE(dt_atualizacao, 'DD/MM/YYYY')          AS dt_atualizacao
FROM {{source('stage', 'mensalidade_por_faixa_etaria')}}