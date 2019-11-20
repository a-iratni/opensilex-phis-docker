#!/bin/bash

echo ""
echo "${bold}Installing Phis containers${reset}"
sleep 1


echo ""
echo ""

# Lecture des variables passées par l'utilisateur
BASE_URI=http://www.opensilex.org/
APP_NAME=OpenSILEX
PLATFORM=opensilex
PLATFORM_CODE=OS
VERSION=3.2.5
HOST=$HOSTNAME

echo ""

echo "${fgCyan}${bold}BASEURI${reset} (Template URI for generating variables in the application): ${fgYellow}${bold}$BASE_URI${reset}"
echo "${fgCyan}${bold}APP_NAME${reset} (Application name): ${fgYellow}${bold}$APP_NAME${reset}"
echo "${fgCyan}${bold}PLATFORM${reset} (Platform id): ${fgYellow}${bold}$PLATFORM${reset}"
echo "${fgCyan}${bold}PLATFORM_CODE${reset} (Platform code): ${fgYellow}${bold}$PLATFORM_CODE${reset}"
echo "${fgCyan}${bold}VERSION${reset} (Source version): ${fgYellow}${bold}$VERSION${reset}"
echo "${fgCyan}${bold}HOSTNAME${reset} (External address): ${fgYellow}${bold}$HOST${reset}"

echo ""


    
cd $DOCKER_COMPOSE_DIR

# Creation du fichier docker-compose.yml
touch docker-compose.override.yml

echo -e "version: \"3.5\"" > docker-compose.override.yml
echo -e "services:" >> docker-compose.override.yml
echo -e "   postgres:" >> docker-compose.override.yml
echo -e "      build:" >> docker-compose.override.yml
echo -e "         args:" >> docker-compose.override.yml
echo -e "            PSQL_DUMP_DOWNLOAD_LINK: $PSQL_DUMP_DOWNLOAD_LINK" >> docker-compose.override.yml
echo -e "   phis-webapp:" >> docker-compose.override.yml
echo -e "      build:" >> docker-compose.override.yml
echo -e "         args:" >> docker-compose.override.yml
echo -e "            VERSION: $VERSION" >> docker-compose.override.yml
echo -e "            PHIS_WEBAPP_PLATFORM: $PLATFORM" >> docker-compose.override.yml
echo -e "      environment:" >> docker-compose.override.yml
echo -e "         - PHIS_WS_URL=http://phis-ws:8080/$PLATFORM" >> docker-compose.override.yml
echo -e "         - PHIS_WS_DOC_URL=http://$HOST:8889/$PLATFORM" >> docker-compose.override.yml
echo -e "         - PHIS_WEBAPP_NAME=$APP_NAME" >> docker-compose.override.yml
echo -e "         - PHIS_WEBAPP_PLATFORM=$PLATFORM" >> docker-compose.override.yml
echo -e "         - PHIS_WEBAPP_HOST=$HOST" >> docker-compose.override.yml
echo -e "   phis-ws:" >> docker-compose.override.yml
echo -e "      build:" >> docker-compose.override.yml
echo -e "         args:" >> docker-compose.override.yml
echo -e "            BASE_URI: $BASE_URI" >> docker-compose.override.yml
echo -e "            PLATFORM: $PLATFORM" >> docker-compose.override.yml
echo -e "            PLATFORM_CODE: $PLATFORM_CODE" >> docker-compose.override.yml
echo -e "            PHIS_WEBAPP_HOST: $HOST" >> docker-compose.override.yml
echo -e "            VERSION: $VERSION" >> docker-compose.override.yml
echo -e "            PHIS_WS_HOST: $HOST" >> docker-compose.override.yml

# Lancement de l'installation
docker-compose up -d

sleep 5

# Lancement des scripts pots-installation
docker exec -it --user root rdf4j /bin/bash /tmp/seed-data.sh
docker exec -it postgres /bin/bash /tmp/seed-data.sh

sleep 2

cd ..
./healthcheck.sh

if [ ! "$? -ne 0" ]; then
    exit $?
fi

echo ""
echo "-----------------------------------------------------------------"
echo "API Swagger webservices: ${underline}http://$HOST:8889/$PLATFORM${reset}"
echo "Web app: ${underline}http://$HOST:8888/$PLATFORM${reset}"
echo "Rdf4J Workbench: ${underline}http://$HOST:8887/rdf4j-workbench${reset}"
echo "-----------------------------------------------------------------"
echo ""

exit 0
