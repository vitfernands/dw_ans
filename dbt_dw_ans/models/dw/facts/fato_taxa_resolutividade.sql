SELECT
    o.cd_operadora,
    tr.tp_natureza,
    tr.vl_tr,
    tr.nr_numerador,
    tr.cd_competencia,
    tr.dt_atualizacao,
    tr.dt_registro
FROM {{ ref('tr_taxa_resolutividade') }} tr
JOIN {{ ref('dim_operadoras') }} o ON o.cd_operadora = tr.cd_operadora