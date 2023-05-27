CREATE PROCEDURE EventLogTransfer
AS
BEGIN
    SET NOCOUNT ON;

    -- Transferir registros a la bit�cora gemela en el linked server
    INSERT INTO [linked_server].[esencialverdesystemcopy].[dbo].[eventlogclone]
    SELECT *
    FROM [esencialverdesystem].[dbo].[eventlog];

    -- Eliminar registros pasados de la bit�cora del sistema
    DELETE FROM [esencialverdesystem].[dbo].[eventlog]
    WHERE eventdate < DATEADD(day, -7, GETDATE());
END;