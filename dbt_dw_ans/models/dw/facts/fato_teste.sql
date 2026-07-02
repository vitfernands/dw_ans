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
        JOIN dim_municipios m ON m.cd_municipio = stg.cd_municipio
        WHERE m.sg_uf = 'SC'
    )
    WHERE rn <= 10
),

mensalidade AS (
    SELECT *
    FROM {{ ref('stg_mensalidade_por_faixa_etaria') }}
    WHERE dt_ntrp >= '2024-01-01'
    AND id_plano IN (
        SELECT cd_plano
        FROM dim_plano
        LIMIT 100
    )
),

caracteristicas AS (
    SELECT stg.*
    FROM stg_caracteristicas_produtos_suplementares stg
    JOIN dim_plano p ON stg.id_plano = p.cd_plano 
),

-- NOVA CTE: Vamos isolar a relação exata de Plano + Operadora + Contratação primeiro
plano_operadora_contratacao AS (
    SELECT 
        p.id_plano,
        p.cd_plano,
        o.id_operadora,
        o.registro_ans,
        tc.id_tipo_contratacao
    FROM dim_plano p
    JOIN dim_operadoras o ON o.id_operadora = p.id_operadora
    JOIN dim_tipo_contratacao tc ON tc.id_tipo_contratacao = o.id_contratacao
)

-- QUERY FINAL: Agora sim, buscamos da nossa base controlada
SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key ([
        'poc.id_plano', 
        'poc.id_operadora', 
        'm.id_municipio', 
        'ac.dt_ntrp', 
        'fe.faixa_etaria', 
        'poc.id_tipo_contratacao', 
        'dac.id_acomodacao', 
        'sa.id_sgmt', 
        'uf.id_uf', 
        'df.id_financiamento'
    ]) }} AS sk_fato,
    
    poc.id_plano,
    poc.id_operadora,
    m.id_municipio,
    ac.dt_ntrp,
    fe.faixa_etaria,
    poc.id_tipo_contratacao,
    dac.id_acomodacao,
    sa.id_sgmt,
    uf.id_uf,
    df.id_financiamento,
    
    me.vl_comercial_mensalidade,
    me.vcm_minimo,
    me.vcm_maximo,
    me.vl_desp_assistencial

FROM plano_operadora_contratacao poc
JOIN areas_comercializacao ac ON ac.cd_operadora = poc.registro_ans
JOIN dim_municipios m        ON m.cd_municipio = ac.cd_municipio
JOIN mensalidade me          ON me.id_plano = poc.cd_plano
JOIN dim_faixa_etaria fe     ON fe.faixa_etaria = me.faixa_etaria
JOIN caracteristicas c       ON c.id_plano = poc.cd_plano
JOIN dim_acomodacao dac      ON dac.acomodacao = c.acomodacao_hospitalar 
JOIN dim_sgmt_assistencial sa ON sa.ds_sgmt = c.sgmt_assistencial
JOIN dim_uf uf               ON uf.sg_uf = m.sg_uf
JOIN dim_financiamento df    ON df.ds_tipo_financiamento = c.tipo_financiamento