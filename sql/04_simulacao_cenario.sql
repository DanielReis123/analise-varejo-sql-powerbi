USE analise_varejo;
GO

DECLARE @aumento_pedidos decimal(9,4) = 0.10;
DECLARE @aumento_ticket decimal(9,4) = 0.05;
DECLARE @meta_anual decimal(18,2) = 234000;

WITH cenario AS (
    SELECT
        SUM(receita) AS receita_atual,
        SUM(receita)
            * (1 + @aumento_pedidos)
            * (1 + @aumento_ticket) AS receita_simulada
    FROM dbo.vw_fato_vendas
)
SELECT
    receita_atual,
    CAST(receita_simulada AS decimal(18,2))
        AS receita_simulada,
    CAST(receita_simulada - receita_atual AS decimal(18,2))
        AS ganho_receita,
    CAST(100.0 * receita_simulada / @meta_anual AS decimal(10,2))
        AS atingimento_simulado_pct,
    CAST(@meta_anual - receita_simulada AS decimal(18,2))
        AS falta_para_meta
FROM cenario;