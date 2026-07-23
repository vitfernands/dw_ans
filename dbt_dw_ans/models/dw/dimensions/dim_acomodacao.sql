SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['acomodacao_hospitalar']) }} AS id_acomodacao,
    acomodacao_hospitalar                                             AS acomodacao
FROM {{ ref('tr_caracteristicas_produtos_suplementares') }}