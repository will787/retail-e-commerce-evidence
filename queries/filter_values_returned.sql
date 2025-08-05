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
      AND StockCode NOT IN ('POST', 'SAMPLES', 'm', 'M', 'DOT', 'PADS', 'S')
    GROUP BY CustomerID, StockCode, Description, UnitPrice, Country
)

SELECT * FROM net_calculated;

-- this SQL can be used as default for the future analytics, in the revenue projections etc.
--here im filtering for analytics whats product is being deliverable to ecommerce (returned)