#!/bin/bash

#Chargement des variables
source ./_env.conf
source ./_tput.conf

echo ""
echo "${bold}Uninstalling Phis containers${reset}"
sleep 1

if [ ! "$(docker ps -aq -f name=phis-webapp)" ]; then
    echo "${bold}${fgRed}Phis not installed !${reset}"
    exit 1
else
    while true; do
        read -p "Are you sure you want to uninstall all Phis containers ? All data will be fully and irreversibly erased ! [${bold}${fgGreen}Y${reset}/${bold}${fgRed}N${reset}] : " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

cd $DOCKER_COMPOSE_DIR

docker-compose down -v --rmi all --remove-orphans

exit 0