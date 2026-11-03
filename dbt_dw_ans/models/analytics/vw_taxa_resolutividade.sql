SELECT
	o.cd_operadora,
	o.nm_operadora,
	o.ds_modalidade,
	o.ds_cidade 				AS cidade_operadora,
	o.uf 						AS uf_sede_operadora,
	o.fl_sede_sc,
	o.fl_operadora_ativa,
	o.ds_regiao_comercializacao AS regiao_comercializacao_operadora,
	o.dt_registro_ans 			AS dt_registro_ans_operadora,
	fato.tp_natureza,
	fato.vl_tr,
	fato.nr_numerador,
	fato.nr_denominador,
	fato.dt_competencia,
	fato.dt_atualizacao
FROM {{ ref('fato_taxa_resolutividade') }} fato
JOIN {{ ref('dim_operadoras') }} o ON o.cd_operadora = fato.cd_operadora
