WITH areas_comercializacao AS (

SELECT *

FROM (

    SELECT 
        stg.*,
        m.sg_uf,
        ROW_NUMBER() OVER(
            PARTITION BY stg.cd_operadora
            ORDER BY stg.cd_municipio
        ) rn

    FROM stg_areas_comercializacao_planos stg

    JOIN dim_municipios m
    ON m.cd_municipio = stg.cd_municipio

    WHERE m.sg_uf = 'SC'

)

WHERE rn <= 10

),

mensalidade AS (
    SELECT m.*
    FROM {{ ref('stg_mensalidade_por_faixa_etaria') }} m
    WHERE m.dt_ntrp >= '2024-01-01'
    AND m.id_plano IN (
        SELECT cd_plano
        FROM dim_plano
        LIMIT 2000
    )
),

caracteristicas AS (
    SELECT 
        stg.*
    FROM stg_caracteristicas_produtos_suplementares stg
    JOIN dim_plano p ON stg.id_plano = p.cd_plano 
)


SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key (['p.id_plano', 'o.id_operadora', 'm.id_municipio', 't.id_tempo', 'fe.faixa_etaria', 'dac.id_acomodacao', 'sa.id_sgmt', 'uf.id_uf', 'df.id_financiamento', 'me.cd_nota']) }} AS sk_fato,
    p.id_plano,
    o.id_operadora,
    m.id_municipio,
    t.id_tempo,
    fe.faixa_etaria,
    --tc.id_tipo_contratacao,
    dac.id_acomodacao,
    sa.id_sgmt,
    uf.id_uf,
    df.id_financiamento,
    me.cd_nota,
    me.vl_comercial_mensalidade,
    me.vcm_minimo,
    me.vcm_maximo,
    me.vl_desp_assistencial
FROM dim_plano p 
JOIN dim_operadoras o ON o.id_operadora = p.id_operadora
JOIN areas_comercializacao ac ON ac.cd_operadora = o.registro_ans
JOIN dim_municipios m ON m.cd_municipio = ac.cd_municipio
JOIN mensalidade me ON me.id_plano = p.cd_plano
JOIN dim_faixa_etaria fe ON fe.faixa_etaria = me.faixa_etaria
--JOIN dim_tipo_contratacao tc ON tc.id_tipo_contratacao = o.id_contratacao
JOIN caracteristicas c ON c.id_plano = p.cd_plano
JOIN dim_acomodacao dac ON dac.acomodacao = c.acomodacao_hospitalar 
JOIN dim_sgmt_assistencial sa ON sa.ds_sgmt = c.sgmt_assistencial
JOIN dim_uf uf ON uf.sg_uf = m.sg_uf
JOIN dim_financiamento df ON df.ds_tipo_financiamento = c.tipo_financiamento
JOIN dim_tempo t ON t.data_completa = me.dt_ntrp
