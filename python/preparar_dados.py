"""Gera dados sintéticos reproduzíveis e prepara um banco SQLite para análise."""
import csv
import random
import sqlite3
from datetime import date, timedelta
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "dados"
random.seed(42)
products = [
    (1, "Café 500g", "Alimentos", 18.9, 10.2),
    (2, "Arroz 5kg", "Alimentos", 27.5, 18.3),
    (3, "Feijão 1kg", "Alimentos", 9.9, 6.1),
    (4, "Leite 1L", "Bebidas", 5.5, 3.7),
    (5, "Suco 1L", "Bebidas", 8.5, 5.2),
    (6, "Refrigerante 2L", "Bebidas", 11.9, 7.0),
    (7, "Detergente", "Limpeza", 3.9, 2.0),
    (8, "Sabão em pó", "Limpeza", 16.9, 9.8),
    (9, "Papel higiênico", "Higiene", 15.9, 8.7),
    (10, "Shampoo", "Higiene", 19.9, 11.3),
]
stores = [(1, "Recife Centro", "Recife"), (2, "Boa Viagem", "Recife"), (3, "Olinda", "Olinda")]


def write_csv(name, header, rows):
    with (DATA / name).open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(rows)


def main():
    DATA.mkdir(exist_ok=True)
    dates = [date(2025, 1, 1) + timedelta(days=i) for i in range(365)]
    orders, items = [], []
    item_id = 0
    for order_id in range(1, 1201):
        day = random.choice(dates)
        store_id = random.choice(stores)[0]
        channel = random.choices(["Loja", "Online"], weights=[75, 25])[0]
        orders.append((order_id, day.isoformat(), store_id, channel))
        for product in random.sample(products, random.randint(1, 4)):
            item_id += 1
            quantity = random.randint(1, 5)
            discount = random.choice([0, 0, 0, 0.05, 0.10, 0.15])
            # Preço e custo são congelados na linha da venda para preservar o histórico.
            items.append((item_id, order_id, product[0], quantity, product[3], product[4], discount))
    goals = [(month, store[0], 6500) for month in range(1, 13) for store in stores]

    write_csv("produtos.csv", ["produto_id", "produto", "categoria", "preco_lista", "custo_referencia"], products)
    write_csv("lojas.csv", ["loja_id", "loja", "cidade"], stores)
    write_csv("pedidos.csv", ["pedido_id", "data_pedido", "loja_id", "canal"], orders)
    write_csv("itens_pedido.csv", ["item_id", "pedido_id", "produto_id", "quantidade", "preco_unitario", "custo_unitario", "desconto_pct"], items)
    write_csv("metas.csv", ["mes", "loja_id", "meta_receita"], goals)

    with sqlite3.connect(DATA / "varejo.db") as conn:
        for table, filename in [("produtos", "produtos.csv"), ("lojas", "lojas.csv"), ("pedidos", "pedidos.csv"), ("itens_pedido", "itens_pedido.csv"), ("metas", "metas.csv")]:
            with (DATA / filename).open(encoding="utf-8-sig", newline="") as f:
                reader = csv.DictReader(f)
                cols = reader.fieldnames
                conn.execute(f'DROP TABLE IF EXISTS {table}')
                conn.execute(f'CREATE TABLE {table} ({", ".join(f"{col} TEXT" for col in cols)})')
                conn.executemany(f'INSERT INTO {table} VALUES ({", ".join("?" for _ in cols)})', ([row[col] for col in cols] for row in reader))
        conn.executescript((ROOT / "sql" / "analises.sql").read_text(encoding="utf-8").split("-- CONSULTAS EXPLORATÓRIAS")[0])
        write_csv("fato_vendas.csv", ["item_id", "pedido_id", "data_pedido", "mes", "loja_id", "loja", "cidade", "canal", "produto_id", "produto", "categoria", "quantidade", "preco_unitario", "custo_unitario", "desconto_pct", "receita", "custo", "lucro_bruto"], conn.execute("SELECT * FROM fato_vendas ORDER BY item_id"))
    print(f"Criados {len(orders)} pedidos, {len(items)} itens e {len(goals)} metas.")


if __name__ == "__main__":
    main()
