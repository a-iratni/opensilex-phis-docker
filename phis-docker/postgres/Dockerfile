FROM mdillon/postgis:9.5-alpine

RUN apk add --no-cache wget

ARG PSQL_DUMP_DOWNLOAD_LINK=https://raw.githubusercontent.com/OpenSILEX/docs-community-dev/master/docs/assets/opensilex_st_dump.sql

# postgres database
WORKDIR /tmp
RUN wget $PSQL_DUMP_DOWNLOAD_LINK

ADD seed-data.sh /tmp/seed-data.sh