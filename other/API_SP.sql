CREATE PROCEDURE get_products_by_sale_price_with_weight
    @min_price DECIMAL(12,4),
    @max_price DECIMAL(12,4),
    @start_date DATETIME,
    @end_date DATETIME
AS
BEGIN
    SELECT DISTINCT p.product_id, p.name, p.kg_to_produce, AVG(l.price) AS average_sale_price
    FROM products p
    INNER JOIN sales s ON s.product_id = p.product_id
    INNER JOIN product_price_log l ON l.product_id = p.product_id
    WHERE l.price BETWEEN @min_price AND @max_price
    AND s.datetime BETWEEN @start_date AND @end_date
    GROUP BY p.product_id, p.name, p.kg_to_produce
END
