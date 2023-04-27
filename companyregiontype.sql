DROP TYPE IF EXISTS CompanyRegionType;
CREATE TYPE CompanyRegionType AS TABLE 
( 
    CompanyName VARCHAR(50),
    RegionName VARCHAR(50),
    CountryName VARCHAR(50)
);