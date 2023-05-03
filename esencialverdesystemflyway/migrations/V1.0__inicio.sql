


-- empresas regionales (grandes) y locales (pequeñas) que recolectan basura
-- company table (no parent company, local or regional)
DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
    company_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (company_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1
);
-- create a producer_parent table with contact_info
DROP TABLE IF EXISTS producer_parents; -- big companies like kfc, mcdonalds, etc
CREATE TABLE producer_parents (
    producer_parent_id INT NOT NULL IDENTITY(1,1),

    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (producer_parent_id),
);
-- create a producer table with contact_info and producer_parents
DROP TABLE IF EXISTS producers; -- single establishments like a kfc, mcdonalds, etc
CREATE TABLE producers (
    producer_id INT NOT NULL IDENTITY(1,1),
    producer_parent_id INT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (producer_id),
    FOREIGN KEY (producer_parent_id) REFERENCES producer_parents(producer_parent_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1
);


-- frequency
DROP TABLE IF EXISTS frequencies;
CREATE TABLE frequencies (
    frequency_id INT NOT NULL IDENTITY(1,1),
    frequency VARCHAR(255) NOT NULL,
    PRIMARY KEY (frequency_id)
);

-- create currency table
DROP TABLE IF EXISTS currencies;
CREATE TABLE currencies (
    currency_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    PRIMARY KEY (currency_id),
);
-- people table
DROP TABLE IF EXISTS people;
CREATE TABLE people (
    person_id INT NOT NULL IDENTITY(1,1),
    PRIMARY KEY (person_id)
);
-- esencial verde fleet table
DROP TABLE IF EXISTS fleets;
CREATE TABLE fleets (
    fleet_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (fleet_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1
);
-- product that ends up being produced
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    kg_to_produce DECIMAL(12, 4) NOT NULL,
    PRIMARY KEY (product_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
);

-- esencial verde car table
DROP TABLE IF EXISTS cars;
CREATE TABLE cars (
    car_id INT NOT NULL IDENTITY(1,1),
    fleet_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (car_id),
    capacity DECIMAL(10,3) NOT NULL,
    FOREIGN KEY (fleet_id) REFERENCES fleets(fleet_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1
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

-- cars_have_trash_types table
DROP TABLE IF EXISTS cars_have_trash_types;
CREATE TABLE cars_have_trash_types (
    car_id INT NOT NULL,
    trash_type_id INT NOT NULL,
    PRIMARY KEY (car_id, trash_type_id),
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (trash_type_id) REFERENCES trash_types(trash_type_id)
);

-- create movement_types table
DROP TABLE IF EXISTS movement_types;
CREATE TABLE movement_types (
    movement_type_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (movement_type_id)
);

-- service_contract with producer, schedules, datetime, active and expiration
DROP TABLE IF EXISTS service_contracts;
CREATE TABLE service_contracts (
    service_contract_id INT NOT NULL IDENTITY(1,1),
    producer_id INT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    PRIMARY KEY (service_contract_id),
    FOREIGN KEY (service_contract_id) REFERENCES service_contracts(service_contract_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
);

-- currencies_dollar_exchange_rate_log
DROP TABLE IF EXISTS currencies_dollar_exchange_rate_log;
CREATE TABLE currencies_dollar_exchange_rate_log (
    currency_dollar_exchange_rate_log_id BIGINT NOT NULL IDENTITY(1,1),
    currency_id INT NOT NULL,
    exchange_rate DECIMAL(12,4) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    start_date DATETIME NOT NULL DEFAULT GETDATE(),
    end_date DATETIME NULL,
    active BIT NOT NULL DEFAULT 1,
    checksum varbinary(64) NOT NULL DEFAULT 0x0,
    PRIMARY KEY (currency_dollar_exchange_rate_log_id),
    FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
);
-- create countries table
DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
    country_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (country_id)
);

-- create province table
DROP TABLE IF EXISTS provinces;
CREATE TABLE provinces (
    province_id INT NOT NULL IDENTITY(1,1),
    country_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (province_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
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


-- create location table with foreign key and point
DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
    location_id INT NOT NULL IDENTITY(1,1),
    city_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    coordinates GEOMETRY NOT NULL,
    zipcode VARCHAR(255) NOT NULL,
    PRIMARY KEY (location_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);
-- collection_points table with location and name
DROP TABLE IF EXISTS collection_points;
CREATE TABLE collection_points (
    collection_point_id INT NOT NULL IDENTITY(1,1),
    location_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    producer_id INT NULL,
    company_id INT NULL,
    is_dropoff BIT NOT NULL, -- 0: pickup, 1: dropoff
    PRIMARY KEY (collection_point_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1
);
-- a schedule_log for a pickup or dropoff with datetime, frequency, and collection or dropoff point
DROP TABLE IF EXISTS schedule_log;
CREATE TABLE schedule_log (
    schedule_log_id BIGINT NOT NULL IDENTITY(1,1),
    fleet_id INT NULL,
    company_id INT NULL,
    producer_id INT NULL,
    collection_point_id INT NULL, -- is either a dropoff or pickup point
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    service_contract_id INT NOT NULL,
    movement_type_id INT NOT NULL,
    frequency_id INT NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    PRIMARY KEY (schedule_log_id),
    FOREIGN KEY (fleet_id) REFERENCES fleets(fleet_id),
    FOREIGN KEY (frequency_id) REFERENCES frequencies(frequency_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (collection_point_id) REFERENCES collection_points(collection_point_id),
    FOREIGN KEY (service_contract_id) REFERENCES service_contracts(service_contract_id),
    FOREIGN KEY (movement_type_id) REFERENCES movement_types(movement_type_id)
);


-- contact info types table
DROP TABLE IF EXISTS contact_info_types;
CREATE TABLE contact_info_types (
    contact_info_type_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (contact_info_type_id)
);

-- create region table with id and name
DROP TABLE IF EXISTS regions;
CREATE TABLE regions (
    region_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (region_id)
);

-- create region_areas table with region_id, optional
-- city_id, optional province_id, optional country_id
DROP TABLE IF EXISTS region_areas;
CREATE TABLE region_areas (
    region_area_id INT NOT NULL IDENTITY(1,1),
    region_id INT NOT NULL,
    city_id INT NULL,
    province_id INT NULL,
    country_id INT NULL,
    PRIMARY KEY (region_area_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (province_id) REFERENCES provinces(province_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

-- create people_have_contact_info_types table with person_id and contact_info_type_id, along with value
DROP TABLE IF EXISTS people_have_contact_info_types;
CREATE TABLE people_have_contact_info_types (
    person_id INT NOT NULL,
    contact_info_type_id INT NOT NULL,
    value VARCHAR(255) NOT NULL,
    PRIMARY KEY (person_id, contact_info_type_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id),
    FOREIGN KEY (contact_info_type_id) REFERENCES contact_info_types(contact_info_type_id)
);


-- producer_parents_have_people
DROP TABLE IF EXISTS producer_parents_have_people;
CREATE TABLE producer_parents_have_people (
    producer_parent_id INT NOT NULL,
    person_id INT NOT NULL,
    PRIMARY KEY (producer_parent_id, person_id),
    FOREIGN KEY (producer_parent_id) REFERENCES producer_parents(producer_parent_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);



-- producers_have_people
DROP TABLE IF EXISTS producers_have_people;
CREATE TABLE producers_have_people (
    producer_id INT NOT NULL,
    person_id INT NOT NULL,
    PRIMARY KEY (producer_id, person_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);



-- companies have people
DROP TABLE IF EXISTS companies_have_people;
CREATE TABLE companies_have_people (
    company_id INT NOT NULL,
    person_id INT NOT NULL,
    PRIMARY KEY (company_id, person_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);


-- companies have regions
DROP TABLE IF EXISTS companies_have_regions;
CREATE TABLE companies_have_regions (
    company_id INT NOT NULL,
    region_id INT NOT NULL,
    PRIMARY KEY (company_id, region_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    active BIT NOT NULL DEFAULT 1
);

-- producers_have_people table
DROP TABLE IF EXISTS producers_have_people;
CREATE TABLE producers_have_people (
    producer_id INT NOT NULL,
    person_id INT NOT NULL,
    PRIMARY KEY (producer_id, person_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);
-- companies_have_people table
DROP TABLE IF EXISTS companies_have_people;
CREATE TABLE companies_have_people (
    company_id INT NOT NULL,
    person_id INT NOT NULL,
    PRIMARY KEY (company_id, person_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);

-- collection_log table
DROP TABLE IF EXISTS collection_log;
CREATE TABLE collection_log (
    collection_log_id BIGINT NOT NULL IDENTITY(1,1),
    collection_point_id INT NOT NULL,
    movement_type_id INT NOT NULL,
    service_contract_id INT NOT NULL,
    datetime DATETIME NOT NULL,
    responsible_person_id INT NOT NULL,
    schedule_log_id BIGINT NOT NULL,

    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    checksum varbinary (64) NOT NULL,
    PRIMARY KEY (collection_log_id),
    FOREIGN KEY (collection_point_id) REFERENCES collection_points(collection_point_id),
    FOREIGN KEY (schedule_log_id) REFERENCES schedule_log(schedule_log_id),
    FOREIGN KEY (movement_type_id) REFERENCES movement_types(movement_type_id),
    FOREIGN KEY (service_contract_id) REFERENCES service_contracts(service_contract_id),
    FOREIGN KEY (responsible_person_id) REFERENCES people(person_id),
);



-- certificates table with datetime, and expiration
DROP TABLE IF EXISTS certificates;
CREATE TABLE certificates (
    certificate_id INT NOT NULL IDENTITY(1,1),
    producer_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    PRIMARY KEY (certificate_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id)
);






-- recipient_brands table
DROP TABLE IF EXISTS recipient_brands;
CREATE TABLE recipient_brands (
    recipient_brand_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (recipient_brand_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- recipient_models table
DROP TABLE IF EXISTS recipient_models;
CREATE TABLE recipient_models (
    recipient_model_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    weight_capacity DECIMAL(12, 4) NOT NULL,
    brand_id INT NOT NULL,
    PRIMARY KEY (recipient_model_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (brand_id) REFERENCES recipient_brands(recipient_brand_id)
);

-- recipient types table
DROP TABLE IF EXISTS recipient_types;
CREATE TABLE recipient_types (
    recipient_type_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    recipient_model_id INT NOT NULL,
    PRIMARY KEY (recipient_type_id),
    FOREIGN KEY (recipient_model_id) REFERENCES recipient_models(recipient_model_id),
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
DROP TABLE IF EXISTS recycling_contracts;
CREATE TABLE recycling_contracts (
    recycling_contract_id INT NOT NULL IDENTITY(1,1),
    checksum varbinary(64) NOT NULL,
    valid_from DATETIME NOT NULL,
    valid_to DATETIME NOT NULL,
    service_contract_id INT NOT NULL,
    PRIMARY KEY (recycling_contract_id),
    FOREIGN KEY (service_contract_id) REFERENCES service_contracts(service_contract_id)
);

-- materials table
DROP TABLE IF EXISTS materials;
CREATE TABLE materials (
    material_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (material_id),
);

-- measure table
DROP TABLE IF EXISTS measures;
CREATE TABLE measures (
    measure_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (measure_id),
);

-- materialsXproducts table
DROP TABLE IF EXISTS materialsXproducts;
CREATE TABLE materialsXproducts (
    materialsXproducts_id INT NOT NULL IDENTITY(1,1),
    material_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity DECIMAL(12, 4) NOT NULL,
    measure_id INT NOT NULL,
    PRIMARY KEY (materialsXproducts_id),
    FOREIGN KEY (material_id) REFERENCES materials(material_id),
    FOREIGN KEY (measure_id) REFERENCES measures(measure_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- processing_cost_per_waste_type table
DROP TABLE IF EXISTS processing_cost_per_waste_type;
CREATE TABLE processing_cost_per_waste_type (
    processing_cost_per_waste_type_id INT NOT NULL IDENTITY(1,1),
    trash_type_id INT NOT NULL,
    cost DECIMAL(12, 4) NOT NULL,
    currency_id INT NOT NULL,
    recycling_contract_id INT NOT NULL,
    PRIMARY KEY (processing_cost_per_waste_type_id),
    FOREIGN KEY (recycling_contract_id) REFERENCES recycling_contracts(recycling_contract_id),
    FOREIGN KEY (trash_type_id) REFERENCES trash_types(trash_type_id),
    FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
);

-- materialXwaste_type table
DROP TABLE IF EXISTS materialXwaste_type;
CREATE TABLE materialXwaste_type (
    materialXwaste_type_id INT NOT NULL IDENTITY(1,1),
    material_id INT NOT NULL,
    trash_type_id INT NOT NULL,
    kg_conversion DECIMAL(12, 4) NOT NULL,
    PRIMARY KEY (materialXwaste_type_id),
    FOREIGN KEY (material_id) REFERENCES materials(material_id),
    FOREIGN KEY (trash_type_id) REFERENCES trash_types(trash_type_id)
);

-- products recycled table
DROP TABLE IF EXISTS produced_products_log;
CREATE TABLE produced_products_log (
    produced_products_log_id INT NOT NULL IDENTITY(1,1),
    product_id INT NOT NULL,
    quantity DECIMAL(12, 4) NOT NULL,
    measure_id INT NOT NULL,
    recycling_contract_id INT NOT NULL,
    PRIMARY KEY (produced_products_log_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (measure_id) REFERENCES measures(measure_id),
    FOREIGN KEY (recycling_contract_id) REFERENCES recycling_contracts(recycling_contract_id)
);

-- percentages table
DROP TABLE IF EXISTS percentages;
CREATE TABLE percentages (
    percentage_id INT NOT NULL IDENTITY(1,1),
    fleet_id INT NULL,
    company_id INT NULL,
    producer_id INT NULL,
    name VARCHAR(255) NOT NULL,
    percentage DECIMAL(12, 4) NOT NULL,
    recycling_contract_id INT NOT NULL,
    PRIMARY KEY (percentage_id),
    FOREIGN KEY (recycling_contract_id) REFERENCES recycling_contracts(recycling_contract_id)
);



DROP TABLE IF EXISTS recipient_status
CREATE TABLE recipient_status (
    recipient_status_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (recipient_status_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);

-- recipient with type
DROP TABLE IF EXISTS recipients;
CREATE TABLE recipients (
    recipient_id INT NOT NULL IDENTITY(1,1),
    recipient_type_id INT NOT NULL,
    producer_id INT NOT NULL,
    PRIMARY KEY (recipient_id),
    recipient_status_id INT NOT NULL,
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (recipient_type_id) REFERENCES recipient_types(recipient_type_id),
    FOREIGN KEY (recipient_status_id) REFERENCES recipient_status(recipient_status_id),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);
-- recipient log with datetime, recipient, location, and weight
DROP TABLE IF EXISTS recipient_log;
CREATE TABLE recipient_log (
    recipient_log_id BIGINT NOT NULL IDENTITY(1,1),
    recipient_id INT NOT NULL,
    recipient_status_id INT NOT NULL,
    collection_log INT NULL,
    movement_type_id INT NOT NULL,
    location_id INT NOT NULL,
    datetime DATETIME NOT NULL,
    weight DECIMAL(12, 4) NULL,
    PRIMARY KEY (recipient_log_id),
    FOREIGN KEY (recipient_id) REFERENCES recipients(recipient_id),
    FOREIGN KEY (recipient_status_id) REFERENCES recipient_status(recipient_status_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (movement_type_id) REFERENCES movement_types(movement_type_id),
);

-- tablas de sistema

-- create a sources table
create table sources (
  source_id int not null IDENTITY(1,1),
  name varchar(20) not null,
  primary key (source_id)
);

-- create a levels table
create table levels (
  level_id int not null IDENTITY(1,1),
  name varchar(20) not null, -- 1=error, 2=warning, 3=info
  primary key (level_id),
);

-- create objectTypes table
create table objectTypes (
  objectType_id bigint not null IDENTITY(1,1),
  name varchar(20) not null,
  primary key (objectType_id),

);

-- create eventTypes table
create table eventTypes (
  eventType_id int not null IDENTITY(1,1),
  name varchar(20) not null,
  primary key (eventType_id),
);

-- create an event log table
create table eventlog (
  eventlog_id BIGINT NOT NULL IDENTITY(1,1),
  level_id int not null, -- 1=error, 2=warning, 3=info
  eventdate datetime not null,
  eventtype int not null,
  source_id int not null,
  checksum varbinary(32) not null, -- checksum of the event data
  username varchar(20) not null,
  referenceId1 bigint not null,
  referenceId2 bigint not null,
  value1 varchar(60) not null,
  value2 varchar(60) not null,
  primary key (eventlog_id),
  FOREIGN KEY (source_id) REFERENCES sources(source_id),
  FOREIGN KEY (level_id) REFERENCES levels(level_id),
  FOREIGN KEY (referenceId1) REFERENCES objectTypes(objectType_id),
  FOREIGN KEY (referenceId2) REFERENCES objectTypes(objectType_id),
  FOREIGN KEY (eventtype) REFERENCES eventTypes(eventtype_id)
);


-- feedback: hacerlo multi-idioma
DROP TABLE IF EXISTS languages;
CREATE TABLE languages (
    language_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL,
    PRIMARY KEY (language_id)
);

DROP TABLE IF EXISTS translations;
CREATE TABLE translations (
    translation_id INT NOT NULL IDENTITY(1,1),
    label VARCHAR(255) NOT NULL,
    reference_id BIGINT NOT NULL,
    post_time DATETIME NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    language_id INT NOT NULL,
    objectType_id BIGINT NOT NULL,
    PRIMARY KEY (translation_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id),
    FOREIGN KEY (objectType_id) REFERENCES objectTypes(objectType_id)
);

-- Invoice table to charge producers
DROP TABLE IF EXISTS invoices;
CREATE TABLE invoices (
    invoice_id INT NOT NULL IDENTITY(1,1),
    producer_id INT NOT NULL,
    invoice_number VARCHAR(255) NOT NULL,
    invoice_date DATETIME NOT NULL,
    invoice_due_date DATETIME NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    checksum varbinary(64) NOT NULL, -- sha256(sum(values), secret)
    invoice_amount DECIMAL(12, 4) NOT NULL,
    currency_id INT NOT NULL,
    PRIMARY KEY (invoice_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (currency_id) REFERENCES currencies(currency_id),
);


-- Transactions table
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    transaction_id INT NOT NULL IDENTITY(1,1),
    transaction_date DATETIME NOT NULL,
    payment_amount DECIMAL(12, 4) NOT NULL,
    currency_id INT NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    checksum varbinary(64) NOT NULL, -- sha256(sum(values), secret)
    PRIMARY KEY (transaction_id),
);

-- Payments table
DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id INT NOT NULL IDENTITY(1,1),
    transaction_id INT NOT NULL,
    payment_date DATETIME NOT NULL,
    producer_id INT NOT NULL,
    invoice_id INT NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    checksum varbinary(64) NOT NULL, -- sha256(sum(values), secret)
    PRIMARY KEY (payment_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id)
);

-- schedule_logs_have_recipient_types with expected amount of trash
DROP TABLE IF EXISTS schedule_logs_have_recipient_types;
CREATE TABLE schedule_logs_have_recipient_types (
    schedule_log_id BIGINT NOT NULL,
    recipient_type_id INT NOT NULL,
    expected_amount DECIMAL(12, 4) NOT NULL,
    PRIMARY KEY (schedule_log_id, recipient_type_id),
    FOREIGN KEY (schedule_log_id) REFERENCES schedule_log(schedule_log_id),
    FOREIGN KEY (recipient_type_id) REFERENCES recipient_types(recipient_type_id)
);

DROP TABLE IF EXISTS carbon_footprint_log;
CREATE TABLE carbon_footprint_log (
    carbon_footprint_log_id BIGINT NOT NULL IDENTITY(1,1),
    producer_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    checksum varbinary(64) NOT NULL DEFAULT 0x00,
    active BIT NOT NULL DEFAULT 1,

    score DECIMAL(12, 4) NOT NULL,
    PRIMARY KEY (carbon_footprint_log_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id)
);

-- certificates have trash types table
DROP TABLE IF EXISTS certificates_have_trash_types;
CREATE TABLE certificates_have_trash_types (
    certificate_id INT NOT NULL,
    trash_type_id INT NOT NULL,
    PRIMARY KEY (certificate_id, trash_type_id),
    FOREIGN KEY (certificate_id) REFERENCES certificates(certificate_id),
    FOREIGN KEY (trash_type_id) REFERENCES trash_types(trash_type_id)
);

-- sponsor producers per region table
DROP TABLE IF EXISTS sponsor_producers_per_region;
CREATE TABLE sponsor_producers_per_region (
    sponsor_producer_per_region_id INT NOT NULL IDENTITY(1,1),
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    service_contract_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    checksum varbinary(64) NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    percentage DECIMAL(12, 4) NOT NULL,
    producer_id INT NOT NULL,
    region_id INT NOT NULL,
    PRIMARY KEY (sponsor_producer_per_region_id),
    FOREIGN KEY (service_contract_id ) REFERENCES service_contracts(service_contract_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id)
);

-- product_price_log
DROP TABLE IF EXISTS product_price_log;
CREATE TABLE product_price_log (
    product_price_log_id INT NOT NULL IDENTITY(1,1),
    product_id INT NOT NULL,
    price DECIMAL(12, 4) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    checksum varbinary(64) NOT NULL,
    currency_id INT NOT NULL,
    active BIT NOT NULL DEFAULT 1,
    PRIMARY KEY (product_price_log_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
);

-- sales table for products, has a location, price and datetime
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    sale_id INT NOT NULL IDENTITY(1,1),
    product_id INT NOT NULL,
    recycling_contract_id INT NOT NULL,
    currency_id INT NOT NULL,
    datetime DATETIME NOT NULL,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (recycling_contract_id) REFERENCES recycling_contracts(recycling_contract_id),
);

