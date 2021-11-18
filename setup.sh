#!/bin/bash

# wait for MSSQL server to start
export STATUS=1
i=0

while [[ $STATUS -ne 0 ]] && [[ $i -lt 60 ]]; do
	i=$i+1
	echo "*************************************************************************"
	echo "Waiting for SQL Server to start (it will fail until port is opened)..."
	/opt/mssql-tools/bin/sqlcmd -t 1 -S 127.0.0.1 -U sa -P $MSSQL_SA_PASSWORD -Q "select 1" >> /dev/null
	STATUS=$?
	sleep 1	
done

if [ $STATUS -ne 0 ]; then 
	echo "Error: MSSQL SERVER took more than 60 seconds to start up."
	exit 1
fi

echo "======= MSSQL SERVER STARTED ========" | tee -a ./config.log

# If the wideworldimportersdw is restored, we don´t need to restore it again
#
file="/var/opt/mssql/data/Northwind.mdf"
bak="/var/opt/mssql/backup/Northwind.bak"

if [ ! -f "$file" ]
then
	echo "*********** Restoring databases: Northwind, ..." | tee -a ./config.log
	/opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U sa -P $MSSQL_SA_PASSWORD -d master -i /usr/config/setup.restore.sql && rm $bak
else
  echo "*********** Attaching previously restored databases..." | tee -a ./config.log
fi
echo "*********** All done!..." | tee -a ./config.log
