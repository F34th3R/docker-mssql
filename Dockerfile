FROM mcr.microsoft.com/mssql/server:2019-CU13-ubuntu-20.04

LABEL "MAINTAINER" "F34th3R github.com/F34th3R"
LABEL "Project" "Microsoft SQL Server"

RUN mkdir -p /var/opt/mssql/backup
WORKDIR /var/opt/mssql/backup

COPY ./backup/Northwind.bak ./

RUN mkdir -p /usr/config
WORKDIR /usr/config/

COPY setup.* ./
COPY entrypoint.sh ./

USER root
RUN chown -R 10001:0 setup.sh
RUN chown -R 10001:0 entrypoint.sh

USER 10001

RUN chmod +x setup.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "sleep infinity" ]
