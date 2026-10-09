USE analise_varejo;
GO

CREATE OR ALTER VIEW dbo.vw_fato_vendas AS
SELECT
    CONVERT(int, item_id) AS item_id,
    CONVERT(int, pedido_id) AS pedido_id,
    CONVERT(date, data_pedido, 103) AS data_pedido,
    CONVERT(int, mes) AS mes,
    CONVERT(int, loja_id) AS loja_id,
    loja,
    cidade,
    canal,
    CONVERT(int, produto_id) AS produto_id,
    produto,
    categoria,
    CONVERT(int, quantidade) AS quantidade,
    CONVERT(decimal(18,2),
        REPLACE(preco_unitario, ',', '.')) AS preco_unitario,
    CONVERT(decimal(18,2),
        REPLACE(custo_unitario, ',', '.')) AS custo_unitario,
    CONVERT(decimal(9,4),
        REPLACE(desconto_pct, ',', '.')) AS desconto_pct,
    CONVERT(decimal(18,2),
        REPLACE(receita, ',', '.')) AS receita,
    CONVERT(decimal(18,2),
        REPLACE(custo, ',', '.')) AS custo,
    CONVERT(decimal(18,2),
        REPLACE(lucro_bruto, ',', '.')) AS lucro_bruto
FROM dbo.fato_vendas;
GO

SELECT
    COUNT(*) AS linhas,
    COUNT(DISTINCT pedido_id) AS pedidos,
    SUM(quantidade) AS itens_vendidos,
    SUM(receita) AS receita_total,
    SUM(custo) AS custo_total,
    SUM(lucro_bruto) AS lucro_bruto_total
FROM dbo.vw_fato_vendas;