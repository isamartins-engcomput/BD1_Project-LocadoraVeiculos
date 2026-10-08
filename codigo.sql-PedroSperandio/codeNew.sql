CREATE DATABASE locadora_veiculos;

CREATE TABLE public.cidade (
	id_cidade SERIAL NOT NULL,
	nome VARCHAR(100) NOT NULL,
	estado CHAR(2) NOT NULL,
	CONSTRAINT cidade_pkey PRIMARY KEY (id_cidade),
	CONSTRAINT cidade_nome_estado_key UNIQUE (nome, estado)
);

CREATE TABLE public.pessoa (
	id_pessoa SERIAL NOT NULL,
	telefone VARCHAR(20),
	email VARCHAR(100),
	id_cidade INTEGER NOT NULL,
	CONSTRAINT pessoa_pkey PRIMARY KEY (id_pessoa)
);

CREATE TABLE public.individuo (
	id_pessoa INTEGER NOT NULL,
	nome VARCHAR(150) NOT NULL,
	cpf VARCHAR(14) NOT NULL,
	rg VARCHAR(20) NOT NULL,
	CONSTRAINT individuo_pkey PRIMARY KEY (id_pessoa),
	CONSTRAINT individuo_cpf_key UNIQUE (cpf)
);

CREATE TABLE public.organizacao (
	id_pessoa INTEGER NOT NULL,
	razao_social VARCHAR(150) NOT NULL,
	nome_fantasia VARCHAR(150) NOT NULL,
	cnpj VARCHAR(18) NOT NULL,
	CONSTRAINT organizacao_pkey PRIMARY KEY (id_pessoa),
	CONSTRAINT organizacao_cnpj_key UNIQUE (cnpj)
);

CREATE TABLE public.cliente (
	id_pessoa INTEGER NOT NULL,
	CONSTRAINT cliente_pkey PRIMARY KEY (id_pessoa)
);

CREATE TABLE public.cliente_autorizado (
	id_pessoa INTEGER NOT NULL,
	data_liberacao DATE NOT NULL,
	CONSTRAINT cliente_autorizado_pkey PRIMARY KEY (id_pessoa)
);

CREATE TABLE public.proprietario (
	id_pessoa INTEGER NOT NULL,
	data_inicio_condicao DATE NOT NULL,
	numero_ultimo_contrato VARCHAR(50),
	CONSTRAINT proprietario_pkey PRIMARY KEY (id_pessoa)
);

CREATE TABLE public.locadora (
	id_pessoa INTEGER NOT NULL,
	CONSTRAINT locadora_pkey PRIMARY KEY (id_pessoa)
);

CREATE TABLE public.setor (
	id_setor SERIAL NOT NULL,
	nome_setor VARCHAR(50) NOT NULL,
	id_locadora INTEGER NOT NULL,
	CONSTRAINT setor_pkey PRIMARY KEY (id_setor),
	CONSTRAINT setor_nome_setor_id_locadora_key UNIQUE (nome_setor, id_locadora)
);

CREATE TABLE public.funcionario (
	id_pessoa INTEGER NOT NULL,
	matricula VARCHAR(20) NOT NULL,
	data_admissao DATE NOT NULL,
	salario_base NUMERIC(10,2) NOT NULL,
	id_locadora INTEGER NOT NULL,
	CONSTRAINT funcionario_pkey PRIMARY KEY (id_pessoa),
	CONSTRAINT funcionario_matricula_key UNIQUE (matricula)
);

CREATE TABLE public.vendedor (
	id_pessoa INTEGER NOT NULL,
	percentual_comissao NUMERIC(5,2) NOT NULL,
	CONSTRAINT vendedor_pkey PRIMARY KEY (id_pessoa)
);

CREATE TABLE public.gerente (
	id_pessoa INTEGER NOT NULL,
	id_setor INTEGER NOT NULL,
	CONSTRAINT gerente_pkey PRIMARY KEY (id_pessoa)
);

CREATE TABLE public.fabricante (
	id_fabricante SERIAL NOT NULL,
	nome VARCHAR(100) NOT NULL,
	ano_fundacao INTEGER,
	pais_origem VARCHAR(50),
	CONSTRAINT fabricante_pkey PRIMARY KEY (id_fabricante)
);

CREATE TABLE public.modelo (
	id_modelo SERIAL NOT NULL,
	nome VARCHAR(100) NOT NULL,
	consumo_medio NUMERIC(5,2) NOT NULL,
	numero_marchas INTEGER NOT NULL,
	ano_lancamento INTEGER NOT NULL,
	ano_final_producao INTEGER,
	capacidade_porta_malas INTEGER NOT NULL,
	velocidade_maxima INTEGER NOT NULL,
	tempo_aceleracao_0_100 NUMERIC(5,2) NOT NULL,
	tipo_cambio VARCHAR(30) NOT NULL,
	torque NUMERIC(6,2) NOT NULL,
	potencia INTEGER NOT NULL,
	id_fabricante INTEGER NOT NULL,
	CONSTRAINT modelo_pkey PRIMARY KEY (id_modelo)
);

CREATE TABLE public.cor (
	id_cor SERIAL NOT NULL,
	nome VARCHAR(50) NOT NULL,
	codigo_hexadecimal VARCHAR(7),
	tipo VARCHAR(30),
	acabamento VARCHAR(30),
	caracteristicas_pintura TEXT,
	CONSTRAINT cor_pkey PRIMARY KEY (id_cor)
);

CREATE TABLE public.tipo_de_propulsao (
	id_tipo_propulsao SERIAL NOT NULL,
	nome VARCHAR(50) NOT NULL,
	descricao TEXT NOT NULL,
	usa_tanque BOOLEAN NOT NULL,
	usa_bateria BOOLEAN NOT NULL,
	CONSTRAINT tipo_de_propulsao_pkey PRIMARY KEY (id_tipo_propulsao)
);

