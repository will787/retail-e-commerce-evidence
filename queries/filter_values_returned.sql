-- SQLite
SELECT
    CustomerID,
    StockCode,
    Description,
    SUM(CASE WHEN Quantity > 0 THEN Quantity ELSE 0 END) AS total_bought,
    ABS(SUM(CASE WHEN Quantity < 0 THEN Quantity ELSE 0 END)) AS total_returned,
    SUM(Quantity) as net_quantity, 
    UnitPrice,
    SUM(Quantity * UnitPrice) AS total_revenue
FROM transactions
WHERE Description IS NOT NULL
GROUP BY CustomerID, StockCode, Description
ORDER BY CustomerID, StockCode DESC;

-- this SQL can be used as default for the future analytics, in the revenue projections etc.
--here im filtering for analytics whats product is being deliverable to ecommerce (returned)