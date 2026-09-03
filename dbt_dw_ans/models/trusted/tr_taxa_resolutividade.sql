SELECT
    TRIM(registro_ans)::INT                        AS cd_operadora,
    TRIM(razao_social)::VARCHAR(255)               AS razao_social,
    TRIM(tp_natureza)::VARCHAR(30)                 AS tp_natureza,
    TRIM(REPLACE(vl_tr, ',', '.'))::DECIMAL(10, 2) AS vl_tr,
    TRIM(nr_numerador)::INT                        AS nr_numerador,
    TRIM(cd_competencia)::INT                      AS cd_competencia,
    dt_atualizacao::VARCHAR(50)                    AS dt_atualizacao,
    TRIM(dt_registro)::DATE                        AS dt_registro

FROM {{source('stage', 'taxa_resolutividade')}}