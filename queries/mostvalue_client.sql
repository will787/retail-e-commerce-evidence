--DROP TABLE IF EXISTS mostvalue_client; --if needed delete or refresh table
--CREATE TABLE mostvalue_client AS

WITH date_analytics AS (
    SELECT
        CustomerID,
        MIN(InvoiceDate) AS min_date,
        MAX(InvoiceDate) AS max_date,
        AVG(InvoiceDate) AS avg_date
    FROM transactions
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),

filter_values_returned AS (
    SELECT
        CustomerID,
        StockCode,
        Description,
        UnitPrice,
        SUM(CASE WHEN Quantity > 0 THEN Quantity ELSE 0 END) AS total_bought,
        ABS(SUM(CASE WHEN Quantity < 0 THEN Quantity ELSE 0 END)) AS total_returned,
        Country,
        count(InvoiceDate) AS total_days_appear,
        COUNT (DISTINCT InvoiceDate) AS frequency
    FROM transactions
    WHERE Description IS NOT NULL
    AND CustomerID IS NOT NULL
    AND StockCode NOT IN ('POST', 'SAMPLES', 'm', 'M', 'DOT', 'PADS', 'S')
    GROUP BY CustomerID, StockCode, Description, UnitPrice, Country
),

net_calculated AS (
    SELECT
        f.CustomerID,
        f.StockCode,
        f.Description,
        f.UnitPrice,
        (f.total_bought - f.total_returned) AS net_quantity,
        f.Country,
        f.frequency,
        f.total_days_appear
    FROM filter_values_returned f
),

client_summary AS (
    SELECT
        CustomerID,
        Country,
        COUNT(StockCode) AS total_items,
        COUNT(DISTINCT StockCode) AS unique_items,
        ROUND(AVG(UnitPrice), 2) AS avg_price,
        total_days_appear,
        ROUND(SUM(net_quantity * UnitPrice), 2) AS revenue,
        frequency
    FROM net_calculated
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    cs.CustomerID,
    cs.total_items,
    cs.unique_items,
    cs.avg_price,
    cs.revenue,
    cs.frequency,
    cs.Country,
    cs.total_days_appear,
    da.min_date,
    da.max_date,
    da.avg_date
FROM client_summary cs
JOIN date_analytics da
  ON cs.CustomerID = da.CustomerID
ORDER BY cs.revenue DESC;