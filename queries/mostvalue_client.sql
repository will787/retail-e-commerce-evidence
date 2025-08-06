DROP TABLE IF EXISTS mostvalue_client; --if needed delete or refresh table
CREATE TABLE mostvalue_client AS

WITH global_max_date AS (
    SELECT MAX(InvoiceDate) AS max_date_invoice
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
        avg(InvoiceDate) AS avg_date,
        min(InvoiceDate) AS min_date,
        max(InvoiceDate) AS max_date,
        count(InvoiceDate) AS total_transactions_appear
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
        f.avg_date,
        f.min_date,
        f.max_date,
        (g.max_date_invoice - f.max_date) AS recency,
        f.total_transactions_appear
    FROM filter_values_returned f
    CROSS JOIN global_max_date g
),

client_summary AS (
    SELECT
        CustomerID,
        COUNT(StockCode) AS total_items,
        COUNT(DISTINCT StockCode) AS unique_items,
        AVG(UnitPrice) AS avg_price,
        SUM(net_quantity * UnitPrice) AS total_revenue,
        AVG(avg_date) AS avg_date,
        MIN(min_date) AS min_date,
        MAX(max_date) AS max_date,
        MAX(recency) AS recency,
        SUM(total_transactions_appear) AS total_transactions_appear
    FROM net_calculated
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT
    CustomerID,
    total_items,
    unique_items,
    ROUND(avg_price, 2) AS avg_price_unit,
    total_revenue,
    ROUND(avg_date, 2) AS avg_date,
    ROUND(max_date, 2) AS max_date,
    ROUND(min_date, 2) AS min_date,
    total_transactions_appear,
    recency
FROM client_summary
ORDER BY total_revenue DESC;
