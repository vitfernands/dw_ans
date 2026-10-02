{{ config(
    unique_key=['cd_operadora'],
    indexes=[
        {'columns': ['cd_operadora']}
    ]
) }}

SELECT
    oa.cd_operadora,
    oa.cnpj,
    oa.razao_social  AS nm_operadora,
    oa.nome_fantasia AS ds_nome_fantasia,
    oa.modalidade    AS ds_modalidade,
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

        ELSE 'Não denifido'
    END AS ds_regiao_comercializacao,

    oa.dt_registro_ans  
FROM {{ ref('tr_operadoras_ativas') }} oa
