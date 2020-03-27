USE [tempdb]
GO
checkpoint
go
dbcc dropcleanbuffers
go
dbcc freesessioncache
go
dbcc freesystemcache('all')
go
DBCC SHRINKFILE (N'tempdev' , 1024)
GO
DBCC SHRINKFILE (N'tempdev2' , 1024)
GO
DBCC SHRINKFILE (N'tempdev3' , 1024)
GO
DBCC SHRINKFILE (N'tempdev4' , 1024)
GO
