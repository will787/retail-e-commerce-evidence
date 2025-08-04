--DROP TABLE IF EXISTS mostvalue_client; --if needed delete or refresh table

CREATE TABLE mostvalue_client AS

WITH filter_values_returned AS (
    SELECT
        CustomerID,
        StockCode,
        Description,
        UnitPrice,
        SUM(CASE WHEN Quantity > 0 THEN Quantity ELSE 0 END) AS total_bought,
        ABS(SUM(CASE WHEN Quantity < 0 THEN Quantity ELSE 0 END)) AS total_returned,
        SUM(Quantity) AS net_quantity, 
        SUM(Quantity * UnitPrice) AS total_revenue
    FROM transactions
    WHERE Description IS NOT NULL
    GROUP BY CustomerID, StockCode, Description
),

client_summary AS (
    SELECT
        CustomerID,
        COUNT(StockCode) AS total_items,
        COUNT(DISTINCT StockCode) AS unique_items,
        AVG(UnitPrice) AS avg_price,
        SUM(total_revenue) AS total_revenue
    FROM filter_values_returned
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
