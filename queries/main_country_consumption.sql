-- SQLite

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
    AND CustomerID IS NOT NULL
    AND StockCode NOT IN ('POST', 'SAMPLES', 'm', 'M', 'DOT', 'PADS', 'S')
    GROUP BY CustomerID, StockCode, Description, UnitPrice
),

country_summary AS (
    SELECT
        Country,
        COUNT(StockCode) AS total_items,
        COUNT(DISTINCT StockCode) AS unique_items,
        AVG(UnitPrice) AS avg_price,
        SUM(net_quantity * UnitPrice) AS total_revenue,
        (SUM(net_quantity * UnitPrice) * 1.0 / COUNT(CustomerID)) AS ARPU
    FROM net_calculated
    GROUP BY Country
)

SELECT
    Country,
    total_items,
    unique_items,
    ROUND(avg_price, 2) AS avg_price_unit,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(ARPU, 2) AS ARPU
FROM country_summary
ORDER BY total_revenue DESC;

--ARPU (Average Revenue Per Customer) Receita média por cliente.



