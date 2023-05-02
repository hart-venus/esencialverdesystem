-- reset identity of all tables
DBCC CHECKIDENT('dbo.companies', RESEED, 0)
DBCC CHECKIDENT('dbo.people', RESEED, 0)
DBCC CHECKIDENT('dbo.contact_info_types', RESEED, 0)
