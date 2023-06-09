-- Procedure a encriptar
CREATE PROCEDURE GetProducts
AS
BEGIN
    SELECT * FROM products;
END;


--Alter Procedure para encriptarlo
ALTER PROCEDURE GetProducts
WITH ENCRYPTION
AS
BEGIN
    SELECT * FROM products;
END;

--Creacion de otro procedure como ejemplo para la verificacion de encripcion del otro
CREATE PROCEDURE GetProducers
AS
BEGIN
    SELECT * FROM producers;
END;

--Codigo para demostrar la existencia y estados de los SP
SELECT O.name, M.definition, O.type_desc, O.type 
FROM sys.sql_modules M 
INNER JOIN sys.objects O ON M.object_id=O.object_id 
WHERE O.type IN ('P');
GO

DROP PROCEDURE IF EXISTS GetProducts;
DROP PROCEDURE IF EXISTS GetProducers;