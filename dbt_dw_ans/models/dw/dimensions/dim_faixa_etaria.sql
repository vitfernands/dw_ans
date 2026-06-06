SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['faixa_etaria']) }} AS id_faixa_etaria,
    faixa_etaria
FROM {{ ref('stg_mensalidade_por_faixa_etaria') }}