USE [esencialverdesystem]
GO

SELECT
co.name AS country,
pr.name AS company,
tt.name AS trashType,
SUM(ppl.price) AS totalCollected,
SUM(ppl.price * i.invoice_amount) AS totalCostProcessed,
SUM(ppl.price * 1.20) - SUM(ppl.price) AS profit
FROM
producers pr
INNER JOIN invoices i ON pr.producer_id = i.producer_id
INNER JOIN countries co ON pr.country_id = co.country_id
INNER JOIN trash_types tt ON i.trash_type_id = tt.trash_type_id
INNER JOIN product_price_log ppl ON co.country_id = ppl.country_id
GROUP BY
co.name,
pr.name,
tt.name;