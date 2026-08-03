{{ config(
    unique_key=['id_municipio'],
    indexes=[
        {'columns': id_municipio, 'unique': True}
    ]
) }}

SELECT DISTINCT
    cd_municipio AS id_municipio,
    nm_municipio,
    nm_regiao,
    sg_uf,
    id_area_geografica
FROM {{ ref('tr_municipios') }}
