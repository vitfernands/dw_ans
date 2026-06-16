SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['contratacao']) }} AS id_tipo_contratacao,
    contratacao                                             AS ds_tipo_contratacao
FROM {{ ref('stg_caracteristicas_produtos_suplementares') }}
WHERE contratacao IS NOT NULL