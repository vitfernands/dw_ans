SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['cd_municipio']) }} AS id_municipio,
    cd_municipio,
    nm_municipio,
    nm_regiao,
    sg_uf
FROM {{ ref('stg_municipios') }}