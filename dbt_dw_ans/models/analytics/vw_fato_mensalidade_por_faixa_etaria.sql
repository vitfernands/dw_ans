SELECT
	o.cd_operadora,
	o.nm_operadora,
	o.ds_modalidade,
	o.ds_cidade 				AS cidade_operadora,
	o.ds_regiao_comercializacao AS regiao_comercializacao_operadora,
	o.dt_registro_ans 			AS dt_registro_ans_operadora,
	p.id_plano,
	p.nm_plano,
	p.ds_contratacao,
	p.sgmt_assistencial,
	p.ds_odontologico,
	p.ds_obstetricia,
	p.ds_tipo_financiamento,
	p.ds_abrangencia_cobertura,
	p.ds_acomodacao_hospitalar,
	p.ds_situacao_plano,
	p.dt_situacao,
	p.dt_registro_plano,
	fe.ds_faixa_etaria,
	fato.vl_comercial_mensalidade,
	fato.vl_desp_assistencial,
	fato.vcm_minimo,
	fato.vcm_maximo,
	fato.dt_ntrp
FROM {{ ref('fato_mensalidade_por_faixa_etaria') }} fato
JOIN {{ ref('dim_operadoras') }} o ON o.cd_operadora = fato.cd_operadora
JOIN {{ ref('dim_plano') }} p ON p.id_plano = fato.id_plano
JOIN {{ ref('dim_faixa_etaria') }} fe ON fe.cd_faixa_etaria = fato.cd_faixa_etaria
