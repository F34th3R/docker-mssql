#!/bin/bash

set -e

file="EFLOW40.bak"

if [ ! -f "$file" ]
then
   echo "File $file does not exist, ...exit"
   exit 1
else 
  # Pull and run the container image
  sudo docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=secretP@ssword' \
     --name 'eflow_testing' -p 1401:1433 \
     -v eflow_testingdata:/var/opt/mssql \
     -d mcr.microsoft.com/mssql/server:2019-latest

  # Change the SA password
  sudo docker exec -it eflow_testing /opt/mssql-tools/bin/sqlcmd \
     -S localhost -U SA -P 'secretP@ssword' \
     -Q 'ALTER LOGIN SA WITH PASSWORD="secretP@ssword"'

  # Copy a backup file into the container
  sudo docker exec -it eflow_testing mkdir /var/opt/mssql/backup
  sudo docker cp EFLOW40.bak eflow_testing:/var/opt/mssql/backup
  
  # Restore the database
  sudo docker exec -it eflow_testing /opt/mssql-tools/bin/sqlcmd -S localhost \
     -U SA -P 'secretP@ssword' \
     -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/EFLOW40.bak"' \
     | tr -s ' ' | cut -d ' ' -f 1-2

  sudo docker exec -it eflow_testing /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U SA -P 'secretP@assword' \
    -Q 'RESTORE DATABASE EFLOW40 FROM DISK = "/var/opt/mssql/backup/EFLOW40.bak" WITH MOVE "EFLOW_YAMUNI" TO "/var/opt/mssql/data/EFLOW_YAMUNI.mdf", MOVE "EFLOW_YAMUNI_log" TO "/var/opt/mssql/data/EFLOW_YAMUNI_log"'
  
fi

exec "$@"

