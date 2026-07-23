SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['tipo_financiamento']) }} AS id_financiamento,
    tipo_financiamento                                             AS ds_tipo_financiamento
FROM {{ ref('tr_caracteristicas_produtos_suplementares') }}
WHERE tipo_financiamento IS NOT NULL