-- SQLite
CREATE TABLE IF NOT EXISTS mostvalue_client AS
WITH client_summary AS (
    SELECT
        CustomerId,
        Count(StockCode) AS total_items,
        Count(DISTINCT StockCode) AS unique_items,
        avg(UnitPrice) AS avg_price,
        SUM(Quantity * UnitPrice) AS Revenue
    FROM transactions
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    CustomerId,
    total_items,
    unique_items,
    ROUND(avg_price, 2) AS avg_price_unit,
    Revenue
FROM client_summary
ORDER BY Revenue DESC;
--client com consumo de produtos mais variados, quero ver a receita, a quantidade, preco medio desses produtos