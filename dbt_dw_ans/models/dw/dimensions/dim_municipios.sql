SELECT DISTINCT
    cd_municipio,
    nm_municipio,
    nm_regiao,
    sg_uf,
    id_area_geografica
FROM {{ ref('tr_municipios') }}
