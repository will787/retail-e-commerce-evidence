--DROP TABLE IF EXISTS mostvalue_client; --if needed delete or refresh table
--CREATE TABLE mostvalue_client AS

WITH global_max_date AS (
    SELECT 
    MAX(InvoiceDate) AS max_date_invoice
    FROM transactions
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
        avg(InvoiceDate) AS avgseasonality_date, -- which is the average purchase date
        min(InvoiceDate) AS firstpurchase_date, -- which is the first purchase date
        max(InvoiceDate) AS lastpurchase_date, -- which is the last purchase date
        count(InvoiceDate) AS total_transactions_appear,
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
        f.total_bought - f.total_returned AS net_quantity,
        f.Country,
        f.avgseasonality_date,
        f.firstpurchase_date,
        f.lastpurchase_date,
        (g.max_date_invoice - f.lastpurchase_date) AS recency,
        f.frequency,
        f.total_transactions_appear
    FROM filter_values_returned f
    CROSS JOIN global_max_date g
),

client_summary AS (
    SELECT
        CustomerID,
        Country,
        COUNT(StockCode) AS total_items,
        COUNT(DISTINCT StockCode) AS unique_items,
        ROUND(AVG(UnitPrice), 2) AS avg_price,
        SUM(total_transactions_appear) AS total_transactions_appear,
        ROUND(SUM(net_quantity * UnitPrice), 2) AS revenue,
        MAX(recency) AS recency,
        frequency,
        avgseasonality_date,
        firstpurchase_date,
        lastpurchase_date
    FROM net_calculated
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    total_items,
    unique_items,
    avg_price,
    revenue,
    recency,
    frequency,
    ROUND(avgseasonality_date, 2) AS avgseasonality_date,
    ROUND(firstpurchase_date, 2) AS firstpurchase_date,
    ROUND(lastpurchase_date, 2) AS lastpurchase_date,
    Country
FROM client_summary
ORDER BY revenue DESC;
