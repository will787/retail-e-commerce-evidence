-- SQLite
SELECT
    StockCode,
    Quantity,
    UnitPrice,
    (Quantity * UnitPrice) AS Revenue
FROM transactions
GROUP BY StockCode
ORDER BY Quantity DESC;

-- Main item sales in the world;