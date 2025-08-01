-- SQLite
SELECT
    Country,
    SUM(Quantity * UnitPrice) AS Revenue,
    COUNT(CustomerID) AS Qtd_Consumer,
    (SUM(Quantity * UnitPrice) * 1.0 / COUNT(CustomerID)) AS ARPU
FROM transactions
GROUP BY Country
ORDER BY ARPU DESC;

--ARPU (Average Revenue Per Customer) Receita média por cliente.