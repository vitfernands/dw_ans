{{ config(
    unique_key=['cd_operadora'],
    indexes=[
        {'columns': ['cd_operadora'], 'unique': True}
    ]
) }}

-- Recorte "mercado de SC": toda operadora que comercializa planos em municípios de SC,
-- independentemente da UF da sede e de estar ativa ou não.
-- Atributos cadastrais vêm do cadastro de operadoras ativas (CADOP); para operadoras
-- que não estão mais ativas, nome e modalidade vêm das características dos planos.

WITH operadoras_mercado_sc AS (
    SELECT DISTINCT cd_operadora
    FROM {{ ref('tr_areas_comercializacao_planos') }}
),

operadoras_planos AS (
    SELECT
        registro_ans       AS cd_operadora,
        MAX(razao_social)  AS razao_social,
        MAX(gr_modalidade) AS gr_modalidade
    FROM {{ ref('tr_caracteristicas_produtos_suplementares') }}
    GROUP BY registro_ans
)

SELECT
    om.cd_operadora,
    oa.cnpj,
    COALESCE(oa.razao_social, op.razao_social, 'Operadora ' || om.cd_operadora) AS nm_operadora,
    oa.nome_fantasia AS ds_nome_fantasia,
    COALESCE(
        NULLIF(oa.modalidade, ''),
        -- Padroniza a nomenclatura das características dos planos com a do CADOP
        CASE op.gr_modalidade
            WHEN 'Medicina De Grupo'        THEN 'Medicina de Grupo'
            WHEN 'Odontologia De Grupo'     THEN 'Odontologia de Grupo'
            WHEN 'Cooperativa Odontológica' THEN 'Cooperativa odontológica'
            WHEN 'Seguradora'               THEN 'Seguradora Especializada em Saúde'
            WHEN 'Administradora'           THEN 'Administradora de Benefícios'
            ELSE op.gr_modalidade
        END,
        'Não informado'
    )                AS ds_modalidade,
    oa.logradouro    AS ds_logradouro,
    oa.numero        AS ds_numero_endereco,
    oa.complemento   AS ds_complemento_endereco,
    oa.bairro        AS ds_bairro,
    oa.cidade        AS ds_cidade,
    oa.uf,
    oa.cep,
    oa.ddd,
    oa.telefone,
    oa.representante,
    oa.cargo_repr    AS cargo_representante,
    CASE
        WHEN oa.regiao_comercializacao = 1 THEN 'Em todo o território nacional ou em grupos de pelo menos três estados dentre os seguintes: São Paulo, Rio de Janeiro, Minas Gerais, Rio Grande do Sul, Paraná e Bahia'

        WHEN oa.regiao_comercializacao = 2 THEN 'No Estado de São Paulo ou em mais de um estado, excetuando os grupos definidos no critério da região 1'

        WHEN oa.regiao_comercializacao = 3 THEN 'Em um único estado, qualquer que seja ele, excetuando-se o Estado de São Paulo'

        WHEN oa.regiao_comercializacao = 4 THEN 'No Município de São Paulo, do Rio de Janeiro, de Belo Horizonte, de Porto Alegre ou de Curitiba ou de Brasília'

        WHEN oa.regiao_comercializacao = 5 THEN 'Em grupo de municípios, excetuando os definidos na região 4'

        WHEN oa.regiao_comercializacao = 6 THEN 'Em um único município, excetuando os definidos na região 4'

        ELSE 'Não definido'
    END AS ds_regiao_comercializacao,

    oa.dt_registro_ans,
    (oa.cd_operadora IS NOT NULL)      AS fl_operadora_ativa,
    COALESCE(oa.uf = 'SC', FALSE)      AS fl_sede_sc
FROM operadoras_mercado_sc om
LEFT JOIN {{ ref('tr_operadoras_ativas') }} oa ON oa.cd_operadora = om.cd_operadora
LEFT JOIN operadoras_planos op ON op.cd_operadora = om.cd_operadora
