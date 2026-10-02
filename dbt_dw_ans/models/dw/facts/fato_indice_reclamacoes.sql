SELECT
    o.cd_operadora,
    ir.ds_cobertura,
    ir.igr,
    ir.qtd_reclamacoes,
    ir.qtd_beneficiarios,
    ir.ds_porte_operadora,
    ir.ds_competencia,
    ir.ds_competencia_beneficiario
FROM {{ ref('tr_indice_reclamacoes') }} ir
JOIN {{ ref('dim_operadoras') }} o ON ir.cd_operadora = o.cd_operadora