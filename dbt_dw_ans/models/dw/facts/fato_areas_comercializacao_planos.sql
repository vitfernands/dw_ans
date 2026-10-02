SELECT
    p.id_plano,
    o.cd_operadora,
    m.cd_municipio,
    acp.cd_nota,
    acp.dt_ntrp
FROM {{ ref('tr_areas_comercializacao_planos') }} acp
JOIN {{ ref('dim_plano') }} p ON acp.id_plano = p.id_plano
JOIN {{ ref('dim_operadoras') }} o ON o.cd_operadora = acp.cd_operadora
JOIN {{ ref('dim_municipios') }} m ON m.cd_municipio = acp.cd_municipio