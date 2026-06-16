WITH mensalidade AS (
    SELECT * FROM {{ ref('stg_mensalidade_por_faixa_etaria') }}
    WHERE dt_ntrp >= '2024-01-01'
),

valor_municipio AS (
    SELECT * FROM {{ ref('stg_valor_comercial_municipio') }}
), 

caracteristicas AS (
    SELECT DISTINCT
        id_plano,
        acomodacao_hospitalar,
        contratacao,
        sgmt_assistencial,
        tipo_financiamento
    FROM {{ ref('stg_caracteristicas_produtos_suplementares') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['m.id_plano', 'm.faixa_etaria', 'm.dt_ntrp', 'vm.cd_municipio']) }} AS sk_fato,
    p.id_plano,
    fe.id_faixa_etaria,
    t.id_tempo,
    op.id_operadora,
    ac.id_acomodacao,
    tc.id_tipo_contratacao,
    sa.id_sgmt,
    fi.id_financiamento,
    uf.id_uf,
    mu.id_municipio,
    m.vl_comercial_mensalidade,
    m.vl_desp_assistencial,
    m.vcm_minimo,
    m.vcm_maximo
FROM mensalidade m
LEFT JOIN valor_municipio                    vm ON m.id_plano               = vm.id_plano
LEFT JOIN {{ ref('dim_plano') }}             p  ON m.id_plano               = p.cd_plano
LEFT JOIN {{ ref('dim_faixa_etaria') }}      fe ON m.faixa_etaria           = fe.faixa_etaria
LEFT JOIN {{ ref('dim_tempo') }}             t  ON m.dt_ntrp                = t.data
LEFT JOIN {{ ref('dim_operadoras') }}        op ON m.cd_operadora           = op.registro_ans
LEFT JOIN caracteristicas                    c  ON m.id_plano               = c.id_plano
LEFT JOIN {{ ref('dim_acomodacao') }}        ac ON ac.acomodacao            = c.acomodacao_hospitalar
LEFT JOIN {{ ref('dim_tipo_contratacao') }}  tc ON tc.ds_tipo_contratacao   = c.contratacao
LEFT JOIN {{ ref('dim_sgmt_assistencial') }} sa ON sa.ds_sgmt               = c.sgmt_assistencial
LEFT JOIN {{ ref('dim_financiamento') }}     fi ON fi.ds_tipo_financiamento = c.tipo_financiamento
LEFT JOIN {{ ref('dim_municipios') }}        mu ON vm.cd_municipio          = mu.cd_municipio
LEFT JOIN {{ ref('dim_uf') }}                uf ON uf.sg_uf                 = mu.sg_uf 