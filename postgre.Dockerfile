FROM debian:buster
RUN apt-get update
RUN apt-get install postgresql-12
RUN systemctl start postgresql.service
RUN sudo -i -u postgres
RUN psql    
RUN psql -c "CREATE USER postgre WITH PASSWORD 'postgreDocker';"
RUN psql -c "CREATE DATABASE timemanager_prod;"
RUN psql -c "GRANT ALL PRIVILEGES ON DATABASE timemanager_prod TO postgre;"
# RUN psql -c "ALTER USER docker WITH SUPERUSER;"
EXPOSE 5432
CMD ["postgres", "/app/entrypoint.sh"]