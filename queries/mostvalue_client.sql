--DROP TABLE IF EXISTS mostvalue_client; --if needed delete or refresh table
--CREATE TABLE mostvalue_client AS

WITH filter_values_returned AS (
    SELECT
        CustomerID,
        StockCode,
        Description,
        UnitPrice,
        SUM(CASE WHEN Quantity > 0 THEN Quantity ELSE 0 END) AS total_bought,
        ABS(SUM(CASE WHEN Quantity < 0 THEN Quantity ELSE 0 END)) AS total_returned,
        Country
    FROM transactions
    WHERE Description IS NOT NULL
      AND StockCode NOT IN ('POST', 'SAMPLES', 'm', 'M', 'DOT', 'PADS', 'S')
    GROUP BY CustomerID, StockCode, Description, UnitPrice, Country
),

net_calculated AS (
    SELECT
        CustomerID,
        StockCode,
        Description,
        UnitPrice,
        (SUM(CASE WHEN Quantity > 0 THEN Quantity ELSE 0 END) 
         - ABS(SUM(CASE WHEN Quantity < 0 THEN Quantity ELSE 0 END))) AS net_quantity,
        Country
    FROM transactions
    WHERE Description IS NOT NULL
      AND StockCode NOT IN ('POST', 'SAMPLES', 'm', 'M', 'DOT', 'PADS', 'S')
    GROUP BY CustomerID, StockCode, Description, UnitPrice, Country
),

client_summary AS (
    SELECT
        CustomerID,
        COUNT(StockCode) AS total_items,
        COUNT(DISTINCT StockCode) AS unique_items,
        AVG(UnitPrice) AS avg_price,
        SUM(net_quantity * UnitPrice) AS total_revenue
    FROM net_calculated
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    total_items,
    unique_items,
    ROUND(avg_price, 2) AS avg_price_unit,
    total_revenue
FROM client_summary
ORDER BY total_revenue DESC;