CREATE TABLE public.veiculo (
	placa VARCHAR(7) NOT NULL,
	chassi VARCHAR(17) NOT NULL,
	preco_venda NUMERIC(10,2) NOT NULL,
	valor_diaria NUMERIC(8,2) NOT NULL,
	condicao VARCHAR(30) NOT NULL,
	ano_fabricacao INTEGER NOT NULL,
	quilometragem_atual INTEGER NOT NULL,
	id_modelo INTEGER NOT NULL,
	id_cor INTEGER NOT NULL,
	id_tipo_propulsao INTEGER NOT NULL,
	id_proprietario INTEGER NOT NULL,
	CONSTRAINT veiculo_pkey PRIMARY KEY (placa),
	CONSTRAINT veiculo_chassi_key UNIQUE (chassi),
	CONSTRAINT veiculo_condicao_check CHECK (condicao IN ('Excelente', 'Muito bom', 'Bom', 'Regular', 'de Colecionador'))
);

CREATE TABLE public.locacao (
	id_locacao SERIAL NOT NULL,
	quilometragem_inicial INTEGER NOT NULL,
	quilometragem_final INTEGER,
	data_hora_retirada TIMESTAMP NOT NULL,
	data_hora_devolucao_prevista TIMESTAMP NOT NULL,
	data_hora_devolucao_efetiva TIMESTAMP,
	valor_operacao NUMERIC(10,2),
	id_cliente INTEGER NOT NULL,
	placa_veiculo VARCHAR(7) NOT NULL,
	id_vendedor INTEGER NOT NULL,
	id_locadora INTEGER NOT NULL,
	CONSTRAINT locacao_pkey PRIMARY KEY (id_locacao)
);

ALTER TABLE public.pessoa ADD CONSTRAINT fk_pessoa_cidade FOREIGN KEY (id_cidade) REFERENCES public.cidade (id_cidade);
ALTER TABLE public.individuo ADD CONSTRAINT fk_individuo_pessoa FOREIGN KEY (id_pessoa) REFERENCES public.pessoa (id_pessoa);
ALTER TABLE public.organizacao ADD CONSTRAINT fk_org_pessoa FOREIGN KEY (id_pessoa) REFERENCES public.pessoa (id_pessoa);
ALTER TABLE public.cliente ADD CONSTRAINT fk_cliente_pessoa FOREIGN KEY (id_pessoa) REFERENCES public.pessoa (id_pessoa);
ALTER TABLE public.cliente_autorizado ADD CONSTRAINT fk_cliente_auth_cliente FOREIGN KEY (id_pessoa) REFERENCES public.cliente (id_pessoa);
ALTER TABLE public.proprietario ADD CONSTRAINT fk_proprietario_pessoa FOREIGN KEY (id_pessoa) REFERENCES public.pessoa (id_pessoa);
ALTER TABLE public.locadora ADD CONSTRAINT fk_locadora_org FOREIGN KEY (id_pessoa) REFERENCES public.organizacao (id_pessoa);
ALTER TABLE public.setor ADD CONSTRAINT fk_setor_locadora FOREIGN KEY (id_locadora) REFERENCES public.locadora (id_pessoa);
ALTER TABLE public.funcionario ADD CONSTRAINT fk_func_individuo FOREIGN KEY (id_pessoa) REFERENCES public.individuo (id_pessoa);
ALTER TABLE public.funcionario ADD CONSTRAINT fk_func_locadora FOREIGN KEY (id_locadora) REFERENCES public.locadora (id_pessoa);
ALTER TABLE public.vendedor ADD CONSTRAINT fk_vendedor_func FOREIGN KEY (id_pessoa) REFERENCES public.funcionario (id_pessoa);
ALTER TABLE public.gerente ADD CONSTRAINT fk_gerente_func FOREIGN KEY (id_pessoa) REFERENCES public.funcionario (id_pessoa);
ALTER TABLE public.gerente ADD CONSTRAINT fk_gerente_setor FOREIGN KEY (id_setor) REFERENCES public.setor (id_setor);
ALTER TABLE public.modelo ADD CONSTRAINT fk_modelo_fabricante FOREIGN KEY (id_fabricante) REFERENCES public.fabricante (id_fabricante);
ALTER TABLE public.veiculo ADD CONSTRAINT fk_veiculo_modelo FOREIGN KEY (id_modelo) REFERENCES public.modelo (id_modelo);
ALTER TABLE public.veiculo ADD CONSTRAINT fk_veiculo_cor FOREIGN KEY (id_cor) REFERENCES public.cor (id_cor);
ALTER TABLE public.veiculo ADD CONSTRAINT fk_veiculo_propulsao FOREIGN KEY (id_tipo_propulsao) REFERENCES public.tipo_de_propulsao (id_tipo_propulsao);
ALTER TABLE public.veiculo ADD CONSTRAINT fk_veiculo_proprietario FOREIGN KEY (id_proprietario) REFERENCES public.proprietario (id_pessoa);
ALTER TABLE public.locacao ADD CONSTRAINT fk_locacao_cliente FOREIGN KEY (id_cliente) REFERENCES public.cliente (id_pessoa);
ALTER TABLE public.locacao ADD CONSTRAINT fk_locacao_veiculo FOREIGN KEY (placa_veiculo) REFERENCES public.veiculo (placa);
ALTER TABLE public.locacao ADD CONSTRAINT fk_locacao_vendedor FOREIGN KEY (id_vendedor) REFERENCES public.vendedor (id_pessoa);
ALTER TABLE public.locacao ADD CONSTRAINT fk_locacao_locadora FOREIGN KEY (id_locadora) REFERENCES public.locadora (id_pessoa);