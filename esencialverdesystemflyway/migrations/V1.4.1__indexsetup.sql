-- options to support indexed views
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON;

IF OBJECT_ID('dbo.vw_companies_people_contact_info', 'V') IS NOT NULL
   DROP VIEW dbo.vw_companies_people_contact_info;
