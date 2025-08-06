-- SQLite
SELECT
    avg(InvoiceDate) AS avg_date,
    min(InvoiceDate) AS min_date,
    max(InvoiceDate) AS max_date
FROM transactions
WHERE StockCode NOT IN ('POST', 'SAMPLES', 'm', 'M', 'DOT', 'PADS')
AND CustomerID NOT NULL
GROUP BY CustomerID;


-- estudar a parte de RFM, para tentar modelar melhor