SELECT
    TRIM(registro_ans)::INT              AS registro_ans,
    TRIM(razao_social)::VARCHAR(255)     AS razao_social,
    TRIM(cobertura)::VARCHAR(255)        AS cobertura,
    TRIM(igr)::INT                       AS igr,
    TRIM(qtd_reclamacao)::INT            AS qtd_reclamacao,
    TRIM(qtd_benef)::INT                 AS qtd_benef,
    TRIM(competencia)::VARCHAR(255)      AS porte_operadora,
    TRIM(competencia_benef)::VARCHAR(10) AS competencia_benef,
    TRIM(dt_atualizacao)::VARCHAR(10)    AS dt_atualizacao,
    TRIM(dt_download)::DATE              AS dt_download

FROM {{source('stage', 'indice_reclamacoes')}}