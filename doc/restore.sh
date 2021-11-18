#!/bin/bash

set -e

file="/var/opt/mssql/backup/EFLOW40.bak"
# file="/var/opt/mssql/backup/wwi.bak"

if [ ! -f "$file" ]
then
   echo "File $file does not exist, "
   exit 1
else 
   # echo "Restarting to apply the changes."
   # sudo systemctl restart mssql-server.service

   # echo "Starting SqlServr"
   # /opt/mssql/bin/sqlservr &
   # sleep 60 | echo "Waiting for 60s to start Sql Server"

   # echo "Setting RAM to 2GB usage."
   # /opt/mssql/bin/mssql-conf set memory.memorylimitmb 2048

   # echo "Restarting to apply the changes."
   # sudo systemctl restart mssql-server.service

   # /opt/mssql-tools/bin/sqlcmd -S localhost \
   # -U SA -P 'secretP@assword' \
   # -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/wwi.bak"' \
   # | tr -s ' ' | cut -d ' ' -f 1-2

   # /opt/mssql-tools/bin/sqlcmd \
   # -S localhost -U SA -P 'secretP@assword' \
   # -Q 'RESTORE DATABASE WideWorldImporters FROM DISK = "/var/opt/mssql/backup/wwi.bak" WITH MOVE "WWI_Primary" TO "/var/opt/mssql/data/WideWorldImporters.mdf", MOVE "WWI_UserData" TO "/var/opt/mssql/data/WideWorldImporters_userdata.ndf", MOVE "WWI_Log" TO "/var/opt/mssql/data/WideWorldImporters.ldf", MOVE "WWI_InMemory_Data_1" TO "/var/opt/mssql/data/WideWorldImporters_InMemory_Data_1"'

   # /opt/mssql-tools/bin/sqlcmd \
   # -S localhost -U SA -P 'secretP@assword' \
   # -Q 'SELECT Name FROM sys.Databases'

   #############################################################33

   # echo "Starting SqlServr"
   # /opt/mssql/bin/sqlservr &
   # sleep 60 | echo "Waiting for 60s to start Sql Server"

   # echo "Setting RAM to 2GB usage."
   # /opt/mssql/bin/mssql-conf set memory.memorylimitmb 2048

   # echo "Restarting to apply the changes."
   # sudo systemctl restart mssql-server.service

   # Change the SA password
   echo "Change the SA password"
   /opt/mssql-tools/bin/sqlcmd \
      -S localhost -U SA -P 'secretP@assword' \
      -Q 'ALTER LOGIN SA WITH PASSWORD="secretP@assword"'

   # Copy a backup file into the container
   # echo "Copy a backup file into the container"
   # /opt/mssql-tools/bin/sqlcmd -S localhost \
   #    -U SA -P 'secretP@assword' \
   #    -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/EFLOW40.bak"' \
   #    | tr -s ' ' | cut -d ' ' -f 1-2

   # Restore the database
   echo "Restore the database"
   /opt/mssql-tools/bin/sqlcmd \
      -S localhost -U SA -P 'secretP@assword' \
      -Q 'RESTORE DATABASE EFLOW40 FROM DISK = "/var/opt/mssql/backup/EFLOW40.bak" WITH MOVE "EFLOW_YAMUNI" TO "/var/opt/mssql/data/EFLOW_YAMUNI.mdf", MOVE "EFLOW_YAMUNI_log" TO "/var/opt/mssql/data/EFLOW_YAMUNI_log"'

   # Check 
   echo "checking"
   /opt/mssql-tools/bin/sqlcmd \
      -S localhost -U SA -P 'secretP@assword' \
      -Q 'SELECT Name FROM sys.Databases'

   echo "RM!!"
   rm /var/opt/mssql/backup/EFLOW40.bak

   echo "Done!"
fi

exec "$@"

