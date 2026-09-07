SELECT
    TRIM(tr.registro_ans)::INT                        AS cd_operadora,
    TRIM(tr.razao_social)::VARCHAR(255)               AS ds_razao_social,
    TRIM(tr.tp_natureza)::VARCHAR(30)                 AS tp_natureza,
    TRIM(REPLACE(tr.vl_tr, ',', '.'))::DECIMAL(10, 2) AS vl_tr,
    TRIM(tr.nr_numerador)::INT                        AS nr_numerador,
    TRIM(tr.cd_competencia)::INT                      AS cd_competencia,
    tr.dt_atualizacao::VARCHAR(50)                    AS dt_atualizacao,
    TRIM(tr.dt_registro)::DATE                        AS dt_registro

FROM {{source('stage', 'taxa_resolutividade')}} tr
WHERE EXISTS (
    SELECT 1
    FROM {{ ref('tr_operadoras_ativas') }} oa
    WHERE oa.cd_operadora = tr.registro_ans::INT
)