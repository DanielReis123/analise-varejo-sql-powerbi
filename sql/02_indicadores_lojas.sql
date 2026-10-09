USE analise_varejo;
GO

SELECT
    loja,
    COUNT(DISTINCT pedido_id) AS pedidos,
    SUM(receita) AS receita_total,
    CAST(
        SUM(receita) / NULLIF(COUNT(DISTINCT pedido_id), 0)
        AS decimal(18,2)
    ) AS ticket_medio,
    SUM(lucro_bruto) AS lucro_bruto,
    CAST(
        100.0 * SUM(lucro_bruto) / NULLIF(SUM(receita), 0)
        AS decimal(10,2)
    ) AS margem_bruta_pct
FROM dbo.vw_fato_vendas
GROUP BY loja
ORDER BY receita_total DESC;