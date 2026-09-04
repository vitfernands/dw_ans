# dw_ans

Repositório para Data Warehouse (DW) utilizado para análise de dados disponibilizados pela Agência Nacional de Saúde Suplementar (ANS).

## Fluxo de ELT/ETL

Download das planilhas, disponíveis em: https://dados.gov.br/dados/organizacoes/visualizar/agencia-nacional-de-saude-suplementar → 
Script Python para ingestão na camada Stage do banco de dados PostgreSQL → Tratamento e transformação dos dados utilizando DBT Core →
Consumo com ferramentas de BI para geração de indicadores.

## Tecnologias

- Python
- PostgreSQL
- DBT Core
- Ferramenta de visualização de dados (a combinar)

## Camadas do DW

- Stage → Dados brutos, mantendo os mesmos atributos provenientes das planilhas.
- Trusted → Inicio dos tratamentos de dados, padronização de tipagem e nomenclaturas.
- DW → Camada "Gold", onde são criadas as tabelas "Fato" e "Dimensão" para criação dos indicadores. As ferramentas para criação destes indicadores terão acesso
  unicamente nessa camada.
