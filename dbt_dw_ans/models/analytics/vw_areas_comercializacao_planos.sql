SELECT 
	fato.id_plano,
	fato.cd_operadora,
	o.nm_operadora,
	m.nm_municipio,
	fato.dt_ntrp
FROM {{ ref('fato_areas_comercializacao_planos') }} fato
JOIN {{ ref('dim_operadoras') }} o ON o.cd_operadora = fato.cd_operadora
LEFT JOIN {{ ref('dim_municipios') }} m ON m.cd_municipio = fato.cd_municipio