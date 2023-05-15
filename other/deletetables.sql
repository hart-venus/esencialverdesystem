USE esencialverdesystem;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

-- Disable all foreign key constraints
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + ' NOCHECK CONSTRAINT ' + QUOTENAME(name) + ';
'
FROM sys.foreign_keys;

-- Drop all tables
SELECT @sql += N'DROP TABLE ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + ';
'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- Re-enable all foreign key constraints
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + ' CHECK CONSTRAINT ' + QUOTENAME(name) + ';
'
FROM sys.foreign_keys;

EXEC sp_executesql @sql;
