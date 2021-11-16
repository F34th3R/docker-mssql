FROM mcr.microsoft.com/mssql/server:2019-latest AS builder
WORKDIR /app
COPY EFLOW40.bak /var/opt/mssql/backup
COPY restore.sh .

EXPOSE 1433
ENTRYPOINT ["/app/restore.sh"]

