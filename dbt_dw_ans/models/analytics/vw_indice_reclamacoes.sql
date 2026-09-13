SELECT
	o.cd_operadora,
	o.nm_operadora,
	o.ds_modalidade,
	o.ds_cidade 				AS cidade_operadora,
	o.ds_regiao_comercializacao AS regiao_comercializacao_operadora,
	o.dt_registro_ans 			AS dt_registro_ans_operadora,
	fato.ds_cobertura,
	fato.igr,
	fato.qtd_reclamacoes,
	fato.qtd_beneficiarios,
	fato.ds_porte_operadora,
	fato.ds_competencia,
	fato.ds_competencia_beneficiario
FROM {{ ref('fato_indice_reclamacoes') }} fato
JOIN {{ ref('dim_operadoras') }} o ON o.cd_operadora = fato.cd_operadora