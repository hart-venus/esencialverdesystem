USE esencialverdesystem;
GO

IF OBJECT_ID(N'dbo.GetPeopleFullNames', N'P') IS NOT NULL
    DROP PROCEDURE dbo.GetPeopleFullNames;
GO

CREATE PROCEDURE dbo.GetPeopleFullNames
AS
BEGIN
    SET NOCOUNT ON;
    SELECT full_name FROM people;
END
GO

IF OBJECT_ID(N'dbo.GetFleetsPlates', N'P') IS NOT NULL
    DROP PROCEDURE dbo.GetFleetsPlates;
GO

CREATE PROCEDURE dbo.GetFleetsPlates
AS
BEGIN
    SET NOCOUNT ON;
    SELECT plate FROM fleets;
END
GO

IF OBJECT_ID(N'dbo.GetCollectionPointsNames', N'P') IS NOT NULL
    DROP PROCEDURE dbo.GetCollectionPointsNames;
GO

CREATE PROCEDURE dbo.GetCollectionPointsNames
AS
BEGIN
    SET NOCOUNT ON;
    SELECT name FROM collection_points WHERE is_dropoff = 1 AND active = 1;
END
GO

IF OBJECT_ID(N'dbo.GetTrashTypesNames', N'P') IS NOT NULL
    DROP PROCEDURE dbo.GetTrashTypesNames;
GO

CREATE PROCEDURE dbo.GetTrashTypesNames
AS
BEGIN
    SET NOCOUNT ON;
    SELECT name FROM trash_types;
END
GO

IF OBJECT_ID(N'dbo.GetRecipientTypesNames', N'P') IS NOT NULL
    DROP PROCEDURE dbo.GetRecipientTypesNames;
GO

CREATE PROCEDURE dbo.GetRecipientTypesNames
AS
BEGIN
    SET NOCOUNT ON;
    SELECT name FROM recipient_types;
END
GO

EXEC dbo.GetTrashTypesNames;
