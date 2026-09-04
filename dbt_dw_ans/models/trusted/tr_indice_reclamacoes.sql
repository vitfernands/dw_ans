SELECT
    TRIM(ir.registro_ans)::INT              AS registro_ans,
    TRIM(ir.razao_social)::VARCHAR(255)     AS razao_social,
    TRIM(ir.cobertura)::VARCHAR(255)        AS cobertura,
    TRIM(ir.igr)::INT                       AS igr,
    TRIM(ir.qtd_reclamacao)::INT            AS qtd_reclamacao,
    TRIM(ir.qtd_benef)::INT                 AS qtd_benef,
    TRIM(ir.competencia)::VARCHAR(255)      AS porte_operadora,
    TRIM(ir.competencia_benef)::VARCHAR(10) AS competencia_benef,
    TRIM(ir.dt_atualizacao)::VARCHAR(10)    AS dt_atualizacao,
    TRIM(ir.dt_download)::DATE              AS dt_download

FROM {{source('stage', 'indice_reclamacoes')}} ir