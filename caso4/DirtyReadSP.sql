-- Programa que ejemplifica un dirty read

-- 1. Stored procedure transactional que toma como parametro
-- person_id y le cambia el correo electronico a otro parametro
IF OBJECT_ID('UpdateEmail', 'P') IS NOT NULL
    DROP PROCEDURE UpdateEmail;
GO

CREATE PROCEDURE UpdateEmail
    @person_id INT,
    @new_email NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Update the email in the table
        UPDATE pcit
        SET pcit.value = @new_email
        FROM people_have_contact_info_types AS pcit
        WHERE pcit.person_id = @person_id
        AND pcit.contact_info_type_id = (
            SELECT contact_info_type_id FROM contact_info_types WHERE name = 'email'
        );

        -- wait five seconds
        WAITFOR DELAY '00:00:05';


        -- If the new email is empty, rollback the transaction
        IF @new_email = ''
        BEGIN
            ROLLBACK;
            RETURN; -- Exit the stored procedure
        END;

        COMMIT;
    END TRY
    BEGIN CATCH
        -- Handle the error and rollback the transaction
        IF @@TRANCOUNT > 0
            ROLLBACK;
        -- Raise the error message
        THROW;
    END CATCH;
END;
GO

-- read emails procedure
-- read uncommitted
IF OBJECT_ID('GetEmails', 'P') IS NOT NULL
    DROP PROCEDURE GetEmails;

CREATE PROCEDURE GetEmails
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN
    SELECT value AS email, people.person_id AS id, people.full_name as name
    FROM people_have_contact_info_types AS pcit
    JOIN people ON people.person_id = pcit.person_id
    WHERE pcit.contact_info_type_id = (
            SELECT contact_info_type_id FROM contact_info_types WHERE name = 'email'
        );
END;
GO

-- Para ejemplificar el dirty read, se ejecuta el stored procedure qque no hace commit
-- EXEC UpdateEmail @person_id = 2, @new_email = '';
-- Y simultaneamente se ejecuta el stored procedure que lee los emails
-- EXEC GetEmails;
-- Se puede observar que el email de la persona 2 es vacio, lo cual es incorrecto.

-- Este puede ocurrir en el sistema si alguien busca un email mientras que la actualizacion
-- no esta completa.

-- Para arreglar esto, vamos a corregir el stored procedure GetEmails
-- para que use el nivel de aislamiento READ COMMITTED

-- read committed
IF OBJECT_ID('GetEmails', 'P') IS NOT NULL
    DROP PROCEDURE GetEmails;

CREATE PROCEDURE GetEmails
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN
    SELECT value AS email, people.person_id AS id, people.full_name as name
    FROM people_have_contact_info_types AS pcit
    JOIN people ON people.person_id = pcit.person_id
    WHERE pcit.contact_info_type_id = (
            SELECT contact_info_type_id FROM contact_info_types WHERE name = 'email'
        );
END;
GO
