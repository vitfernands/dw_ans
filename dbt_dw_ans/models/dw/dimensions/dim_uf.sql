SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['sg_uf']) }} AS id_uf,
    sg_uf
FROM {{ ref('stg_municipios') }}