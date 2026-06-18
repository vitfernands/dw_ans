WITH mapa AS (
    SELECT * FROM {{ ref('stg_mapeamento_faixa_etaria') }}
),

dim_final AS (
    SELECT
        -- A Surrogate Key continua sendo gerada com base na descrição por extenso
        {{ dbt_utils.generate_surrogate_key(['faixa_etaria']) }} AS id_faixa_etaria,
        cd_faixa_etaria,
        faixa_etaria
    FROM mapa
)

SELECT * FROM dim_final