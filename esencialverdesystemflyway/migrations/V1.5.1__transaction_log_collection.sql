-----------------------------------------------------------
-- Author: Ariel Leyva
-- Fecha: 12-05-2023
-- Desc: crea el procedimiento que registra un collection log, es decir un movimiento
-- de recoleccion de basura
-----------------------------------------------------------
-- DROP PROCEDURE [dbo].[SP_RegistrarColeccion]
CREATE PROCEDURE [dbo].[SP_RegistrarColeccion]
	@CollectorTVP CollectorInfo READONLY,
	@RecipientLogTVP RecipientLogInfo READONLY
AS
BEGIN

	SET NOCOUNT ON -- no retorne metadatos

	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- declaracion de otras variables
    -- variables para la recoleccion
	CREATE TABLE #TempCollectionID (collection_log_id BIGINT);

    DECLARE @CollectionPointID INT
    DECLARE @MovementTypeID INT
    DECLARE @ServiceContractID INT
    DECLARE @FleetID INT
    DECLARE @ProducerID INT
    DECLARE @Now DATETIME
    DECLARE @CollectorID INT
    DECLARE @CollectionChecksum varbinary(64)
    DECLARE @CollectionID BIGINT
    -- variables para los recipientes
    DECLARE @RecipientStatusID INT

	-- operaciones de select que no tengan que ser bloqueadas
	-- tratar de hacer todo lo posible antes de q inice la transaccion

    -- 0. conseguir datetime actual
    SET @Now = GETDATE()
    -- 1. conseguir el id del punto de recoleccion

	SELECT @CollectionPointID = collection_point_id
	FROM collection_points
    WHERE name = ( SELECT Lugar FROM @CollectorTVP)
    -- 2. conseguir el id del productor basado en el punto de recoleccion
    SELECT @ProducerID = producer_id
	FROM collection_points
	WHERE collection_point_id = @CollectionPointID
    -- 3. conseguir el id del contrato de servicio basado en el productor
    SELECT @ServiceContractID = service_contract_id
    FROM service_contracts
    WHERE producer_id = @ProducerID
    AND active = 1
    AND start_date <= @Now
    AND end_date >= @Now
    -- 4. conseguir persona responsable de la recoleccion
    SELECT @CollectorID = person_id
    FROM people
    WHERE full_name = ( SELECT Nombre FROM @CollectorTVP)
    -- 5. conseguir fleta responsable de la recoleccion
    SELECT @FleetID = fleet_id
    FROM fleets
    WHERE plate = ( SELECT Placa FROM @CollectorTVP)


    -- 6. rellenar la TVP con IDS de la entrada

    -- 6.0. no se pueden modificar los datos de la TVP, asi que se crea una nueva
    -- tabla temporal

    -- 6.0.1. crear la tabla temporal
    select * into #RecipientLogTVP from @RecipientLogTVP

    -- 6.1. conseguir el id del tipo del recipiente
    UPDATE #RecipientLogTVP
    SET TipoRecipienteID = recipient_types.recipient_type_id
    FROM recipient_types
    WHERE recipient_types.name = #RecipientLogTVP.TipoRecipiente

    -- 6.2. conseguir el id del tipo de residuo
    UPDATE #RecipientLogTVP
    SET TipoResiduoID = trash_types.trash_type_id
    FROM trash_types
    WHERE trash_types.name = #RecipientLogTVP.TipoResiduo
    -- 6.3 conseguir un recipiente random del tipo de recipiente
    UPDATE #RecipientLogTVP
    SET RecipienteID = recipients.recipient_id
    FROM recipients
    WHERE recipients.recipient_type_id = #RecipientLogTVP.TipoRecipienteID
    AND recipients.producer_id = @ProducerID

	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION
	END

	BEGIN TRY
		SET @CustomError = 2001

        -- check temp table exists and has more than 0 rows
        IF NOT EXISTS (
            SELECT *
            FROM #RecipientLogTVP
        ) BEGIN
            RAISERROR('No hay recipientes para registrar', 16, 1)
        END
		-- check collection point exists
        IF @CollectionPointID IS NULL BEGIN
            RAISERROR('El punto de recoleccion no existe', 16, 1)
        END
        -- check service contract exists
        IF @ServiceContractID IS NULL BEGIN
            RAISERROR('El contrato de servicio no existe', 16, 1)
        END
        -- check collector exists
        IF @CollectorID IS NULL BEGIN
            RAISERROR('El recolector no existe', 16, 1)
        END
        -- check fleet exists
        IF @FleetID IS NULL BEGIN
            RAISERROR('El flete no existe', 16, 1)
        END

        -- 7. insertar en la tabla de recolecciones
        INSERT INTO collection_log (
            collection_point_id,
            service_contract_id,
            datetime,
            responsible_person_id,
            fleet_id,
			checksum
        )
        OUTPUT (INSERTED.collection_log_id) INTO #TempCollectionID

        VALUES
        (
            @CollectionPointID,
            @ServiceContractID,
            @Now,
            @CollectorID,
            @FleetID,
            CHECKSUM(@CollectionPointID, @ServiceContractID, @Now, @CollectorID, @FleetID)
        )

		-- get tempCollectionID value back
		SELECT @CollectionID = collection_log_id FROM #TempCollectionID;
		DROP TABLE #TempCollectionID;

        -- check TipoRecipienteID exists for each row
        IF EXISTS (
            SELECT *
            FROM #RecipientLogTVP
            WHERE TipoRecipienteID IS NULL
        ) BEGIN
            RAISERROR('El tipo de recipiente no existe', 16, 1)
        END

        -- check weight is positive for each row
        IF EXISTS (
            SELECT *
            FROM #RecipientLogTVP
            WHERE Peso <= 0
        ) BEGIN
            RAISERROR('El peso debe ser positivo', 16, 1)
        END

        -- check RecipienteID exists for each row
        IF EXISTS (
            SELECT *
            FROM #RecipientLogTVP
            WHERE RecipienteID IS NULL
        ) BEGIN
            RAISERROR('El recipiente no existe', 16, 1)
        END

        -- check TipoResiduoID exists for each row
        IF EXISTS (
            SELECT *
            FROM #RecipientLogTVP
            WHERE TipoResiduoID IS NULL
        ) BEGIN
            RAISERROR('El tipo de residuo no existe', 16, 1)
        END

        -- 8. insertar en la tabla de recipientes
        INSERT INTO recipient_log (
            collection_log_id,
            recipient_id,
            trash_type_id,
            movement_type_id,
            weight,
            datetime
        )
        SELECT
            @CollectionID,
            RecipienteID,
            TipoResiduoID,
            Accion,
            Peso,
            @Now
        FROM #RecipientLogTVP

		IF @InicieTransaccion=1 BEGIN
			COMMIT
		END
	END TRY
	BEGIN CATCH
		SET @ErrorNumber = ERROR_NUMBER()
		SET @ErrorSeverity = ERROR_SEVERITY()
		SET @ErrorState = ERROR_STATE()
		SET @Message = ERROR_MESSAGE()

		IF @InicieTransaccion=1 BEGIN
			ROLLBACK
		END
		RAISERROR('%s - Error Number: %i',
			@ErrorSeverity, @ErrorState, @Message, @CustomError)
	END CATCH
END
RETURN 0
GO
