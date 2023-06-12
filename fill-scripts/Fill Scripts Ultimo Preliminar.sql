
INSERT INTO currencies (name, symbol)
VALUES ('US Dollar', '$');

INSERT INTO currencies (name, symbol)
VALUES ('Euro', '€');

INSERT INTO currencies (name, symbol)
VALUES ('British Pound', '£');

INSERT INTO currencies (name, symbol)
VALUES ('Japanese Yen', '¥');

INSERT INTO currencies (name, symbol)
VALUES ('Brazilian Real', 'R$');

-- Insert more rows as needed


INSERT INTO countries (name)
VALUES ('United States');

INSERT INTO countries (name)
VALUES ('Canada');

INSERT INTO countries (name)
VALUES ('United Kingdom');

INSERT INTO countries (name)
VALUES ('Germany');

INSERT INTO countries (name)
VALUES ('France');

INSERT INTO countries (name)
VALUES ('Australia');

INSERT INTO countries (name)
VALUES ('Japan');

INSERT INTO countries (name)
VALUES ('Brazil');

INSERT INTO countries (name)
VALUES ('India');

INSERT INTO countries (name)
VALUES ('South Africa');


INSERT INTO producer_parents (name)
VALUES ('McDonald''s');

INSERT INTO producer_parents (name)
VALUES ('Starbucks');

INSERT INTO producer_parents (name)
VALUES ('Coca-Cola');

INSERT INTO producer_parents (name)
VALUES ('Nestlé');

INSERT INTO producer_parents (name)
VALUES ('Amazon');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (1, 1, 'McDonald''s');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (2, 2, 'Starbucks');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (3, 3, 'Coca-Cola');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (4, 4, 'Nestlé');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (5, 5, 'Amazon');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (6, 6, 'McDonald''s');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (7, 7, 'Starbucks');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (8, 8, 'Coca-Cola');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (9, 9, 'Nestlé');

INSERT INTO producers (producer_parent_id, country_id, name)
VALUES (10, 10, 'Amazon');

-- Insert more rows as needed


INSERT INTO invoices (producer_id, invoice_number, invoice_date, invoice_due_date, checksum, invoice_amount, currency_id, trash_type_id)
VALUES (10, 'INV-001', '2023-06-01', '2023-06-30', 0x1234567890abcdef, 1000.00, 1, 1);

INSERT INTO invoices (producer_id, invoice_number, invoice_date, invoice_due_date, checksum, invoice_amount, currency_id, trash_type_id)
VALUES (11, 'INV-002', '2023-06-02', '2023-07-02', 0xabcdef1234567890, 1500.00, 1, 2);

-- Insert more rows
INSERT INTO invoices (producer_id, invoice_number, invoice_date, invoice_due_date, checksum, invoice_amount, currency_id, trash_type_id)
VALUES (12, 'INV-003', '2023-06-05', '2023-07-05', 0x9876543210fedcba, 2000.00, 2, 3);

INSERT INTO invoices (producer_id, invoice_number, invoice_date, invoice_due_date, checksum, invoice_amount, currency_id, trash_type_id)
VALUES (13, 'INV-004', '2023-06-10', '2023-07-10', 0xa1b2c3d4e5f6, 1200.00, 1, 1);

-- Assuming you have existing data in the 'producers', 'currencies', and 'trash_types' tables

-- Inserting invoices for Producer 13
INSERT INTO invoices (producer_id, invoice_number, invoice_date, invoice_due_date, checksum, invoice_amount, currency_id, trash_type_id)
VALUES (14, 'INV-20230001', '2023-06-01', '2023-06-30', 0x1234567890abcdef, 1500.00, 1, 1);

INSERT INTO invoices (producer_id, invoice_number, invoice_date, invoice_due_date, checksum, invoice_amount, currency_id, trash_type_id)
VALUES (15, 'INV-20230002', '2023-06-05', '2023-07-05', 0xabcdef1234567890, 2000.00, 1, 2);

INSERT INTO invoices (producer_id, invoice_number, invoice_date, invoice_due_date, checksum, invoice_amount, currency_id, trash_type_id)
VALUES (6, 'INV-20230003', '2023-06-10', '2023-07-10', 0x0123456789abcdef, 1800.00, 2, 3);

INSERT INTO invoices (producer_id, invoice_number, invoice_date, invoice_due_date, checksum, invoice_amount, currency_id, trash_type_id)
VALUES (8, 'INV-20230004', '2023-06-15', '2023-07-15', 0xabcdef0123456789, 2500.00, 2, 1);

-- Insert more rows as needed


INSERT INTO products (name, kg_to_produce)
VALUES ('Recycled Paper', 0.1);

INSERT INTO products (name, kg_to_produce)
VALUES ('Recycled Plastic Bags', 0.05);

INSERT INTO products (name, kg_to_produce)
VALUES ('Recycled Glass Bottles', 0.3);

INSERT INTO products (name, kg_to_produce)
VALUES ('Recycled Aluminum Cans', 0.15);

INSERT INTO products (name, kg_to_produce)
VALUES ('Recycled Cardboard Boxes', 0.2);

INSERT INTO products (name, kg_to_produce)
VALUES ('Recycled Plastic Furniture', 5.0);

INSERT INTO products (name, kg_to_produce)
VALUES ('Recycled Glassware', 0.4);

INSERT INTO products (name, kg_to_produce)
VALUES ('Recycled Metal Art', 2.0);

-- Insert more rows as needed


-- Assuming you have existing data in the 'products', 'countries', and 'currencies' tables

-- Inserting prices for Product 1 in different countries
-- Inserting prices for Product 3 in different countries
INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 1, 20.50, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 2, 25.00, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 3, 18.75, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 4, 22.99, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 5, 19.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 6, 21.50, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 7, 23.75, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 8, 17.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 9, 20.50, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (3, 10, 24.99, 2);


-- Inserting prices for Product 4 in different countries
INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 1, 15.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 2, 19.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 3, 16.50, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 4, 14.99, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 5, 18.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 6, 17.50, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 7, 15.75, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 8, 19.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 9, 16.50, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (4, 10, 14.99, 2);


-- Inserting prices for Product 5 in different countries
INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 1, 8.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 2, 12.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 3, 10.50, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 4, 9.99, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 5, 11.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 6, 9.50, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 7, 12.75, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 8, 10.99, 1);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 9, 8.50, 2);

INSERT INTO product_price_log (product_id, country_id, price, currency_id)
VALUES (5, 10, 11.99, 2);

-- Insert more rows as needed


