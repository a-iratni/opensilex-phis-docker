#!/bin/bash

#Chargement des variables
source ./_env.conf
source ./_tput.conf

echo ""
echo "${bold}Starting Phis containers${reset}"
sleep 1

if [ "$(docker ps -aq -f status=running -f name=phis-webapp)" ]; then
    echo "${bold}${fgRed}Phis is already running !${fgWhite}${reset}"
    exit 1
elif [ "$(docker ps -aq -f name=phis-webapp)" ]; then
    cd $DOCKER_COMPOSE_DIR
    docker-compose up -d
else
    echo "${bold}${fgRed}Phis not installed !${fgWhite}${reset}"
    exit 1
fi

# Vérification du statut des containers
cd ..
./healthcheck.sh

if [ ! "$? -ne 0" ]; then
    exit $?
fi

exit 0