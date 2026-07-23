SELECT
    id_plano,
    cd_plano,
    nm_plano,
    contratacao           AS ds_contratacao,
    sgmt_assistencial,
    CASE 
        WHEN ig_odontologico = '1' THEN 'Inclui cobertura odontológica'
        WHEN ig_odontologico = '0' THEN 'Não Inclui cobertura odontológica'
        ELSE 'Não informado'
    END                   AS ds_odontologico,
    obstetricia           AS ds_obstetricia,
    tipo_financiamento    AS ds_tipo_financiamento,
    abrangencia_cobertura AS ds_abrangencia_cobertura,
    fator_moderador       AS ds_fator_moderador,
    acomodacao_hospitalar AS ds_acomodacao_hospitalar,
    livre_escolha         AS ds_livre_escolha,
    situacao_plano        AS ds_situacao_plano,
    dt_situacao,
    dt_registro_plano

FROM {{ ref('tr_caracteristicas_produtos_suplementares') }}