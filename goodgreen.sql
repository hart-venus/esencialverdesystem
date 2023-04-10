-- create currency table
DROP TABLE IF EXISTS currencies;
CREATE TABLE currencies (
    currency_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (currency_id)
);
-- currencies_dollar_exchange_rate_log
DROP TABLE IF EXISTS currencies_dollar_exchange_rate_log;
CREATE TABLE currencies_dollar_exchange_rate_log (
    currency_dollar_exchange_rate_log_id INT NOT NULL IDENTITY(1,1),
    currency_id INT NOT NULL,
    exchange_rate DECIMAL(10,3) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1,
    hash varbinary(64) NOT NULL DEFAULT HASHBYTES('SHA2_256', NEWID()),
    PRIMARY KEY (currency_dollar_exchange_rate_log_id),
    FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
);

-- create province table
DROP TABLE IF EXISTS provinces;
CREATE TABLE provinces (
    province_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (province_id)
);

-- create city table
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    city_id INT NOT NULL IDENTITY(1,1),
    province_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (city_id),
    FOREIGN KEY (province_id) REFERENCES provinces(province_id)
);

-- create zipcodes table with foreign key
DROP TABLE IF EXISTS zipcodes;
CREATE TABLE zipcodes (
    zipcode_id INT NOT NULL IDENTITY(1,1),
    city_id INT NOT NULL,
    zipcode VARCHAR(50) NOT NULL,
    PRIMARY KEY (zipcode_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- create location table with foreign key and point
DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
    location_id INT NOT NULL IDENTITY(1,1),
    zipcode_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    coordinates GEOMETRY NOT NULL,
    PRIMARY KEY (location_id),
    FOREIGN KEY (zipcode_id) REFERENCES zipcodes(zipcode_id)
);

-- create contact_info table
DROP TABLE IF EXISTS contact_info;
CREATE TABLE contact_info (
    contact_info_id INT NOT NULL IDENTITY(1,1),
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (contact_info_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    hash varbinary(64) NOT NULL DEFAULT HASHBYTES('SHA2_256', NEWID())
);

-- create a producer_parent table with contact_info
DROP TABLE IF EXISTS producer_parents; -- big companies like kfc, mcdonalds, etc
CREATE TABLE producer_parents (
    producer_parent_id INT NOT NULL IDENTITY(1,1),
    contact_info_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (producer_parent_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id)
);

-- create a producer table with contact_info and producer_parents
DROP TABLE IF EXISTS producers; -- single establishments like a kfc, mcdonalds, etc
CREATE TABLE producers (
    producer_id INT NOT NULL IDENTITY(1,1),
    contact_info_id INT NOT NULL,
    producer_parent_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (producer_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id),
    FOREIGN KEY (producer_parent_id) REFERENCES producer_parents(producer_parent_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- producers_have_locations table
DROP TABLE IF EXISTS producers_have_locations;
CREATE TABLE producers_have_locations (
    producer_id INT NOT NULL,
    location_id INT NOT NULL,
    PRIMARY KEY (producer_id, location_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- empresas regionales (grandes) y locales (pequeñas) que recolectan basura
-- company table (no parent company, local or regional)
DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
    company_id INT NOT NULL IDENTITY(1,1),
    contact_info_id INT NOT NULL,
    is_local BIT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (company_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- companies have locations table
DROP TABLE IF EXISTS companies_have_locations;
CREATE TABLE companies_have_locations (
    company_id INT NOT NULL,
    location_id INT NOT NULL,
    PRIMARY KEY (company_id, location_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),

);

-- esencial verde fleet table
DROP TABLE IF EXISTS fleets;
CREATE TABLE fleets (
    fleet_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (fleet_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1
);

-- collection_points table with location and name
DROP TABLE IF EXISTS collection_points;
CREATE TABLE collection_points (
    collection_point_id INT NOT NULL IDENTITY(1,1),
    location_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    contact_info_id INT NOT NULL,
    is_dropoff BIT NOT NULL, -- 0: pickup, 1: dropoff
    PRIMARY KEY (collection_point_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1
);

-- collection_log table with collection_point and fleet, company or producer, and datetime
DROP TABLE IF EXISTS collection_log;
CREATE TABLE collection_log (
    collection_log_id INT NOT NULL IDENTITY(1,1),
    collection_point_id INT NOT NULL,
    which_party tinyint(2) NOT NULL, -- 0: company, 1: producer, 2: fleet
    fleet_id INT NULL,
    company_id INT NULL,
    action tinyint(1) NOT NULL, -- 0: pickup, 1: dropoff
    producer_id INT NULL,
    datetime DATETIME NOT NULL,
    PRIMARY KEY (collection_log_id),
    FOREIGN KEY (collection_point_id) REFERENCES collection_points(collection_point_id),
    FOREIGN KEY (fleet_id) REFERENCES fleets(fleet_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);



-- a schedule_log for a pickup or dropoff with datetime, frequency, and collection or dropoff point
DROP TABLE IF EXISTS schedule_log;
CREATE TABLE schedule_log (
    schedule_log_id INT NOT NULL IDENTITY(1,1),
    which_party tinyint(2) NOT NULL, -- 0: company, 1: producer, 2: fleet
    fleet_id INT NULL,
    company_id INT NULL,
    producer_id INT NULL,
    collection_point_id INT NULL, -- is either a dropoff or pickup point
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    frequency VARCHAR(255) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    PRIMARY KEY (schedule_log_id),
    FOREIGN KEY (fleet_id) REFERENCES fleets(fleet_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (collection_point_id) REFERENCES collection_points(collection_point_id),
);

-- trash types table
DROP TABLE IF EXISTS trash_types;
CREATE TABLE trash_types (
    trash_type_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    is_recyclable BIT NOT NULL,
    PRIMARY KEY (trash_type_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- recipient types table
DROP TABLE IF EXISTS recipient_types;
CREATE TABLE recipient_types (
    recipient_type_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    weight_capacity FLOAT NOT NULL,
    PRIMARY KEY (recipient_type_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- recipient_types_have_trash_types table
DROP TABLE IF EXISTS recipient_types_have_trash_types;
CREATE TABLE recipient_types_have_trash_types (
    recipient_type_id INT NOT NULL,
    trash_type_id INT NOT NULL,
    PRIMARY KEY (recipient_type_id, trash_type_id),
    FOREIGN KEY (recipient_type_id) REFERENCES recipient_types(recipient_type_id),
    FOREIGN KEY (trash_type_id) REFERENCES trash_types(trash_type_id)
);

-- contract table
DROP TABLE IF EXISTS contracts;
CREATE TABLE contracts (
    contract_id INT NOT NULL IDENTITY(1,1),
    hash varbinary(64) NOT NULL DEFAULT HASHBYTES('SHA2_256', NEWID()),
    PRIMARY KEY (contract_id)
);

-- percentages table
DROP TABLE IF EXISTS percentages;
CREATE TABLE percentages (
    percentage_id INT NOT NULL IDENTITY(1,1),
    which_party tinyint(2) NOT NULL, -- 0: company, 1: producer, 2: fleet
    fleet_id INT NULL,
    company_id INT NULL,
    producer_id INT NULL,
    percentage FLOAT NOT NULL,
    contract_id INT NOT NULL,
    PRIMARY KEY (percentage_id),
    FOREIGN KEY (contract_id) REFERENCES contracts(contract_id)
);

-- product that ends up being produced
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    currency_id INT NOT NULL,
    kg_to_produce FLOAT NOT NULL,
    PRIMARY KEY (product_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
);

-- product_price_per_location_log
DROP TABLE IF EXISTS product_price_per_location_log;
CREATE TABLE product_price_per_location_log (
    product_price_per_location_log_id INT NOT NULL IDENTITY(1,1),
    product_id INT NOT NULL,
    location_id INT NOT NULL,
    price FLOAT NOT NULL,
    datetime DATETIME NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    hash varbinary(64) NOT NULL DEFAULT HASHBYTES('SHA2_256', NEWID()),
    PRIMARY KEY (product_price_per_location_log_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- recipient with type
DROP TABLE IF EXISTS recipients;
CREATE TABLE recipients (
    recipient_id INT NOT NULL IDENTITY(1,1),
    recipient_type_id INT NOT NULL,
    producer_id INT NOT NULL,
    cleanliness tinyint(1) NOT NULL, -- 0: dirty, 1: clean
    PRIMARY KEY (recipient_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (recipient_type_id) REFERENCES recipient_types(recipient_type_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);
-- recipient log with datetime, recipient, location, and weight
DROP TABLE IF EXISTS recipient_log;
CREATE TABLE recipient_log (
    recipient_log_id INT NOT NULL IDENTITY(1,1),
    recipient_id INT NOT NULL,
    collection_log INT NULL,
    action tinyint(2) NOT NULL, -- 0: pickup, 1: dropoff, 2: cleaning
    location_id INT NOT NULL,
    datetime DATETIME NOT NULL,
    weight FLOAT NOT NULL,
    PRIMARY KEY (recipient_log_id),
    FOREIGN KEY (recipient_id) REFERENCES recipients(recipient_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- processing table with a price per kg, a name
-- and trash types
DROP TABLE IF EXISTS processing;
CREATE TABLE processing (
    processing_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    location_id INT NOT NULL, -- processing location, different locations have different processing units
    PRIMARY KEY (processing_id),
    product_id INT NOT NULL, -- product that is produced, different processing units produce different products
    contract_id INT NOT NULL, -- contract that is used for this processing unit
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (contract_id) REFERENCES contracts(contract_id)
);

-- processing_have_trash_types table
DROP TABLE IF EXISTS processing_have_trash_types;
CREATE TABLE processing_have_trash_types (
    processing_id INT NOT NULL,
    trash_type_id INT NOT NULL,
    price_per_kg FLOAT NOT NULL,
    currency_id INT NOT NULL,
    kgs_recycled FLOAT NOT NULL, -- how much is recycled per kg of trash
    PRIMARY KEY (processing_id, trash_type_id),
    FOREIGN KEY (processing_id) REFERENCES processing(processing_id),
    FOREIGN KEY (trash_type_id) REFERENCES trash_types(trash_type_id),
    FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
);

-- table for languages
DROP TABLE IF EXISTS languages;
CREATE TABLE languages (
    language_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (language_id)
);

-- table for settings
DROP TABLE IF EXISTS settings;
CREATE TABLE settings (
    setting_id INT NOT NULL IDENTITY(1,1),
    description VARCHAR(255) NOT NULL,
    PRIMARY KEY (setting_id),
);

-- table for settings_have_languages
DROP TABLE IF EXISTS settings_have_languages;
CREATE TABLE settings_have_languages (
    setting_id INT NOT NULL,
    language_id INT NOT NULL,
    value VARCHAR(255) NOT NULL,
    PRIMARY KEY (setting_id, language_id),
    FOREIGN KEY (setting_id) REFERENCES settings(setting_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

-- table for billing a producer_parent
DROP TABLE IF EXISTS billing;
CREATE TABLE billing (
    billing_id INT NOT NULL IDENTITY(1,1),
    producer_parent_id INT NOT NULL,
    amount DECIMAL(10,3) NOT NULL,
    currency_id INT NOT NULL,
    datetime DATETIME NOT NULL,
    hash varbinary(64) NOT NULL DEFAULT HASHBYTES('SHA2_256', NEWID()),
    PRIMARY KEY (billing_id),
    FOREIGN KEY (producer_parent_id) REFERENCES producer_parents(producer_parent_id),
    FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
);

-- table that lets especially contaminant producer_parents pay
-- for other producer_parents' bills
DROP TABLE IF EXISTS billing_payments;
CREATE TABLE billing_payments (
    billing_payment_id INT NOT NULL IDENTITY(1,1),
    billing_id INT NOT NULL,
    producer_parent_id INT NOT NULL,
    amount DECIMAL(10,3) NOT NULL,
    datetime DATETIME NOT NULL,
    hash varbinary(64) NOT NULL DEFAULT HASHBYTES('SHA2_256', NEWID()),
    PRIMARY KEY (billing_payment_id),
    FOREIGN KEY (billing_id) REFERENCES billing(billing_id),
    FOREIGN KEY (producer_parent_id) REFERENCES producer_parents(producer_parent_id)
);
-- schedule_logs_have_recipients with expected amount of trash
DROP TABLE IF EXISTS schedule_logs_have_recipients;
CREATE TABLE schedule_logs_have_recipients (
    schedule_log_id INT NOT NULL,
    recipient_id INT NOT NULL,
    datetime DATETIME NOT NULL,
    expected_weight FLOAT NOT NULL,
    PRIMARY KEY (schedule_log_id, recipient_id),
    FOREIGN KEY (schedule_log_id) REFERENCES schedule_logs(schedule_log_id),
    FOREIGN KEY (recipient_id) REFERENCES recipients(recipient_id)
);
