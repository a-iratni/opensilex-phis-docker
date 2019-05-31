FROM mdillon/postgis:9.5-alpine

RUN apk add --no-cache wget

# postgres database
WORKDIR /tmp
RUN wget "https://raw.githubusercontent.com/OpenSILEX/docs-community-dev/master/docs/assets/opensilex_st_dump.sql"

ADD seed-data.sh /tmp/seed-data.sh