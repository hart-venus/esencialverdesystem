DECLARE @name VARCHAR(255);
DECLARE @plate VARCHAR(255);
DECLARE @place VARCHAR(255);
DECLARE @CollectorInfoTVP CollectorInfo;
DECLARE @RecipientLogTVP RecipientLogInfo;
DECLARE @type VARCHAR(255);
DECLARE @weight DECIMAL(12, 4);
DECLARE @trash VARCHAR(255);
DECLARE @action INT;

-- get a random name from people into @name
SELECT TOP 1 @name = full_name FROM people ORDER BY NEWID();
-- get a random plate from fleets into @plate
SELECT TOP 1 @plate = plate FROM fleets ORDER BY NEWID();
-- get a random place from collection_points into @place
SELECT TOP 1 @place = name FROM collection_points ORDER BY NEWID();

-- insert the random values into the TVP
INSERT INTO @CollectorInfoTVP (Nombre, Placa, Lugar)
VALUES (@name, @plate, @place);

-- get a random type of recipient from recipient_types into @type
SELECT TOP 1 @type = name FROM recipient_types ORDER BY NEWID();
-- get random weight from 0 to 1000 into @weight
SELECT TOP 1 @weight = CAST(RAND() * 1000 AS DECIMAL(12, 4));
-- get a random type of trash from trash_types into @trash
SELECT TOP 1 @trash = name FROM trash_types ORDER BY NEWID();
-- get a random action from 1 to 2 into @action
SELECT TOP 1 @action = CAST(RAND() * 1 AS INT) + 1;

-- insert the random values into the TVP
INSERT INTO @RecipientLogTVP (TipoRecipiente, Peso, TipoResiduo, Accion)
VALUES (@type, @weight, @trash, @action);

-- call the procedure
EXEC SP_RegistrarColeccion @CollectorInfoTVP, @RecipientLogTVP;
