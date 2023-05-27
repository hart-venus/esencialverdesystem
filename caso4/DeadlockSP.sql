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
    UPDATE people SET full_name = @name1 WHERE person_id = 1;

    -- Esperar un poco para permitir que la transacción 2 se inicie
    WAITFOR DELAY '00:00:05';

    -- Intentar acceder a los recursos bloqueados por la transacción 2
    UPDATE people SET full_name = @name2 WHERE person_id = 2;

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

-- Para ejemplificar este error, se ejecuta el stored procedure 1
-- y simultaneamente se ejecuta el stored procedure 2.
-- Esto puede ocurrir en el sistema cuando dos personas intentan actualizar
-- los nombres de dos personas al mismo tiempo.
-- El resultado es un deadlock, ya que cada transacción espera a que la otra
-- libere los recursos que necesita para continuar.
-- El resultado es que ninguna de las dos transacciones se completa.
-- para arreglar, se debe cambiar el orden de uno de los updates

-- Stored Procedure 1
CREATE PROCEDURE setNames1
    @name1 VARCHAR(255),
    @name2 VARCHAR(255)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;
    
    -- Hacer algo en la transacción 1
    UPDATE people SET full_name = @name1 WHERE person_id = 2;

    -- Esperar un poco para permitir que la transacción 2 se inicie
    WAITFOR DELAY '00:00:05';

    -- Intentar acceder a los recursos bloqueados por la transacción 2
    UPDATE people SET full_name = @name2 WHERE person_id = 1;

    COMMIT;
END;

