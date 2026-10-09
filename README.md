# Análise de Vendas e Metas no Varejo — 2025

**Autor:** Daniel Cardoso Reis  
**Ferramentas:** SQL Server, SQLite, Python, Power BI, Power Query, DAX e Excel.

Projeto de portfólio com **dados fictícios**, desenvolvido para analisar o desempenho de três lojas, comparar receitas com metas e apoiar decisões por meio de indicadores e cenários.

## Problema de negócio

Quanto as lojas realizaram da meta de receita em 2025? Onde estão as maiores diferenças de desempenho e quais ações poderiam ser testadas para reduzir a distância até a meta, preservando a margem?

A análise identificou a diferença entre resultado e objetivo. Os dados disponíveis não permitem determinar a causa dessa diferença.

## Dados e escopo

- Período: janeiro a dezembro de 2025.
- Lojas: Boa Viagem, Olinda e Recife Centro.
- Base de vendas: 3.030 linhas, 18 campos e 1.200 pedidos distintos.
- Granularidade: uma linha por item de pedido; um pedido pode ocupar várias linhas.
- Quantidade vendida: 9.118 unidades.
- Meta adotada: R$ 6.500 por loja por mês, totalizando R$ 234.000 no ano.

Os campos incluem pedido, data, mês, loja, canal, produto, categoria, quantidade, preços, desconto, receita, custo e lucro bruto. A tabela de metas contém 36 combinações de loja e mês.

## Método e ferramentas

**Python e SQLite:** o script `python/preparar_dados.py` gera dados fictícios com semente 42, exporta CSVs e cria o banco SQLite `dados/varejo.db`. A view em `sql/analises.sql` utiliza JOINs entre itens, pedidos, produtos e lojas para construir a base de vendas. As consultas exploratórias também usam LEFT JOIN e COALESCE para comparar metas com vendas.

**SQL Server:** conferência da importação, validação de conversão de datas e receitas, criação de uma view com tipos adequados, cálculo de indicadores por loja, comparação com metas e simulação de cenário.

Os scripts utilizam agregações, COUNT DISTINCT, CASE, TRY_CONVERT, CONVERT, REPLACE, NULLIF, CTEs, variáveis e uma view.

**Power Query:** ajuste dos tipos de dados e tratamento dos números com a localidade adequada para interpretar o separador decimal.

**Power BI e DAX:** medidas de receita, meta, atingimento e distância até a meta; filtros por loja; comparação mensal; indicadores por categoria; parâmetros para explorar cenários.

O modelo utiliza as dimensões **Lojas** e **Meses** relacionadas às tabelas de vendas e metas, com relações de um para muitos. Os parâmetros de cenário são independentes das tabelas de fatos.

Neste projeto, o Power BI utiliza a fonte em Excel. Os scripts SQL complementam a análise e a conferência dos resultados; não representam uma conexão direta do relatório ao SQL Server.

## Principais resultados

| Indicador | Resultado |
|---|---:|
| Receita anual | R$ 122.314,18 |
| Meta anual | R$ 234.000,00 |
| Atingimento | 52,27% |
| Distância até a meta | R$ 111.685,82 |
| Pedidos distintos | 1.200 |
| Ticket médio | R$ 101,93 |
| Custo dos produtos | R$ 76.371,60 |
| Lucro bruto | R$ 45.941,74 |
| Margem bruta | 37,56% |
| Combinações de loja e mês que atingiram a meta | 0 de 36 |

O lucro bruto considera receita menos custo dos produtos. Não equivale ao lucro líquido: despesas operacionais, impostos e outros gastos não foram incluídos.

### Comparação entre lojas

| Loja | Pedidos | Receita | Ticket médio | Margem bruta | Atingimento da meta anual |
|---|---:|---:|---:|---:|---:|
| Olinda | 431 | R$ 44.367,37 | R$ 102,94 | 37,36% | 56,88% |
| Recife Centro | 396 | R$ 41.083,92 | R$ 103,75 | 37,41% | 52,67% |
| Boa Viagem | 373 | R$ 36.862,89 | R$ 98,83 | 37,96% | 47,26% |

Cada loja possui uma meta anual de R$ 78.000.

## Insights e ações propostas

### 1. Boa Viagem é uma prioridade para testes de crescimento

Boa Viagem apresentou a menor receita, o menor número de pedidos e o menor ticket médio. Sua margem bruta, porém, foi a maior das três lojas.

**Ação proposta:** testar uma campanha local com orçamento limitado, evitando descontos amplos antes de avaliar seus efeitos.

