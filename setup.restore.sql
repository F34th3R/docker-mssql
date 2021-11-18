-- Restoring databases
--

-- Northwind
--
RESTORE DATABASE [Northwind] FROM  DISK = N'/var/opt/mssql/backup/Northwind.bak' WITH 
FILE = 1,  MOVE N'Northwind' TO N'/var/opt/mssql/data/Northwind.mdf', 
MOVE N'Northwind_log' TO N'/var/opt/mssql/data/Northwind_log.ldf', 
REPLACE, NOUNLOAD,  STATS = 5;

-- EFLOW40
--
-- RESTORE DATABASE [EFLOW40] FROM DISK = '/var/opt/mssql/backup/EFLOW40.bak' WITH
-- MOVE N'EFLOW_YAMUNI' TO N'/var/opt/mssql/data/EFLOW_YAMUNI.mdf',
-- MOVE N'EFLOW_YAMUNI_log' TO N'/var/opt/mssql/data/EFLOW_YAMUNI_log';
