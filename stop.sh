#!/bin/bash

#Chargement des variables
source ./_env.conf
source ./_tput.conf

echo ""
echo "${bold}Stopping Phis containers${reset}"
sleep 1

if [ ! "$(docker ps -aq -f name=phis-webapp)" ]; then
    echo "${bold}${fgRed}Phis is not installed !${reset}"
    exit 1
elif [ ! "$(docker ps -aq -f status=running -f name=phis-webapp)" ]; then
    echo "${bold}${fgRed}Phis is not running !${reset}"
    exit 1
else
    cd $DOCKER_COMPOSE_DIR
    docker-compose stop
fi

exit 0