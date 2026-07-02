SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['id_plano']) }}           AS id_plano,
    id_plano                                                       AS cd_plano,
    {{ dbt_utils.generate_surrogate_key(['registro_operadora']) }} AS id_operadora,
    nm_plano,
    situacao_plano,
    abrangencia_cobertura                                          AS abrangencia,
    obstetricia
FROM {{ ref('stg_caracteristicas_produtos_suplementares') }}
WHERE situacao_plano = 'Ativo'