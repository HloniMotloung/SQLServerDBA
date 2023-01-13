DECLARE @name VARCHAR(50) -- database name
DECLARE @path VARCHAR(256) -- path for backup files
DECLARE @fileName VARCHAR(256) -- filename for backup

SET @path = 'C:\Backup\'

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @fileName = @path + @name + '_' + CONVERT(VARCHAR(20),GETDATE(),112) + '.bak'
    BACKUP DATABASE @name TO DISK = @fileName WITH NOFORMAT, NOINIT, NAME = N'Full Backup of ' + @name, SKIP, NOREWIND, NOUNLOAD,  STATS = 10
    FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor

/*
This script creates a full backup of all databases, except for the system databases ('master', 'tempdb', 'model', 'msdb'), 
and saves them as files in the "C:\Backup" directory with the format of "DB_name_yyymmdd.bak". 
It uses a cursor to iterate through each database, and creates a unique filename for each backup using the GETDATE() function. 
With the "NOFORMAT, NOINIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10" options it initializes the backup, 
skip the existing backups and also provides the statistics of the backup.

You can also schedule this script to run automatically using SQL Server Agent.

Note: This script will only work if the SQL Server user running the script has the necessary permissions to create backups. Also make sure the directory where you are trying to take backup exist and you have the write permission on it.
*/