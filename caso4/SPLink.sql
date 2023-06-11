CREATE PROCEDURE [dbo].[EventLogTransfer]
AS
BEGIN
    SET NOCOUNT ON;

    -- Transferir registros a la bit cora gemela en el linked server
INSERT INTO [LinkedServer].[esencialverdesystem3].[dbo].[eventlog]
    (
      level_id,
      eventdate,
      eventtype,
      source_id,
      checksum,
      username,
      referenceId1,
      referenceId2,
      value1,
      value2
    )
    SELECT
      level_id,
      eventdate,
      eventtype,
      source_id,
      checksum,
      username,
      referenceId1,
      referenceId2,
      value1,
      value2
    FROM [esencialverdesystem].[dbo].[eventlog];

    -- Eliminar registros pasados de la bit cora del sistema
        DELETE FROM esencialverdesystem.dbo.EventLog
    WHERE eventdate < DATEADD(day, -7, GETDATE());

END;