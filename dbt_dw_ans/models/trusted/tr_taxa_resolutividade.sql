-- Colunas do CSV (pda-048): CD_REGISTRO_ANS; NM_RAZAO_SOCIAL; TP_NATUREZA; VL_TR;
-- NR_NUMERADOR; NR_DENOMINADOR; CD_COMPETENCIA ('YYYY-MM'); DT_ATUALIZACAO ('YYYY-MM-DD')
-- TP_NATUREZA possui 'Assistencial', 'Não Assistencial' e 'Geral' (consolidado das duas):
-- filtre por natureza nos painéis para não contar a mesma demanda duas vezes.

SELECT
    TRIM(tr.registro_ans)::INT                        AS cd_operadora,
    TRIM(tr.razao_social)::VARCHAR(255)               AS ds_razao_social,
    TRIM(tr.tp_natureza)::VARCHAR(30)                 AS tp_natureza,
    TRIM(REPLACE(tr.vl_tr, ',', '.'))::DECIMAL(10, 2) AS vl_tr,
    TRIM(tr.nr_numerador)::INT                        AS nr_numerador,
    TRIM(tr.nr_denominador)::INT                      AS nr_denominador,
    TO_DATE(TRIM(tr.cd_competencia), 'YYYY-MM')       AS dt_competencia,
    TRIM(tr.dt_atualizacao)::DATE                     AS dt_atualizacao

FROM {{source('stage', 'taxa_resolutividade')}} tr

-- Mercado de SC: operadoras que comercializam planos em municípios de SC
WHERE EXISTS (
    SELECT 1
    FROM {{ ref('tr_areas_comercializacao_planos') }} acp
    WHERE acp.cd_operadora = tr.registro_ans::INT
)
