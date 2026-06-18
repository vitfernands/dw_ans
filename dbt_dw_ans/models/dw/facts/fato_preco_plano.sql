/*
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
*/

{{ config(materialized='table') }}

WITH mensalidade AS (
    SELECT * FROM {{ ref('stg_mensalidade_por_faixa_etaria') }}
    WHERE dt_ntrp >= '2024-01-01'
    LIMIT 50000
),

valor_municipio AS (
    SELECT * FROM {{ ref('stg_valor_comercial_municipio') }}
    LIMIT 50000
), 

-- Precisamos dessa staging para descobrir a UF de cada cd_municipio da valor_municipio
municipios_geo AS (
    SELECT DISTINCT cd_municipio, sg_uf 
    FROM {{ ref('stg_municipios') }}
),

caracteristicas AS (
    SELECT DISTINCT
        id_plano,
        acomodacao_hospitalar,
        contratacao,
        sgmt_assistencial,
        tipo_financiamento
    FROM {{ ref('stg_caracteristicas_produtos_suplementares') }}
),

mapeamento_faixa AS (
    SELECT * FROM {{ ref('stg_mapeamento_faixa_etaria') }}
)

SELECT
    -- 1. CHAVE PRIMÁRIA DA FATO
    {{ dbt_utils.generate_surrogate_key(['m.id_plano', 'm.faixa_etaria', 'm.dt_ntrp', 'vm.cd_municipio']) }} AS sk_fato,
    
    -- 2. CHAVES ESTRANGEIRAS (FKs) - LIGAÇÃO COM AS DIMENSÕES PRINCIPAIS
    {{ dbt_utils.generate_surrogate_key(['m.id_plano']) }} AS id_plano,
    {{ dbt_utils.generate_surrogate_key(['m.faixa_etaria']) }} AS id_faixa_etaria,
    {{ dbt_utils.generate_surrogate_key(['m.dt_ntrp']) }} AS id_tempo,
    {{ dbt_utils.generate_surrogate_key(['m.cd_operadora::varchar']) }} AS id_operadora,
    
    -- 3. CHAVES ESTRANGEIRAS DAS CARACTERÍSTICAS (Padrão Snowflake do Professor)
    {{ dbt_utils.generate_surrogate_key(['c.acomodacao_hospitalar']) }} AS id_acomodacao,
    {{ dbt_utils.generate_surrogate_key(['c.contratacao']) }} AS id_tipo_contratacao,
    {{ dbt_utils.generate_surrogate_key(['c.sgmt_assistencial']) }} AS id_sgmt,
    {{ dbt_utils.generate_surrogate_key(['c.tipo_financiamento']) }} AS id_financiamento,
    
    -- 4. CHAVES ESTRANGEIRAS GEOGRÁFICAS (Batendo com dim_municipios e dim_uf)
    {{ dbt_utils.generate_surrogate_key(['vm.cd_municipio']) }} AS id_municipio,
    {{ dbt_utils.generate_surrogate_key(['geo.sg_uf']) }} AS id_uf, -- Agora pegando da ponte geo
    
    -- 5. MÉTRICAS (Fatos numéricos)
    m.vl_comercial_mensalidade,
    m.vl_desp_assistencial,
    m.vcm_minimo,
    m.vcm_maximo,
    vm.vlr_comercial AS vl_comercial_municipio -- Métrica extra trazida da tabela de municípios

FROM mensalidade m

-- Join para mapear o texto da faixa etária para o código numérico
LEFT JOIN mapeamento_faixa                mf ON m.faixa_etaria = mf.faixa_etaria

-- Cruzamento com a tabela de preços por município (Garante correspondência de Plano + Faixa Etária)
LEFT JOIN valor_municipio                 vm ON m.id_plano     = vm.id_plano 
                                            AND mf.cd_faixa_etaria::int = vm.cd_faixa_etaria

-- Buscando a UF do município para podermos gerar a Surrogate Key da dim_uf
INNER JOIN municipios_geo                  geo ON vm.cd_municipio = geo.cd_municipio

-- Ponte para coletar os atributos textuais e gerar os hashes das sub-dimensões do plano
LEFT JOIN caracteristicas                 c  ON m.id_plano     = c.id_plano