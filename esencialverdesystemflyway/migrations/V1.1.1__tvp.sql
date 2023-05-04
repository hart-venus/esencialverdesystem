-----------------------------------------------------------
-- Autor: Rnunez
-- Fecha: 12/12/2011
-- Descripcion: esta description en comentarios queda almacenada
-- Otros detalles de los parametros
-----------------------------------------------------------
-- Author: Ariel Leyva
-- Fecha: 27-04-2023
-- Desc: Inserta pais, region y compania en las tablas respectivas, asociando
-- el pais con la region y la compania con la region
-----------------------------------------------------------
DROP TYPE IF EXISTS CompanyRegionType;
CREATE TYPE CompanyRegionType AS TABLE
(
    CompanyName VARCHAR(50),
    RegionName VARCHAR(50),
    CountryName VARCHAR(50)
);
