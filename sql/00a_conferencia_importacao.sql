USE analise_varejo;
GO

SELECT COUNT(*) AS total_linhas
FROM dbo.fato_vendas;

SELECT TOP (5) *
FROM dbo.fato_vendas;