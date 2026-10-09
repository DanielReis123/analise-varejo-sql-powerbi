USE analise_varejo;
GO

SELECT
    COUNT(*) AS total_linhas,
    SUM(CASE
        WHEN TRY_CONVERT(date, data_pedido, 103) IS NULL
        THEN 1 ELSE 0
    END) AS datas_invalidas,
    SUM(CASE
        WHEN TRY_CONVERT(decimal(18,2),
             REPLACE(receita, ',', '.')) IS NULL
        THEN 1 ELSE 0
    END) AS receitas_invalidas,
    SUM(TRY_CONVERT(decimal(18,2),
        REPLACE(receita, ',', '.'))) AS receita_total
FROM dbo.fato_vendas;