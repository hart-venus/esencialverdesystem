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
);

-- create a producer_parent table with contact_info
DROP TABLE IF EXISTS producer_parents;
CREATE TABLE producer_parents (
    producer_parent_id INT NOT NULL IDENTITY(1,1),
    contact_info_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (producer_parent_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id)
);


-- create a producer table with contact_info and producer_parents
DROP TABLE IF EXISTS producers;
CREATE TABLE producers (
    producer_id INT NOT NULL IDENTITY(1,1),
    contact_info_id INT NOT NULL,
    producer_parent_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (producer_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id),
    FOREIGN KEY (producer_parent_id) REFERENCES producer_parents(producer_parent_id)
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

-- empresas regionales (grandes) y locales (pequeñas)
-- company table (no parent company, local or regional)
DROP TABLE IF EXISTS companies;
CREATE TABLE companies (
    company_id INT NOT NULL IDENTITY(1,1),
    contact_info_id INT NOT NULL,
    is_local BIT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (company_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id)
);

-- companies have locations table
DROP TABLE IF EXISTS companies_have_locations;
CREATE TABLE companies_have_locations (
    company_id INT NOT NULL,
    location_id INT NOT NULL,
    PRIMARY KEY (company_id, location_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- fleets table with company
DROP TABLE IF EXISTS fleets;
CREATE TABLE fleets (
    fleet_id INT NOT NULL IDENTITY(1,1),
    company_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (fleet_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

-- collection_points table with location and name
DROP TABLE IF EXISTS collection_points;
CREATE TABLE collection_points (
    collection_point_id INT NOT NULL IDENTITY(1,1),
    location_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (collection_point_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- collection_log table with collection_point and fleet or producer, and datetime
DROP TABLE IF EXISTS collection_log;
CREATE TABLE collection_log (
    collection_log_id INT NOT NULL IDENTITY(1,1),
    collection_point_id INT NOT NULL,
    fleet_id INT NULL,
    producer_id INT NULL,
    datetime DATETIME NOT NULL,
    PRIMARY KEY (collection_log_id),
    FOREIGN KEY (collection_point_id) REFERENCES collection_points(collection_point_id),
    FOREIGN KEY (fleet_id) REFERENCES fleets(fleet_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id)
);

