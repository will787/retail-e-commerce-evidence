-- SQLite
WITH table_1 AS (
    SELECT
        CustomerId,
        Count (StockCode) AS total_items,
        Count (DISTINCT StockCode) AS unique_items,
        avg (UnitPrice) AS avg_price,
        (Quantity * UnitPrice) AS Revenue
    FROM transactions
    GROUP BY CustomerID
    ORDER BY Revenue DESC
)

SELECT
    CustomerId,
    total_items,
    unique_items,
    ROUND(avg_price, 2) AS avg_price_unit,
    Revenue
FROM table_1;

--client com consumo de produtos mais variados, quero ver a receita, a quantidade, preco medio desses produtos