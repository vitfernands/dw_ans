{{ config(
    indexes=[
        {'columns': ['id_plano']},
        {'columns': ['cd_operadora']},
        {'columns': ['dt_ntrp']},
        {'columns': ['id_municipio']}
    ]
) }}

SELECT
    areas.id_plano,
    areas.cd_operadora AS cd_operadora,
    areas.dt_ntrp,
    areas.cd_municipio AS id_municipio
FROM {{ ref('tr_areas_comercializacao_planos') }} areas
