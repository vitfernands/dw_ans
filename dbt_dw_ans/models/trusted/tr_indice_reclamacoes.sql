SELECT
    TRIM(ir.registro_operadora)::INT                AS cd_operadora,
    TRIM(ir.razao_social)::VARCHAR(255)             AS razao_social,
    TRIM(ir.cobertura)::VARCHAR(255)                AS ds_cobertura,
    TRIM(REPLACE(ir.igr, ',', '.'))::DECIMAL        AS igr,
    TRIM(ir.qtd_reclamacoes)::INT                   AS qtd_reclamacoes,
    TRIM(ir.qtd_beneficiarios)::INT                 AS qtd_beneficiarios,
    TRIM(ir.porte_operadora)::VARCHAR(255)          AS ds_porte_operadora,
    TRIM(ir.competencia)::VARCHAR(10)               AS ds_competencia,
    TRIM(ir.competencia_beneficiario)::VARCHAR(10)  AS ds_competencia_beneficiario,
    TRIM(ir.dt_atualizacao)::DATE                   AS dt_atualizacao

FROM {{source('stage', 'indice_reclamacoes')}} ir
WHERE EXISTS (
    SELECT 1
    FROM {{ ref('tr_areas_comercializacao_planos') }} acp
    WHERE acp.cd_operadora = ir.registro_operadora::INT
)