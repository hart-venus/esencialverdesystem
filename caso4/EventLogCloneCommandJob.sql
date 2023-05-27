CREATE PROCEDURE EventLogTransfer
AS
BEGIN
    SET NOCOUNT ON;

    -- Transferir registros a la bitácora gemela en el linked server
    INSERT INTO [linked_server].[esencialverdesystemcopy].[dbo].[eventlogclone]
    SELECT *
    FROM [esencialverdesystem].[dbo].[eventlog];

    -- Eliminar registros pasados de la bitácora del sistema
    DELETE FROM [esencialverdesystem].[dbo].[eventlog]
    WHERE eventdate < DATEADD(day, -7, GETDATE());
END;