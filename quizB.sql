-----------------------------------------------------------
-- Autor: Rnunez
-- Fecha: 12/12/2011
-- Descripcion: esta description en comentarios queda almacenada
-- Otros detalles de los parametros
-----------------------------------------------------------
-- Author: Ariel Leyva
-- Fecha: 27-04-2023
-- Desc: Inserta pais, region y compania en las tablas respectivas, asociando
-- el pais con la region y la compania con la region
-----------------------------------------------------------
CREATE PROCEDURE [dbo].[SP_LigarPais]
	@CompanyRegionData CompanyRegionType READONLY
AS
BEGIN

	SET NOCOUNT ON -- no retorne metadatos

	DECLARE @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @CustomError INT
	DECLARE @Message VARCHAR(200)
	DECLARE @InicieTransaccion BIT

	-- declaracion de otras variables

	-- operaciones de select que no tengan que ser bloqueadas
	-- tratar de hacer todo lo posible antes de q inice la transaccion

	SET @InicieTransaccion = 0
	IF @@TRANCOUNT=0 BEGIN
		SET @InicieTransaccion = 1
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		BEGIN TRANSACTION
	END

	BEGIN TRY
		SET @CustomError = 2001

		-- put your code here
		-- 1. insert into countries
		INSERT INTO countries (name)
		SELECT DISTINCT CountryName FROM @CompanyRegionData

		-- 2. insert into regions
		INSERT INTO regions (name)
		SELECT DISTINCT RegionName FROM @CompanyRegionData

		-- 3. insert into region_areas
		INSERT INTO region_areas (region_id, country_id)
		SELECT DISTINCT r.region_id, c.country_id
		FROM @CompanyRegionData AS cr
		JOIN regions AS r ON cr.RegionName = r.name
		JOIN countries AS c ON cr.CountryName = c.name

		-- 4. insert into companies
		INSERT INTO companies (name, created_at, updated_at, active)
		SELECT DISTINCT CompanyName, GETDATE(), GETDATE(), 1
		FROM @CompanyRegionData

		-- 5. insert into companies_have_regions
		INSERT INTO companies_have_regions (company_id, region_id)
		SELECT DISTINCT c.company_id, r.region_id
		FROM @CompanyRegionData AS cr
		JOIN companies AS c ON cr.CompanyName = c.name
		JOIN regions AS r ON cr.RegionName = r.name


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

-- call the procedure
DECLARE @CompanyRegionData CompanyRegionType
INSERT INTO @CompanyRegionData (CompanyName, RegionName, CountryName)
-- only 3 rows
SELECT 'Company 1', 'Region 1', 'Country 1'
UNION ALL
SELECT 'Company 2', 'Region 2', 'Country 2'
UNION ALL
SELECT 'Company 3', 'Region 3', 'Country 3'

EXEC [dbo].[SP_LigarPais] @CompanyRegionData
GO



-- drop the procedure
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_LigarPais]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SP_LigarPais]
GO

