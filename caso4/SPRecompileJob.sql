DECLARE @Sql NVARCHAR(MAX)

SET @Sql = ''

SELECT @Sql = @Sql + 'EXEC sp_recompile ''' + SCHEMA_NAME(schema_id) + '.' + name + ''';'
FROM sys.procedures
WHERE is_ms_shipped = 0

EXEC sp_executesql @Sql