**Como avaliar:** acompanhar pedidos incrementais, custo da campanha e lucro bruto incremental, usando um grupo de comparação adequado. Um teste com distribuição aleatória, quando viável, ajuda a estimar o efeito da ação.

**Limite:** menor volume de pedidos não comprova baixo tráfego ou baixa conversão. Faltam dados de visitantes, disponibilidade de produtos e campanhas.

### 2. Crescer moderadamente ainda deixa uma distância relevante até a meta

A receita anual atingiu 52,27% do objetivo. O cenário de crescimento apresentado abaixo melhora o resultado, mas ainda não alcança a meta.

**Ação proposta:** planejar testes em etapas e avaliar sua contribuição real antes de assumir que uma única campanha resolverá a diferença.

**Como avaliar:** receita incremental, margem, custo das ações e distância restante até o objetivo.

### 3. As premissas da meta merecem revisão

Nenhuma das 36 combinações de loja e mês alcançou R$ 6.500. O melhor resultado foi Olinda em março: R$ 5.386,67, equivalente a 82,87% da meta.

**Ação proposta:** revisar o processo de definição de metas com histórico de outros anos, capacidade operacional, sazonalidade e potencial de cada loja.

Esse resultado é um sinal para investigar as premissas; não prova que a meta seja inadequada.

### 4. Alimentos concentra a maior parcela da receita

Alimentos gerou R$ 51.772,88, aproximadamente 42,33% da receita total, seguido por Higiene, Bebidas e Limpeza.

**Ação proposta:** testar ofertas de produtos complementares para aumentar itens por pedido e ticket médio, acompanhando a margem.

Participação em receita não identifica, por si só, a categoria mais lucrativa. É necessário analisar também custos e margens por categoria e produto.

## Simulação de cenário

Hipóteses: aumento de **10% nos pedidos** e de **5% no ticket médio**.

Como receita = pedidos × ticket médio:

    Receita simulada = Receita atual × 1,10 × 1,05
    Receita simulada = R$ 122.314,18 × 1,155

Os fatores combinados representam crescimento de **15,5%**.

| Indicador | Cenário |
|---|---:|
| Receita simulada | R$ 141.272,88 |
| Ganho de receita | R$ 18.958,70 |
| Atingimento da meta | 60,37% |
| Distância restante até a meta | R$ 92.727,12 |

É uma simulação condicional, não uma previsão. Ela não estima a probabilidade de crescimento e não incorpora custos de campanha, alterações na margem, capacidade ou resposta da demanda.

## Tipo de análise

- **Descritiva e comparativa:** mostra o resultado, sua evolução e as diferenças entre lojas.
- **Exploratória:** identifica pontos que merecem investigação.
- **Simulação de cenários:** calcula o resultado caso determinadas hipóteses se concretizem.
- **Recomendações para testes:** propõe ações e métricas para avaliar seus efeitos.

O projeto não estabelece causas nem utiliza um modelo estatístico de previsão.

## Dashboard

O relatório possui quatro páginas:

1. **Visão geral:** receita, metas, atingimento, distância até a meta, evolução mensal e categorias.
2. **Diagnóstico:** comparação de pedidos, ticket e margem entre lojas.
3. **Cenários:** parâmetros de crescimento e comparação entre receita atual, simulada e meta.
4. **Recomendações:** prioridades, testes propostos e limitações dos dados.

O PDF apresenta uma versão estática. Os filtros e parâmetros interativos estão disponíveis no arquivo Power BI.

O arquivo `power_bi/medidas.dax` é uma referência inicial de medidas; o `.pbix` contém o relatório final.

## Scripts SQL

| Arquivo | Finalidade |
|---|---|
| 00_criacao_banco.sql | Criar ou selecionar o banco analise_varejo |
| 00a_conferencia_importacao.sql | Conferir quantidade de linhas e amostra |
| 00b_validacao_dados.sql | Verificar conversões de data e receita |
| 01_tratamento_dados.sql | Criar vw_fato_vendas e conferir totais |
| 02_indicadores_lojas.sql | Calcular receita, pedidos, ticket e margem |
| 03_metas_mensais.sql | Comparar receita mensal por loja com a meta |
| 03b_resumo_metas.sql | Consolidar metas e atingimento anual |
| 04_simulacao_cenario.sql | Simular alterações em pedidos e ticket |

SQLQuery7.sql contém a mesma consulta de 03b_resumo_metas.sql e pode ser omitido da organização do portfólio.

## Como reproduzir

### Python e SQLite

Na pasta principal, execute:

```bash
python python/preparar_dados.py
```

O script usa apenas a biblioteca padrão do Python. Ele recria os CSVs e as tabelas do SQLite; execute em uma cópia caso tenha alterado os dados. A geração não atualiza automaticamente a planilha Excel, o CSV de importação do SQL Server ou o relatório Power BI.

