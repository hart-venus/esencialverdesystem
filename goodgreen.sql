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

-- create a parent_company table
DROP TABLE IF EXISTS parent_companies;
CREATE TABLE parent_companies (
    parent_company_id INT NOT NULL IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (parent_company_id)
);

-- create a producer table with contact_info
DROP TABLE IF EXISTS producers;
CREATE TABLE producers (
    producer_id INT NOT NULL IDENTITY(1,1),
    parent_company_id INT NOT NULL,
    contact_info_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (producer_id),
    FOREIGN KEY (parent_company_id) REFERENCES parent_companies(parent_company_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id)
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

