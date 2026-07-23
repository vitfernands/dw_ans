WITH operadoras AS (
    SELECT * FROM {{ ref('stg_operadoras_ativas') }}
),

caracteristicas AS (
    SELECT DISTINCT
        registro_operadora,
        porte_operadora
    FROM {{ ref('tr_caracteristicas_produtos_suplementares') }}
)

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['o.registro_ans']) }} AS id_operadora,
    o.registro_ans,
    o.razao_social,
    o.nome_fantasia,
    o.modalidade,
    c.porte_operadora
FROM operadoras o
LEFT JOIN caracteristicas c ON o.registro_ans::VARCHAR = c.registro_operadora