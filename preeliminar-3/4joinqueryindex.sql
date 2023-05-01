-- options to support indexed views
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON;

IF OBJECT_ID('dbo.vw_companies_people_contact_info', 'V') IS NOT NULL
   DROP VIEW dbo.vw_companies_people_contact_info;

CREATE VIEW dbo.vw_companies_people_contact_info WITH SCHEMABINDING AS
SELECT dbo.companies.name AS 'company name', dbo.people.person_id AS 'person',  dbo.contact_info_types.name AS 'type', dbo.people_have_contact_info_types.value
FROM dbo.companies_have_people
INNER JOIN dbo.people ON dbo.companies_have_people.person_id = dbo.people.person_id
INNER JOIN dbo.people_have_contact_info_types ON dbo.people.person_id = dbo.people_have_contact_info_types.person_id
INNER JOIN dbo.contact_info_types ON dbo.people_have_contact_info_types.contact_info_type_id = dbo.contact_info_types.contact_info_type_id
INNER JOIN dbo.companies ON dbo.companies_have_people.company_id = dbo.companies.company_id
WHERE dbo.contact_info_types.name = 'email';
GO

CREATE UNIQUE CLUSTERED INDEX idx_vw_companies_people_contact_info
   ON dbo.vw_companies_people_contact_info (person, type);
GO
