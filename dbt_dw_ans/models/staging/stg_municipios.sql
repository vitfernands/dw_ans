SELECT
    id_detalhe_area_geografica::VARCHAR(255) AS id_area_geografica,
    TRIM(sg_uf)::VARCHAR(2)                  AS sg_uf,
    TRIM(cd_municipio)::INT                  AS cd_municipio,
    nm_municipio::VARCHAR(255)               AS nm_municipio,
    nm_regiao::VARCHAR(255)                  AS nm_regiao

FROM {{source('stage', 'municipios')}}