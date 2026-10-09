# 🚗 Locadora de Veículos — Projeto de Banco de Dados

<div align="center">

**Projeto de modelagem conceitual, relacional e implementação SQL para uma locadora de veículos**

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-DDL-336791?style=for-the-badge)
![DER](https://img.shields.io/badge/DER-Modelo%20Conceitual-8A2BE2?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Concluído-2EA44F?style=for-the-badge)

</div>

---

## 📌 Sobre o projeto

Este projeto foi desenvolvido para representar, em banco de dados, o funcionamento de um ambiente de **locação de veículos**, contemplando pessoas, organizações, clientes, proprietários, funcionários, locadoras, setores, veículos, modelos, fabricantes, cores, tipos de propulsão e as ocorrências de locação.

A proposta foi construída em três níveis:

1. **DER — Diagrama Entidade-Relacionamento**, responsável pela visão conceitual;
2. **Modelo Relacional**, responsável pela transformação do DER em tabelas, chaves primárias e estrangeiras;
3. **Script SQL**, responsável pela implementação da estrutura no PostgreSQL.

A principal preocupação durante a modelagem foi **evitar redundância de dados** e permitir que uma mesma pessoa exerça diferentes papéis dentro do sistema sem precisar ser cadastrada mais de uma vez.

---

# 🧠 Visão geral da solução

O fluxo do projeto pode ser resumido assim:

```text
Narrativa do problema
        ↓
DER / Modelo Conceitual
        ↓
Modelo Relacional
        ↓
Script SQL
        ↓
Banco de Dados PostgreSQL
```

Cada etapa representa o mesmo sistema em um nível diferente de abstração.

---

# 🟣 1. Modelo Conceitual — DER

O DER foi construído para representar:

- entidades;
- atributos;
- atributos identificadores;
- relacionamentos;
- cardinalidades;
- generalizações e especializações;
- papéis simultâneos de uma mesma pessoa;
- ocorrências de locação.

## Legenda utilizada

| Elemento | Significado |
|---|---|
| Retângulo | Entidade |
| Losango | Relacionamento |
| Triângulo | Generalização / Especialização |
| Círculo vermelho | Atributo identificador |
| Círculo branco | Atributo comum |
| `1 / N` | Cardinalidade |

> As cores foram utilizadas apenas para facilitar a leitura do modelo.

---

# 👤 Estrutura de pessoas e papéis

A entidade central do projeto é `PESSOA`.

Ela concentra os dados comuns:

- `id_pessoa`
- `telefone`
- `email`

A partir dela, foi feita a separação entre:

```text
PESSOA
├── INDIVÍDUO
└── ORGANIZAÇÃO
```

## INDIVÍDUO

Representa pessoas físicas.

Atributos:

- `nome`
- `CPF`
- `RG`

## ORGANIZAÇÃO

Representa pessoas jurídicas.

Atributos:

- `razao_social`
- `nome_fantasia`
- `CNPJ`

Essa decisão permite armazenar os dados comuns apenas uma vez, evitando duplicação.

---

# 🎭 Papéis exercidos por uma pessoa

Uma mesma `PESSOA` pode exercer diferentes papéis no sistema.

## CLIENTE

Representa a pessoa que realiza locações.

Não possui dados pessoais repetidos, pois herda a identidade de `PESSOA`.

### CLIENTE AUTORIZADO

Especialização utilizada para representar clientes liberados para operações com veículos exclusivos ou de colecionador.

Atributo específico:

- `data_liberacao`

---

## PROPRIETÁRIO

Representa a pessoa ou organização responsável pela propriedade de veículos.

Atributos:

- `data_inicio_condicao`
- `numero_ultimo_contrato`

Relacionamento principal:

```text
PROPRIETÁRIO 1 ── possui ── N VEÍCULO
```

---

# 👨‍💼 Funcionários

Um `INDIVÍDUO` pode ser também um `FUNCIONÁRIO`.

```text
INDIVÍDUO
    ↓
FUNCIONÁRIO
```

Atributos:

- `matricula`
- `data_admissao`
- `salario_base`

Cada funcionário trabalha para uma única locadora:

```text
FUNCIONÁRIO N ── trabalha para ── 1 LOCADORA
```

## VENDEDOR

Especialização de funcionário.

Atributo:

- `percentual_comissao`

Um vendedor pode atender várias locações:

```text
VENDEDOR 1 ── atende ── N LOCAÇÃO
```

## GERENTE

Especialização de funcionário.

O gerente administra um setor:

```text
GERENTE N ── administra ── 1 SETOR
```

---

# 🏢 Locadora e setores

Uma organização pode ser uma `LOCADORA`.

```text
ORGANIZAÇÃO
     ↓
  LOCADORA
```

A locadora possui setores:

```text
LOCADORA 1 ── possui ── N SETOR
```

## SETOR

Atributos:

- `id_setor`
- `nome_setor`

No modelo relacional, o nome do setor é único dentro de cada locadora por meio da combinação:

```text
(nome_setor, id_locadora)
```

Assim, duas locadoras podem possuir um setor chamado `Financeiro`, mas uma mesma locadora não pode possuir dois setores com o mesmo nome.

---

# 🌎 Cidade

As pessoas são associadas a uma cidade.

## CIDADE

Atributos:

- `id_cidade`
- `nome`
- `estado`

Relacionamento:

```text
CIDADE 1 ── localiza-se em ── N PESSOA
```

No modelo relacional, a cidade é referenciada por `pessoa.id_cidade`.

---

# 🚘 Veículos

A entidade `VEÍCULO` representa o exemplar físico do automóvel.

Atributos:

- `placa`
- `chassi`
- `preco_venda`
- `valor_diaria`
- `condicao`
- `ano_fabricacao`
- `quilometragem_atual`

A `placa` foi utilizada como atributo identificador.

O `chassi` também possui restrição de unicidade no SQL.

## Condição do veículo

No script SQL, os valores permitidos são:

- `Excelente`
- `Muito bom`
- `Bom`
- `Regular`
- `de Colecionador`

Essa regra foi implementada por uma restrição `CHECK`.

---

# 🧩 Modelo do veículo

As características técnicas que se repetem entre veículos iguais foram separadas em `MODELO`.

Relacionamento:

```text
VEÍCULO N ── pertence ── 1 MODELO
```

## MODELO

Atributos:

- `id_modelo`
- `nome`
- `consumo_medio`
- `numero_marchas`
- `ano_lancamento`
- `ano_final_producao`
- `capacidade_porta_malas`
- `velocidade_maxima`
- `tempo_aceleracao_0_100`
- `tipo_cambio`
- `torque`
- `potencia`

Essa separação evita repetir informações técnicas em cada veículo físico.

---

# 🏭 Fabricante

Cada modelo é produzido por um fabricante.

```text
MODELO N ── é produzido por ── 1 FABRICANTE
```

## FABRICANTE

Atributos:

- `id_fabricante`
- `nome`
- `ano_fundacao`
- `pais_origem`

---

# 🎨 Cor

Cada veículo possui uma cor predominante.

```text
VEÍCULO N ── possui cor ── 1 COR
```

## COR

Atributos:

- `id_cor`
- `nome`
- `codigo_hexadecimal`
- `tipo`
- `acabamento`
- `caracteristicas_pintura`

---

# ⚡ Tipo de propulsão

Cada veículo utiliza um tipo de propulsão.

```text
VEÍCULO N ── utiliza ── 1 TIPO DE PROPULSÃO
```

## TIPO DE PROPULSÃO

Atributos:

- `id_tipo_propulsao`
- `nome`
- `descricao`
- `usa_tanque`
- `usa_bateria`

Esse modelo permite representar, por exemplo:

```text
Combustão
usa_tanque = true
usa_bateria = false

Elétrico
usa_tanque = false
usa_bateria = true

Híbrido
usa_tanque = true
usa_bateria = true
```

---

# 🔑 Entidade LOCAÇÃO

`LOCAÇÃO` é a principal entidade de ocorrência do sistema.

Ela representa cada aluguel realizado e possui dados que não pertencem exclusivamente ao cliente nem ao veículo.

## Atributos

- `id_locacao`
- `quilometragem_inicial`
- `quilometragem_final`
- `data_hora_retirada`
- `data_hora_devolucao_prevista`
- `data_hora_devolucao_efetiva`
- `valor_operacao`

## Relacionamentos

Cada locação está relacionada a:

```text
CLIENTE  1 ───────── N LOCAÇÃO
VEÍCULO  1 ───────── N LOCAÇÃO
VENDEDOR 1 ───────── N LOCAÇÃO
LOCADORA 1 ───────── N LOCAÇÃO
```

Ou seja, cada ocorrência de locação permite identificar:

- quem alugou;
- qual veículo foi utilizado;
- qual vendedor realizou o atendimento;
- qual locadora realizou a operação;
- quando o veículo foi retirado;
- quando deveria ser devolvido;
- quando foi efetivamente devolvido;
- quilometragem inicial e final;
- valor da operação.

---

# 🔄 Generalizações e especializações

O projeto utiliza herança para reduzir redundância.

## Estrutura principal

```text
PESSOA
├── INDIVÍDUO
│   └── FUNCIONÁRIO
│       ├── VENDEDOR
│       └── GERENTE
│
└── ORGANIZAÇÃO
    └── LOCADORA
```

Além disso:

```text
PESSOA
├── CLIENTE
│   └── CLIENTE AUTORIZADO
└── PROPRIETÁRIO
```

Uma mesma pessoa pode, portanto, existir simultaneamente em diferentes papéis.

### Exemplo

Uma pessoa pode ser:

```text
PESSOA
├── INDIVÍDUO
│   └── FUNCIONÁRIO
│       └── VENDEDOR
├── CLIENTE
└── PROPRIETÁRIO
```

sem que telefone, e-mail, CPF ou demais informações precisem ser duplicados.

---

# 🗃️ 2. Modelo Relacional

Após a definição do DER, as entidades foram convertidas em tabelas.

Os relacionamentos `1:N` foram implementados com chaves estrangeiras no lado `N`.

## Exemplo: Cidade e Pessoa

No DER:

```text
CIDADE 1 ── N PESSOA
```

No modelo relacional:

```text
PESSOA
├── id_pessoa PK
└── id_cidade FK → CIDADE.id_cidade
```

---

# 🧬 Herança no modelo relacional

As especializações utilizam a mesma chave da entidade pai.

Exemplo:

```text
PESSOA
id_pessoa PK

INDIVIDUO
id_pessoa PK/FK → PESSOA

FUNCIONARIO
id_pessoa PK/FK → INDIVIDUO

VENDEDOR
id_pessoa PK/FK → FUNCIONARIO
```

Assim, a identidade da pessoa é preservada em todas as especializações.

O mesmo ocorre em:

```text
ORGANIZACAO
id_pessoa PK/FK → PESSOA

LOCADORA
id_pessoa PK/FK → ORGANIZACAO
```

e:

```text
CLIENTE
id_pessoa PK/FK → PESSOA

CLIENTE_AUTORIZADO
id_pessoa PK/FK → CLIENTE
```

---

# 🔗 Principais chaves estrangeiras

## PESSOA

```text
id_cidade
→ CIDADE.id_cidade
```

## FUNCIONÁRIO

```text
id_locadora
→ LOCADORA.id_pessoa
```

## SETOR

```text
id_locadora
→ LOCADORA.id_pessoa
```

## GERENTE

```text
id_setor
→ SETOR.id_setor
```

## MODELO

```text
id_fabricante
→ FABRICANTE.id_fabricante
```

## VEÍCULO

```text
id_modelo
→ MODELO.id_modelo

id_cor
→ COR.id_cor

id_tipo_propulsao
→ TIPO_DE_PROPULSAO.id_tipo_propulsao

id_proprietario
→ PROPRIETARIO.id_pessoa
```

## LOCAÇÃO

```text
id_cliente
→ CLIENTE.id_pessoa

placa_veiculo
→ VEICULO.placa

id_vendedor
→ VENDEDOR.id_pessoa

id_locadora
→ LOCADORA.id_pessoa
```

---

# 💾 3. Implementação SQL

A implementação foi feita para **PostgreSQL**.

O script contém:

- criação do banco;
- criação das tabelas;
- tipos de dados;
- chaves primárias;
- chaves estrangeiras;
- restrições de unicidade;
- restrições de domínio.

## Banco

```sql
CREATE DATABASE locadora_veiculos;
```

> Depois da criação do banco, os demais comandos devem ser executados já conectados a `locadora_veiculos`.

---

# 🔐 Chaves primárias

Exemplo:

```sql
CREATE TABLE public.cidade (
    id_cidade SERIAL NOT NULL,
    ...
    CONSTRAINT cidade_pkey PRIMARY KEY (id_cidade)
);
```

Algumas entidades utilizam identificadores `SERIAL`.

Já `VEICULO` utiliza a própria placa:

```sql
CONSTRAINT veiculo_pkey PRIMARY KEY (placa)
```

---

# 🔗 Chaves estrangeiras

As chaves estrangeiras foram adicionadas após a criação das tabelas.

Exemplo:

```sql
ALTER TABLE public.pessoa
ADD CONSTRAINT fk_pessoa_cidade
FOREIGN KEY (id_cidade)
REFERENCES public.cidade (id_cidade);
```

Outro exemplo:

```sql
ALTER TABLE public.locacao
ADD CONSTRAINT fk_locacao_veiculo
FOREIGN KEY (placa_veiculo)
REFERENCES public.veiculo (placa);
```

---

# 🛡️ Integridade e unicidade

Foram implementadas restrições para impedir inconsistências.

## Cidade

```sql
UNIQUE (nome, estado)
```

Evita duplicar a mesma cidade dentro do mesmo estado.

## CPF

```sql
UNIQUE (cpf)
```

## CNPJ

```sql
UNIQUE (cnpj)
```

## Matrícula

```sql
UNIQUE (matricula)
```

## Chassi

```sql
UNIQUE (chassi)
```

## Setor

```sql
UNIQUE (nome_setor, id_locadora)
```

Assim, o mesmo nome de setor pode existir em locadoras diferentes, mas não pode se repetir dentro da mesma locadora.

---

# ✅ Regra de condição do veículo

Foi criada uma restrição `CHECK`:

```sql
CHECK (
    condicao IN (
        'Excelente',
        'Muito bom',
        'Bom',
        'Regular',
        'de Colecionador'
    )
)
```

Isso impede a inserção de condições diferentes das previstas no projeto.

---

# 🕐 Campos opcionais

Alguns valores podem não existir no momento do cadastro da operação.

Por exemplo:

```text
LOCAÇÃO
├── quilometragem_final
└── data_hora_devolucao_efetiva
```

podem permanecer nulos enquanto o veículo ainda não foi devolvido.

Da mesma maneira:

```text
MODELO.ano_final_producao
```

pode ser nulo quando o modelo ainda está em produção.

---

# 📊 Consultas que a estrutura permite

Embora o trabalho tenha como foco a modelagem e criação das tabelas, a estrutura permite futuramente consultar, por exemplo:

- proprietários e seus veículos;
- veículos por fabricante;
- veículos por modelo;
- veículos por cor;
- funcionários de cada locadora;
- vendedores;
- gerentes e seus setores;
- histórico de locações de uma pessoa;
- histórico de locações de um veículo;
- locações realizadas por uma locadora;
- valores movimentados;
- pessoas que exercem mais de um papel no sistema;
- veículos de colecionador;
- clientes autorizados para operações especiais.

---

# 🧪 Exemplo conceitual

Considere uma pessoa que:

- possui dois veículos;
- trabalha em uma locadora;
- atua como vendedor;
- já realizou uma locação como cliente.

Ela será cadastrada **uma única vez** em `PESSOA`.

Depois, o mesmo `id_pessoa` poderá aparecer em:

```text
INDIVIDUO
FUNCIONARIO
VENDEDOR
CLIENTE
PROPRIETARIO
```

Cada tabela armazena somente os dados específicos daquele papel.

Isso evita algo como:

```text
CLIENTE
nome
CPF
telefone
email

VENDEDOR
nome
CPF
telefone
email

PROPRIETARIO
nome
CPF
telefone
email
```

que duplicaria as mesmas informações várias vezes.

---

# 🧰 Tecnologias e ferramentas

O projeto utiliza:

- **PostgreSQL** — Sistema Gerenciador de Banco de Dados;
- **SQL** — implementação das tabelas e restrições;
- **pgModeler** — construção/visualização do modelo relacional;
- **DER** — modelagem conceitual;
- **Draw.io / ferramenta equivalente** — construção visual do diagrama conceitual.

---

# 📁 Organização sugerida do repositório

```text
locadora-veiculos/
│
├── README.md
├── codigo.sql
│
├── docs/
│   ├── DER-LocadoraVeiculos.png
│   ├── modelo_relacional.svg
│   └── Roteiro_Apresentacao_Locadora_Veiculos.docx
│
└── README.md
```

Uma versão ainda mais simples:

```text
locadora-veiculos/
├── README.md
├── codigo.sql
├── DER-LocadoraVeiculos.png
├── modelo_relacional.svg
└── Roteiro_Apresentacao_Locadora_Veiculos.docx
```

---

# ▶️ Como executar

## 1. Criar o banco

No PostgreSQL:

```sql
CREATE DATABASE locadora_veiculos;
```

## 2. Conectar ao banco

No `psql`:

```text
\c locadora_veiculos
```

Em ferramentas como pgAdmin ou DBeaver, abra uma conexão ou Query Tool apontando para o banco `locadora_veiculos`.

## 3. Executar o script

Execute:

```text
codigo.sql
```

O script criará as tabelas e adicionará as chaves estrangeiras.

---

# 📦 Entregáveis

O projeto possui três entregáveis principais:

### 1. DER

Representa conceitualmente:

- entidades;
- atributos;
- relacionamentos;
- cardinalidades;
- generalizações;
- especializações.

### 2. Modelo Relacional

Representa:

- tabelas;
- colunas;
- chaves primárias;
- chaves estrangeiras;
- restrições.

### 3. Script SQL

Implementa fisicamente o modelo no PostgreSQL por meio de:

```sql
CREATE TABLE
PRIMARY KEY
FOREIGN KEY
UNIQUE
CHECK
```

---

# 🎯 Principais decisões de modelagem

Durante o desenvolvimento, algumas decisões foram fundamentais:

### Centralizar os dados em PESSOA

Evita cadastrar a mesma pessoa várias vezes.

### Separar INDIVÍDUO e ORGANIZAÇÃO

Permite armazenar corretamente CPF/RG e CNPJ/razão social.

### Tratar CLIENTE e PROPRIETÁRIO como papéis

Permite que uma mesma pessoa exerça os dois papéis simultaneamente.

### Separar VEÍCULO de MODELO

Evita repetir características técnicas para diversos veículos iguais.

### Criar LOCAÇÃO como entidade própria

Permite registrar cada aluguel separadamente, incluindo datas, quilometragem e valor.

### Criar CLIENTE AUTORIZADO

Permite guardar `data_liberacao` apenas para clientes que realmente possuem essa autorização.

---

# 📈 Resultado

O modelo final permite representar de forma consistente:

- pessoas físicas e jurídicas;
- múltiplos papéis para uma mesma pessoa;
- organizações que atuam como locadoras;
- funcionários, vendedores e gerentes;
- setores;
- proprietários;
- veículos e suas características;
- modelos e fabricantes;
- cores;
- tipos de propulsão;
- histórico de locações.

O resultado é um banco estruturado para **reduzir redundância, preservar integridade e facilitar futuras consultas**.

---

# 📚 Conceitos de Banco de Dados aplicados

Durante o projeto foram utilizados conceitos como:

- modelagem conceitual;
- entidade;
- atributo;
- atributo identificador;
- relacionamento;
- cardinalidade;
- generalização;
- especialização;
- herança;
- modelo relacional;
- chave primária;
- chave estrangeira;
- chave única;
- integridade referencial;
- restrições de domínio;
- normalização por separação de informações reutilizáveis.

---

# 🏁 Conclusão

Este projeto mostra o processo completo de construção de um banco de dados:

```text
Problema real
      ↓
Análise dos requisitos
      ↓
DER
      ↓
Modelo Relacional
      ↓
SQL
      ↓
Banco de Dados
```

O ponto central da solução foi modelar corretamente a participação de uma mesma pessoa em diferentes papéis sem duplicar seus dados.

Ao final, o DER, o modelo relacional e o script SQL representam **o mesmo sistema em três níveis diferentes de abstração**, mantendo consistência entre a regra de negócio e sua implementação.

---

<div align="center">

### 🚗 Projeto de Banco de Dados — Locadora de Veículos

**Modelagem conceitual • Modelo relacional • PostgreSQL**

</div>
