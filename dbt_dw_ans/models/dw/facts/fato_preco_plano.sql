WITH mensalidade AS (
    SELECT * FROM {{ ref('stg_mensalidade_por_faixa_etaria') }}
),

valor_municipio AS (
    SELECT * FROM {{ ref('stg_valor_comercial_municipio') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['m.id_plano', 'm.faixa_etaria', 'm.dt_ntrp']) }} AS sk_fato,
    p.id_plano,
    fe.id_faixa_etaria,
    t.id_tempo,
    op.id_operadora,
    m.vl_comercial_mensalidade,
    m.vl_desp_assistencial,
    m.vcm_minimo,
    m.vcm_maximo
FROM mensalidade m
LEFT JOIN {{ ref('dim_plano') }}        p  ON m.id_plano::VARCHAR    = p.cd_plano
LEFT JOIN {{ ref('dim_faixa_etaria') }} fe ON m.faixa_etaria         = fe.faixa_etaria
LEFT JOIN {{ ref('dim_tempo') }}        t  ON m.dt_ntrp              = t.data
LEFT JOIN {{ ref('dim_operadoras') }}   op ON m.cd_operadora::VARCHAR = op.registro_ans::VARCHAR