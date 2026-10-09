DROP VIEW IF EXISTS fato_vendas;
CREATE VIEW fato_vendas AS
SELECT CAST(i.item_id AS INTEGER) item_id, CAST(p.pedido_id AS INTEGER) pedido_id,
       p.data_pedido, CAST(strftime('%m', p.data_pedido) AS INTEGER) mes,
       CAST(l.loja_id AS INTEGER) loja_id, l.loja, l.cidade, p.canal,
       CAST(pr.produto_id AS INTEGER) produto_id, pr.produto, pr.categoria,
       CAST(i.quantidade AS INTEGER) quantidade,
       CAST(i.preco_unitario AS REAL) preco_unitario,
       CAST(i.custo_unitario AS REAL) custo_unitario,
       CAST(i.desconto_pct AS REAL) desconto_pct,
       ROUND(CAST(i.quantidade AS INTEGER) * CAST(i.preco_unitario AS REAL) * (1 - CAST(i.desconto_pct AS REAL)), 2) receita,
       ROUND(CAST(i.quantidade AS INTEGER) * CAST(i.custo_unitario AS REAL), 2) custo,
       ROUND(CAST(i.quantidade AS INTEGER) * (CAST(i.preco_unitario AS REAL) * (1 - CAST(i.desconto_pct AS REAL)) - CAST(i.custo_unitario AS REAL)), 2) lucro_bruto
FROM itens_pedido i
JOIN pedidos p ON p.pedido_id = i.pedido_id
JOIN produtos pr ON pr.produto_id = i.produto_id
JOIN lojas l ON l.loja_id = p.loja_id;

-- CONSULTAS EXPLORATÓRIAS
-- Execute cada SELECT separadamente depois de gerar o banco.
-- 1. KPIs gerais: COUNT DISTINCT impede contar cada item como um pedido.
SELECT ROUND(SUM(receita), 2) receita, ROUND(SUM(lucro_bruto), 2) lucro_bruto,
       ROUND(100.0 * SUM(lucro_bruto) / NULLIF(SUM(receita), 0), 1) margem_pct,
       COUNT(DISTINCT pedido_id) pedidos,
       ROUND(SUM(receita) / NULLIF(COUNT(DISTINCT pedido_id), 0), 2) ticket_medio
FROM fato_vendas;

-- 2. Receita e margem por categoria.
SELECT categoria, ROUND(SUM(receita), 2) receita,
       ROUND(SUM(lucro_bruto), 2) lucro_bruto,
       ROUND(100.0 * SUM(lucro_bruto) / NULLIF(SUM(receita), 0), 1) margem_pct
FROM fato_vendas GROUP BY categoria ORDER BY receita DESC;

-- 3. Realizado versus meta na mesma granularidade (mês e loja).
WITH realizado AS (
 SELECT mes, loja_id, ROUND(SUM(receita), 2) receita
 FROM fato_vendas GROUP BY mes, loja_id
)
SELECT m.mes, l.loja, COALESCE(r.receita, 0) receita,
       CAST(m.meta_receita AS REAL) meta_receita,
       ROUND(COALESCE(r.receita, 0) / NULLIF(CAST(m.meta_receita AS REAL), 0) * 100, 1) atingimento_pct
FROM metas m JOIN lojas l ON l.loja_id = m.loja_id
LEFT JOIN realizado r ON r.mes = CAST(m.mes AS INTEGER) AND r.loja_id = CAST(m.loja_id AS INTEGER)
ORDER BY CAST(m.mes AS INTEGER), l.loja;

-- 4. Evolução mensal por canal.
SELECT mes, canal, ROUND(SUM(receita), 2) receita, COUNT(DISTINCT pedido_id) pedidos
FROM fato_vendas GROUP BY mes, canal ORDER BY mes, canal;
