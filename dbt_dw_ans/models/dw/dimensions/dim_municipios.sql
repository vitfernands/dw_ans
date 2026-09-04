{{ config(
    unique_key=['cd_municipio'],
    indexes=[
        {'columns': ['cd_municipio'], 'unique': True}
    ]
) }}

SELECT DISTINCT
    cd_municipio,
    nm_municipio,
    nm_regiao,
    sg_uf
FROM {{ ref('tr_areas_comercializacao_planos') }}

