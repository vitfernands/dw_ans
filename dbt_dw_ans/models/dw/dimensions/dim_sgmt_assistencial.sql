SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['sgmt_assistencial']) }} AS id_sgmt,
    sgmt_assistencial                                             AS ds_sgmt
FROM {{ tr('stg_caracteristicas_produtos_suplementares') }}
WHERE sgmt_assistencial IS NOT NULL