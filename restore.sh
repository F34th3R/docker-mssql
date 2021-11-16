#!/bin/bash

set -e

echo "Starting SqlServr"
  /opt/mssql/bin/sqlservr &
  sleep 60 | echo "Waiting for 60s to start Sql Server"

sudo /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P 'secretP@assword' \
   -Q 'ALTER LOGIN SA WITH PASSWORD="secretP@assword"'

echo "Setting RAM to 2GB usage."
/opt/mssql/bin/mssql-conf set memory.memorylimitmb 2048

echo "Restarting to apply the changes."
systemctl restart mssql-server.service

sudo /opt/mssql-tools/bin/sqlcmd -S localhost \
   -U SA -P 'secretP@assword' \
   -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/EFLOW40.bak"' \
   | tr -s ' ' | cut -d ' ' -f 1-2

sudo /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P 'secretP@assword' \
   -Q 'RESTORE DATABASE EFLOW40 FROM DISK = "/var/opt/mssql/backup/EFLOW40.bak" WITH MOVE "EFLOW_YAMUNI" TO "/var/opt/mssql/data/EFLOW_YAMUNI.mdf", MOVE "EFLOW_YAMUNI_log" TO "/var/opt/mssql/data/EFLOW_YAMUNI_log"'

sudo /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P 'secretP@assword' \
   -Q 'SELECT Name FROM sys.Databases'

echo "Done!"

exec "$@"

