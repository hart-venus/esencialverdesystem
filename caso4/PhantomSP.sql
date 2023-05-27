DROP PROCEDURE IF EXISTS getNames;
DROP PROCEDURE IF EXISTS insert_person;

CREATE PROCEDURE getNames
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    BEGIN TRANSACTION;
    SELECT full_name FROM people;
    WAITFOR DELAY '00:00:05';
    SELECT full_name FROM people;
    COMMIT TRANSACTION;
END;

CREATE PROCEDURE insert_person
    @full_name VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO people (full_name) VALUES (@full_name);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH;
END;

EXEC getNames;
EXEC insert_person '';

-- Test de phantom read
-- 1. Ejecutar el stored procedure getNames
-- 2. Ejecutar el stored procedure insert_person con un nombre antes de que termine el stored procedure getNames
-- getNames muestra dos tablas, una con el nombre insertado y otra sin el nombre insertado

-- Fix the phantom read issue by adding a SNAPSHOT isolation level to the stored procedure that reads the data.
-- This needs the database to be in snapshot isolation mode
ALTER DATABASE [esencialverdesystem] SET ALLOW_SNAPSHOT_ISOLATION ON;

CREATE PROCEDURE getNames
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
    BEGIN TRANSACTION;
    SELECT full_name FROM people;
    WAITFOR DELAY '00:00:05';
    SELECT full_name FROM people;
    COMMIT TRANSACTION;
END;