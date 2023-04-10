-- create province table
CREATE TABLE provinces (
    province_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (province_id)
);

-- create city table
CREATE TABLE cities (
    city_id INT NOT NULL AUTO_INCREMENT,
    province_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (city_id)
);

-- create zipcodes table with foreign key
CREATE TABLE zipcodes (
    zipcode_id INT NOT NULL AUTO_INCREMENT,
    city_id INT NOT NULL,
    zipcode VARCHAR(50) NOT NULL,
    PRIMARY KEY (zipcode_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- create location table with foreign key and point
CREATE TABLE locations (
    location_id INT NOT NULL AUTO_INCREMENT,
    zipcode_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    coordinates POINT NOT NULL,
    PRIMARY KEY (location_id),
    FOREIGN KEY (zipcode_id) REFERENCES zipcodes(zipcode_id)
);

-- create contact_info table
CREATE TABLE contact_info (
    contact_info_id INT NOT NULL AUTO_INCREMENT,
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (contact_info_id),
);

-- create a parent_company table
CREATE TABLE parent_companies (
    parent_company_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (parent_company_id)
);

-- create a producer table with contact_info
CREATE TABLE producers (
    producer_id INT NOT NULL AUTO_INCREMENT,
    parent_company_id INT NOT NULL,
    contact_info_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (producer_id),
    FOREIGN KEY (parent_company_id) REFERENCES parent_companies(parent_company_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    FOREIGN KEY (contact_info_id) REFERENCES contact_info(contact_info_id)
);

-- producers_have_locations table
CREATE TABLE producers_have_locations (
    producer_id INT NOT NULL,
    location_id INT NOT NULL,
    PRIMARY KEY (producer_id, location_id),
    FOREIGN KEY (producer_id) REFERENCES producers(producer_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