`sql/analises.sql` utiliza sintaxe SQLite e deve ser executado nesse banco. Os scripts numerados utilizam T-SQL e devem ser executados no SQL Server.

Nesta revisão, o script Python foi executado e produziu 1.200 pedidos, 3.030 itens e 36 metas. A receita foi reconciliada com a base de importação do SQL Server: R$ 122.314,18. O CSV `fato_vendas.csv`, que estava vazio, foi regenerado.


### SQL Server

1. Abra o SQL Server Management Studio e execute 00_criacao_banco.sql.
2. Importe `dados/fato_vendas_sql.csv` no banco analise_varejo como **dbo.fato_vendas**. Os scripts não criam nem importam essa tabela.
3. Preserve os 18 nomes de campos usados pela view. Na importação utilizada no projeto, os campos de origem foram carregados como texto; a view realiza as conversões.
4. Confira o separador do arquivo e os valores de data e números antes de concluir a importação.
5. Execute os demais scripts na ordem apresentada na tabela.
6. Compare os resultados com os totais deste README.

As datas são interpretadas com o estilo 103, correspondente a dia/mês/ano. Os campos numéricos substituem vírgula por ponto antes da conversão.

O projeto foi desenvolvido com SQL Server 2022. Os scripts foram revisados para esta documentação; não foram novamente executados em um servidor SQL nesta revisão.

### Power BI

1. Abra o arquivo .pbix e ajuste os caminhos das fontes para os arquivos locais.
2. Confira os tipos de dados e a localidade nas etapas do Power Query.
3. Atualize o relatório.
4. Sem filtros, confira receita de R$ 122.314,18, meta de R$ 234.000 e atingimento de aproximadamente 52,3%.
5. Filtre Boa Viagem: receita de R$ 36.862,89 e meta anual de R$ 78.000.
6. Na página de cenários, selecione 10% para pedidos e 5% para ticket e confira os resultados da simulação.

## Definições dos indicadores

| Indicador | Cálculo |
|---|---|
| Receita total | Soma de receita |
| Pedidos | Contagem distinta de pedido_id |
| Ticket médio | Receita ÷ pedidos distintos |
| Lucro bruto | Receita − custo dos produtos |
| Margem bruta | Lucro bruto ÷ receita |
| Atingimento | Receita ÷ meta |
| Distância até a meta | Meta − receita |

No SQL, os percentuais são multiplicados por 100. No Power BI, as medidas podem retornar a razão decimal e utilizar a formatação percentual.

## Limitações e próximos desenvolvimentos

- Base fictícia e limitada a 2025: os resultados não descrevem uma empresa real.
- Sem tráfego, conversão, rupturas de estoque, despesas e histórico de campanhas: não é possível comprovar as causas das diferenças.
- A validação SQL atual verifica datas e receitas; uma rotina mais ampla deve conferir todos os tipos, valores ausentes, duplicidades e regras de negócio.
- A view utiliza CONVERT e falha se encontrar valores inválidos. Esses registros precisam ser investigados antes de reutilizar o fluxo.
- As metas SQL estão fixadas nos scripts. Uma evolução é utilizar uma tabela de metas e incluir combinações sem vendas.
- O resumo SQL conta combinações de loja e mês presentes nas vendas. Nesta base são 36; em outra base, meses sem vendas poderiam ser omitidos.
- O campo mês é suficiente para este recorte de um ano. Uma evolução para vários anos exige calendário e identificação de ano e mês.

## Organização sugerida para publicação

    README.md
    sql/
        00_criacao_banco.sql
        00a_conferencia_importacao.sql
        00b_validacao_dados.sql
        01_tratamento_dados.sql
        02_indicadores_lojas.sql
        03_metas_mensais.sql
        03b_resumo_metas.sql
        04_simulacao_cenario.sql
    dados/
        arquivos de origem utilizados
    python/
        preparar_dados.py
    power_bi/
        analise_varejo.pbix
        analise_varejo.pdf

Inclua os arquivos de origem para permitir a reprodução. O PDF pode ser renomeado para analise_varejo.pdf ao organizar a pasta.

## Apresentação do projeto

Desenvolvi uma análise de vendas e metas de três lojas com dados fictícios, utilizando Python, SQLite, SQL Server e Power BI. O projeto identificou atingimento anual de 52,3%, comparou pedidos, ticket e margem por loja e simulou um crescimento combinado de 15,5% na receita. As recomendações propõem testes mensuráveis e distinguem resultados observados, hipóteses e limitações dos dados.
