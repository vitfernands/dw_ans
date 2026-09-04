--Modelagem staging
--Tabela de operadoras ativas

CREATE TABLE operadoras_ativas (
	registro_ans TEXT,
	cnpj TEXT,
	razao_social TEXT,
	nome_fantasia TEXT,
	modalidade TEXT,
	logradouro TEXT,
	numero TEXT,
	complemento TEXT,
	bairro TEXT,
	cidade TEXT,
	uf TEXT,
	cep TEXT,
	ddd TEXT,
	telefone TEXT,
	fax TEXT,
	endereco_eletronico TEXT,
	representante TEXT,
	cargo_repr TEXT,
	regiao_comercializacao TEXT,
	dt_registro_ans TEXT
);

--Tabela de reclamações (IGR)

CREATE TABLE indice_reclamacoes (
	registro_operadora TEXT,
	razao_social TEXT,
	cobertura TEXT,
	igr TEXT,
	qtd_reclamacoes TEXT,
	qtd_beneficiarios TEXT,
	porte_operadora TEXT,
	competencia TEXT,
	competencia_beneficiario TEXT,
	dt_atualizacao TEXT
);

--Tabela taxa de resolutividade

CREATE TABLE taxa_resolutividade (
	registro_ans TEXT,
	razao_social TEXT,
	tp_natureza TEXT,
	vl_tr TEXT,
	nr_numerador TEXT,
	cd_competencia TEXT,
	dt_atualizacao TEXT,
	dt_registro TEXT
);

--Tabela mensalidade por faixa etária

CREATE TABLE mensalidade_por_faixa_etaria (
	cd_operadora TEXT,
	id_plano TEXT,
	cd_nota TEXT,
	dt_ntrp TEXT,
	id_abrg TEXT,
	faixa_etaria TEXT,
	vl_comercial_mensalidade TEXT,
	vl_desp_assistencial TEXT,
	vcm_minimo TEXT,
	vcm_maximo TEXT,
	dt_atualizacao TEXT
);

--Tabela valor comercial por municipio

CREATE TABLE valor_comercial_municipio (
	cd_municipio TEXT,
	id_plano TEXT,
	cd_faixa_etaria TEXT,
	vcm TEXT
);

--Tabelas áreas de comercialização planos de saúde

CREATE TABLE areas_comercializacao_planos (
	id_plano TEXT,
	cd_plano TEXT,
	cd_operadora TEXT,
	cd_nota TEXT,
	dt_ntrp TEXT,
	cd_municipio TEXT,
	nm_municipio TEXT,
	sg_uf TEXT,
	nm_regiao TEXT,
	dt_atualizacao TEXT
);

--Tabela de cadastro de muncipios

CREATE TABLE municipios (
	id_detalhe_area_geografica TEXT,
	sg_uf TEXT,
	cd_municipio TEXT,
	nm_municipio TEXT,
	nm_regiao TEXT
);

--Tabela de caracteristicas dos produtos

CREATE TABLE caracteristicas_produtos_suplementares (
	id_plano TEXT,
	cd_plano TEXT,
	nm_plano TEXT,
	registro_operadora TEXT,
	razao_social TEXT,
	gr_modalidade TEXT,
	porte_operadora TEXT,
	vigencia_plano TEXT,
	contratacao TEXT,
	gr_contratacao TEXT,
	sgmt_assistencial TEXT,
	gr_sgmt_assistencial TEXT,
	ig_odontologico TEXT,
	obstetricia TEXT,
	cobertura TEXT,
	tipo_financiamento TEXT,
	abrangencia_cobertura TEXT,
	id_geo_cobertura TEXT,
	fator_moderador TEXT,
	acomodacao_hospitalar TEXT,
	livre_escolha TEXT,
	situacao_plano TEXT,
	dt_situacao TEXT,
	dt_registro_plano TEXT,
	dt_atualizacao TEXT
);


--Caso seja necessário recriar as tabelas:

DROP TABLE caracteristicas_produtos_suplementares;

DROP TABLE areas_comercializacao_planos;

DROP TABLE mensalidade_por_faixa_etaria;

DROP TABLE operadoras_ativas;

DROP TABLE indice_reclamacoes;

DROP TABLE taxa_resolutividade;

DROP TABLE valor_comercial_municipio;

DROP TABLE municipios;