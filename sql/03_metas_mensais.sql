USE analise_varejo;
GO

SELECT
    mes,
    loja,
    SUM(receita) AS receita_total,
    CAST(6500 AS decimal(18,2)) AS meta_mensal,
    CAST(
        100.0 * SUM(receita) / 6500
        AS decimal(10,2)
    ) AS atingimento_pct,
    6500 - SUM(receita) AS falta_para_meta
FROM dbo.vw_fato_vendas
GROUP BY mes, loja
ORDER BY atingimento_pct DESC;