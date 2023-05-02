(SELECT
producers.name as producer,
products.name as product,
SUM(product_price_log.price * currencies_dollar_exchange_rate_log.exchange_rate) AS total_dollars

FROM sales
JOIN products ON sales.product_id = products.product_id
JOIN recycling_contracts ON sales.recycling_contract_id = recycling_contracts.recycling_contract_id
JOIN service_contracts ON recycling_contracts.service_contract_id = service_contracts.service_contract_id
JOIN producers ON service_contracts.producer_id = producers.producer_id
LEFT JOIN product_price_log ON product_price_log.product_id = products.product_id and product_price_log.active = 1
JOIN currencies_dollar_exchange_rate_log ON currencies_dollar_exchange_rate_log.currency_id = product_price_log.currency_id and sales.datetime between currencies_dollar_exchange_rate_log.start_date and currencies_dollar_exchange_rate_log.end_date
WHERE producers.producer_id > 10 AND sales.datetime BETWEEN '2023-01-01' AND '2024-12-31'
GROUP BY producers.name, products.name)

EXCEPT

(SELECT
producers.name as producer,
null as product,
null as total_dollars
FROM producers
LEFT JOIN carbon_footprint_log ON carbon_footprint_log.producer_id = producers.producer_id
WHERE carbon_footprint_log.active = 1 and carbon_footprint_log.score > 50)

ORDER BY total_dollars DESC

FOR JSON AUTO;
