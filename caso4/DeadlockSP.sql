DROP PROCEDURE IF EXISTS setNames1;
DROP PROCEDURE IF EXISTS setNames2;

-- Stored Procedure 1
CREATE PROCEDURE setNames1
	@name1 VARCHAR(255),
	@name2 VARCHAR(255)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;
    
    -- Hacer algo en la transacción 1
    UPDATE people SET full_name = 'Tomas' WHERE person_id = 1;

    -- Esperar un poco para permitir que la transacción 2 se inicie
    WAITFOR DELAY '00:00:05';

    -- Intentar acceder a los recursos bloqueados por la transacción 2
    UPDATE people SET full_name = 'Sven' WHERE person_id = 2;

    COMMIT;
END;

-- Stored Procedure 2
CREATE PROCEDURE setNames2
	@name1 VARCHAR(255),
	@name2 VARCHAR(255)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;
    
    -- Hacer algo en la transacción 2
    UPDATE people SET full_name = @name1 WHERE person_id = 2;

    -- Esperar un poco para permitir que la transacción 1 se inicie
    WAITFOR DELAY '00:00:05';

    -- Intentar acceder a los recursos bloqueados por la transacción 1
    UPDATE people SET full_name = @name2 WHERE person_id = 1;

    COMMIT;
END;