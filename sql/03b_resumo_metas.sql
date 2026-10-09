USE analise_varejo;
GO

WITH vendas_mensais AS (
    SELECT
        mes,
        loja,
        SUM(receita) AS receita
    FROM dbo.vw_fato_vendas
    GROUP BY mes, loja
)
SELECT
    COUNT(*) AS combinacoes_loja_mes,
    SUM(CASE WHEN receita >= 6500 THEN 1 ELSE 0 END)
        AS metas_atingidas,
    SUM(receita) AS receita_total,
    COUNT(*) * 6500 AS meta_total,
    COUNT(*) * 6500 - SUM(receita) AS falta_para_meta,
    CAST(
        100.0 * SUM(receita) / (COUNT(*) * 6500)
        AS decimal(10,2)
    ) AS atingimento_pct
FROM vendas_mensais;