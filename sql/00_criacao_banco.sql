USE master;
GO

IF DB_ID(N'analise_varejo') IS NULL
    EXEC(N'CREATE DATABASE analise_varejo');
GO

USE analise_varejo;
GO

SELECT DB_NAME() AS banco_atual;