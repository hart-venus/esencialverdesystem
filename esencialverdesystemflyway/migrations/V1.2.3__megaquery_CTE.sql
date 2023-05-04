WITH SalesInfo AS (
    SELECT
        COALESCE(producers.name, 'TOTAL') as producer,
		COALESCE(products.name, 'TOTAL') as product,
        SUM(product_price_log.price * currencies_dollar_exchange_rate_log.exchange_rate) AS total_dollars
    FROM sales
    JOIN products ON sales.product_id = products.product_id
    JOIN recycling_contracts ON sales.recycling_contract_id = recycling_contracts.recycling_contract_id
    LEFT JOIN service_contracts ON recycling_contracts.service_contract_id = service_contracts.service_contract_id
    JOIN producers ON service_contracts.producer_id = producers.producer_id
    JOIN product_price_log ON product_price_log.product_id = products.product_id and product_price_log.active = 1
    JOIN currencies_dollar_exchange_rate_log ON currencies_dollar_exchange_rate_log.currency_id = product_price_log.currency_id
    WHERE sales.datetime >= '2023-01-01' AND sales.datetime < '2024-01-01' AND sales.sale_id > 2
    GROUP BY ROLLUP (producers.name, products.name)
),
CarbonInfo AS (
    SELECT
		COALESCE(producers.name, 'TOTAL') as producer,
		COALESCE(products.name, 'TOTAL') as product,

        SUM(product_price_log.price * currencies_dollar_exchange_rate_log.exchange_rate) AS total_dollars
    FROM sales
    JOIN products ON sales.product_id = products.product_id
    JOIN recycling_contracts ON sales.recycling_contract_id = recycling_contracts.recycling_contract_id
    LEFT JOIN service_contracts ON recycling_contracts.service_contract_id = service_contracts.service_contract_id
    JOIN producers ON service_contracts.producer_id = producers.producer_id
    JOIN product_price_log ON product_price_log.product_id = products.product_id and product_price_log.active = 1
    JOIN currencies_dollar_exchange_rate_log ON currencies_dollar_exchange_rate_log.currency_id = product_price_log.currency_id
    JOIN carbon_footprint_log ON carbon_footprint_log.producer_id = producers.producer_id and carbon_footprint_log.active = 1
    WHERE sales.datetime >= '2023-01-01' AND sales.datetime < '2024-01-01' AND sales.sale_id > 2
    AND carbon_footprint_log.score > 50
    GROUP BY ROLLUP (producers.name, products.name)
)
SELECT SalesInfo.producer, SalesInfo.product, SalesInfo.total_dollars
FROM SalesInfo
WHERE NOT EXISTS (
    SELECT *
    FROM CarbonInfo
    WHERE CarbonInfo.producer = SalesInfo.producer AND CarbonInfo.product = SalesInfo.product
)

UNION ALL
SELECT CarbonInfo.producer, CarbonInfo.product, CarbonInfo.total_dollars
FROM CarbonInfo
ORDER BY total_dollars DESC
FOR JSON AUTO;
