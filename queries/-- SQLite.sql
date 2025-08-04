-- SQLite
SELECT * 
FROM transactions
ORDER BY StockCode DESC;


--WHERE Description IS NOT NULL
--WHERE StockCode IN ('POST', 'SAMPLES', 'm', 'M', 'DOT', 'PADS')

--PADS parece ser items de trabeceiros
-- DCGDDGIRL - Pacote de doces de festa de meninas
-- DCGSSBOY - Pacote de doces de festa de meninos
-- DCG0076 - Luminaria Noturna
-- BANK CHARGES - Encargos bancários 

-- analisar se a organizacao dos StockCOde fez com que as subissem
-- essa base mostra tanto valores de venda quanto de devolucao de items
    -- Como exemplo este CustomerID 14911.0



-- criacao de um filtro para uma classificacao de items que foram comprados (nao sendo estornados)
-- e que também bem sao consumidos com certa periodicidade, por exemplo comprar pao, ou items de festa de aniversário.


-- politica de devolucao de uso, devolvendo com uma taxa mais alta.
-- analisar essa situacao do CustomerID 17837.0 (onde ele compra 18 e devolve 4)



-- entao dentro dessas devolucoes podem ter:
-- Casos em que devolve tudo fica no O=0
-- Casos que devolve parcialmente ver se tem alguma taxa