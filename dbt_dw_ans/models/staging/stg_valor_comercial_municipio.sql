SELECT
    TRIM(cd_municipio)::INT                      AS cd_municipio,
    TRIM(id_plano)::INT                          AS id_plano,
    TRIM(cd_faixa_etaria)::INT                   AS cd_faixa_etaria,
    TRIM(REPLACE(vcm, ',', '.'))::DECIMAL(10, 2) AS vlr_comercial
 
FROM {{source('stage', 'valor_comercial_municipio')}}