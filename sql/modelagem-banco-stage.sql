--Modelagem staging
--Tabela de operadoras ativas

CREATE TABLE operadoras_ativas (
	registro_ans INT,
	cnpj VARCHAR(14),
	razao_social VARCHAR(255),
	nome_fantasia VARCHAR(255),
	modalidade VARCHAR(255),
	logradouro VARCHAR(255),
	numero VARCHAR (10),
	complemento VARCHAR(255),
	bairro VARCHAR(255),
	cidade VARCHAR(255),
	uf VARCHAR(2),
	ddd VARCHAR(3),
	telefone VARCHAR(20),
	fax VARCHAR(30),
	endereco_eletronico VARCHAR(100),
	representante VARCHAR(255),
	cargo_repr VARCHAR(255),
	regiao_comercializacao VARCHAR(2),
	dt_registro_ans DATE
);

--Tabela de reclamações (IGR)

CREATE TABLE indice_reclamacoes (
	registro_ans INT,
	razao_social VARCHAR(255),
	cobertura VARCHAR(255),
	igr DECIMAL(10,2),
	qtd_reclamacao INT,
	qtd_benef INT,
	porte_operadora VARCHAR(50),
	competencia VARCHAR(50),
	competencia_benef VARCHAR(20),
	dt_atualizacao VARCHAR(20),
	dt_download VARCHAR(20)
);

--Tabela taxa de resolutividade

CREATE TABLE taxa_resolutividade (
	registro_ans INT,
	razao_social VARCHAR(255),
	tp_natureza VARCHAR(30),
	vl_tr INT,
	nr_numerador INT,
	cd_competencia INT,
	dt_atualizacao DATE,
	dt_registro DATE
);

--Tabela mensalidade por faixa etária

CREATE TABLE mensalidade_por_faixa_etaria (
	cd_operadora INT,
	id_plano INT,
	cd_nota INT,
	dt_ntrp VARCHAR(20),
	id_abrg INT,
	faixa_etaria VARCHAR(50),
	vl_comercial_mensalidade DECIMAL(10,2),
	vl_desp_assistencial DECIMAL(10,2),
	vcm_minimo DECIMAL(10,2),
	vcm_maximo DECIMAL(10,2),
	dt_atualizacao VARCHAR(20)
);

--Tabela valor comercial por municipio

CREATE TABLE valor_comercial_municipio (
	cd_municipio INT,
	id_plano INT,
	cd_faixa_etaria INT,
	vcm INT
);

--Tabelas áreas de comercialização planos de saúde

CREATE TABLE areas_comercializacao_planos (
	id_plano INT,
	cd_plano INT,
	cd_operadora INT,
	cd_nota INT,
	dt_ntrp DATE,
	cd_municipio INT,
	nm_municipio VARCHAR(100),
	sg_uf CHAR(2),
	nm_regiao VARCHAR(50),
	dt_atualizacao DATE
);

--Tabela de cadastro de muncipios

CREATE TABLE municipios (
	id_detalhe_area_geografica VARCHAR(255),
	sg_uf VARCHAR(2)
	cd_municipio INT,
	nm_municipio VARCHAR(255),
	nm_regiao VARCHAR(50)
);

--Tabela de caracteristicas dos produtos

CREATE TABLE caracteristicas_produtos_suplementares (
	id_plano INT,
	cd_plano INT,
	nm_plano VARCHAR(255),
	registro_operadora INT,
	razao_social VARCHAR(255),
	gr_modalidade VARCHAR(100),
	porte_operadora VARCHAR(50),
	vigencia_plano CHAR(1),
	contratacao VARCHAR(100),
	gr_contratacao VARCHAR(100),
	sgmt_assistencial VARCHAR(255),
	gr_sgmt_assistencial VARCHAR(255),
	ig_odontologico CHAR(1),
	obstetricia VARCHAR(100),
	cobertura VARCHAR(100),
	tipo_financiamento VARCHAR(100),
	abrangencia_cobertura VARCHAR(100),
	id_geo_cobertura VARCHAR(255),
	fator_moderador VARCHAR(100),
	acomodacao_hospitalar VARCHAR(100),
	livre_escolha VARCHAR(100),
	situacao_plano VARCHAR(100),
	dt_situacao DATE,
	dt_registro_plano DATE,
	dt_atualizacao DATE
);