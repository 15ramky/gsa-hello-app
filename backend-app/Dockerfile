# Using postgres latest image
FROM postgres:latest

MAINTAINER Ramakrishna Kothamasu "krishna.ubuntu@gmail.com"

# Using the environment variables instead of start-up-script
ENV POSTGRES_USER admin

# TODO(me) : Not a best ptractice to keep password in vcs, change later
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB tempdb

# TODO(me) : not needed for Kubernetes - delete leter
# EXPOSE 5432

ADD create_table.sql /docker-entrypoint-initdb.d/
