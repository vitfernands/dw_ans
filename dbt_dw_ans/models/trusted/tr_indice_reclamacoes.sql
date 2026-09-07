SELECT
    TRIM(ir.registro_operadora)::INT                AS cd_operadora,
    TRIM(ir.razao_social)::VARCHAR(255)             AS razao_social,
    TRIM(ir.cobertura)::VARCHAR(255)                AS cobertura,
    TRIM(ir.igr)::INT                               AS igr,
    TRIM(ir.qtd_reclamacoes)::INT                   AS qtd_reclamacoes,
    TRIM(ir.qtd_beneficiarios)::INT                 AS qtd_benef,
    TRIM(ir.porte_operadora)::VARCHAR(255)          AS porte_operadora,
    TRIM(ir.competencia)::VARCHAR(10)               AS competencia,
    TRIM(ir.competencia_beneficiario)::VARCHAR(10),
    TRIM(ir.dt_atualizacao)::DATE                   AS dt_download

FROM {{source('stage', 'indice_reclamacoes')}} ir