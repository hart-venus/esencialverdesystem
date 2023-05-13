DECLARE @name VARCHAR(255);
DECLARE @plate VARCHAR(255);
DECLARE @place VARCHAR(255);
DECLARE @CollectorInfoTVP CollectorInfo;
DECLARE @RecipientLogTVP RecipientLogInfo;

-- get a random name from people into @name
SELECT TOP 1 @name = full_name FROM people ORDER BY NEWID();
-- get a random plate from fleets into @plate
SELECT TOP 1 @plate = plate FROM fleets ORDER BY NEWID();
-- get a random place from collection_points into @place
SELECT TOP 1 @place = name FROM collection_points ORDER BY NEWID();

-- insert the random values into the TVP
INSERT INTO @CollectorInfoTVP (Nombre, Placa, Lugar)
VALUES (@name, @plate, @place);

-- call the procedure
EXEC SP_RegistrarColeccion @CollectorInfoTVP, @RecipientLogTVP;
