#!/bin/bash

# Chargement des variables
source ./_env.conf
source ./_tput.conf

echo ""
echo "${bold}Installing Phis containers${reset}"
sleep 1

if [ "$(docker ps -aq -f name=phis-webapp)" ]; then
    echo "${bold}${fgRed}Phis is already installed !${reset}"
    exit 1
fi

echo ""
echo ""

# Lecture des variables passées par l'utilisateur
read -e -p "Please enter a value for "$'\001'$fgCyan$'\002'"BASEURI"$'\001'$reset$'\002'" (Template URI for generating variables in the application): " -i "$D_BASE_URI" BASE_URI
read -e -p "Please enter a value for "$'\001'$fgCyan$'\002'"APP_NAME"$'\001'$reset$'\002'" (Application name): " -i "$D_APP_NAME" APP_NAME
read -e -p "Please enter a value for "$'\001'$fgCyan$'\002'"PLATFORM"$'\001'$reset$'\002'" (Platform id): " -i "$D_PLATFORM" PLATFORM
read -e -p "Please enter a value for "$'\001'$fgCyan$'\002'"PLATFORM_CODE"$'\001'$reset$'\002'" (Platform code): " -i "$D_PLATFORM_CODE" PLATFORM_CODE
read -e -p "Please enter a value for "$'\001'$fgCyan$'\002'"VERSION"$'\001'$reset$'\002'" (Source version): " -i "$D_VERSION" VERSION
read -e -p "Please enter a value for "$'\001'$fgCyan$'\002'"HOSTNAME"$'\001'$reset$'\002'" (External address): " -i "$D_HOST" HOST

echo ""

echo "${fgCyan}${bold}BASEURI${reset} (Template URI for generating variables in the application): ${fgYellow}${bold}$BASE_URI${reset}"
echo "${fgCyan}${bold}APP_NAME${reset} (Application name): ${fgYellow}${bold}$APP_NAME${reset}"
echo "${fgCyan}${bold}PLATFORM${reset} (Platform id): ${fgYellow}${bold}$PLATFORM${reset}"
echo "${fgCyan}${bold}PLATFORM_CODE${reset} (Platform code): ${fgYellow}${bold}$PLATFORM_CODE${reset}"
echo "${fgCyan}${bold}VERSION${reset} (Source version): ${fgYellow}${bold}$VERSION${reset}"
echo "${fgCyan}${bold}HOSTNAME${reset} (External address): ${fgYellow}${bold}$HOST${reset}"

echo ""

while true; do
        read -p "Are you sure you want to install Pḧis with this parameters ? [${bold}${fgGreen}Y${reset}/${bold}${fgRed}N${reset}] : " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
done
    
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