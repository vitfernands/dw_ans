{{ config(
    indexes=[
        {'columns': id_plano},
        {'columns': id_operadora},
        {'columns': dt_ntrp},
        {'columns': id_municipio}
    ]
) }}

SELECT
    areas.id_plano,
    areas.cd_operadora AS id_operadora,
    areas.dt_ntrp,
    areas.cd_municipio AS id_municipio
FROM {{ ref('tr_areas_comercializacao_planos') }} areas
WHERE cd_nota = (
    SELECT MAX(cd_nota)
    FROM {{ ref('tr_areas_comercializacao_planos') }} areas2
    WHERE areas.id_plano = areas2.id_plano
    AND areas.cd_nota = areas2.cd_nota
    AND areas.dt_ntrp = areas2.dt_ntrp
)