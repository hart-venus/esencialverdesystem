EXEC sp_addlinkedserver
  @server = 'LinkedServer',
  @srvproduct = '',
  @provider = 'SQLNCLI',
  @datasrc = ''