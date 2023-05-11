CREATE PROCEDURE fill_tables AS
BEGIN

-- Insert data into the "currencies" table
INSERT INTO currencies (name, symbol)
VALUES ('colon', 'C'),
	   ('dolar estadounidense', '$'),
	   ('euros', 'E'),
	   ('quesomoneda', 'q'),
	   ('rupia', 'R');
-- Insert data into the "countries" table
INSERT INTO countries (name)
VALUES ('United States'), ('Canada'), ('Mexico'), ('Brazil'), ('France'), ('Germany'), ('India'), ('China'), ('Japan');

-- Insert data into the "companies" table
INSERT INTO companies (name, created_at, updated_at, active)
VALUES ('Acme Corporation', '2022-01-01', '2022-01-01', 1),
       ('Widget Industries', '2022-01-01', '2022-01-01', 1),
       ('Globex', '2022-01-01', '2022-01-01', 1),
       ('Initech', '2022-01-01', '2022-01-01', 1),
       ('Umbrella Corporation', '2022-01-01', '2022-01-01', 1);

-- Insert data into the "products" table
INSERT INTO products (name, currency_id, kg_to_produce, created_at, updated_at)
VALUES ('Widget', 1, 10.5, '2022-01-01', '2022-01-01'),
       ('Gizmo', 2, 5.2, '2022-01-01', '2022-01-01'),
       ('Thingamajig', 3, 7.8, '2022-01-01', '2022-01-01'),
       ('Doohickey', 4, 3.6, '2022-01-01', '2022-01-01'),
       ('Whatchamacallit', 5, 2.4, '2022-01-01', '2022-01-01');

-- Insert data into the "regions" table
INSERT INTO regions (name)
VALUES ('North America'), ('South America'), ('Europe'), ('Asia');

-- Insert data into the "companies_have_regions" table
INSERT INTO companies_have_regions (company_id, region_id)
VALUES (1, 1), (2, 1),
       (3, 2), (4, 2), (5, 2),
       (1, 3), (3, 3), (5, 3),
       (1, 4), (4, 4), (5, 4);

-- Insert data into the "region_areas" table
INSERT INTO region_areas (region_id, country_id)
VALUES (1, 1), (1, 2), (1, 3),
       (2, 3), (2, 4),
       (3, 5), (3, 6),
       (4, 7), (4, 8), (4, 9);

END;
