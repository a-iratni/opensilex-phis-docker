#!/bin/bash

#Chargement des variables
source ./_env.conf
source ./_tput.conf

echo ""
echo "${bold}Rebuilding Phis containers${reset}"
sleep 1

if [ "$(docker ps -aq -f name=phis-webapp)" ]; then
    cd $DOCKER_COMPOSE_DIR
    docker-compose up -d --build
else
    echo "${bold}${fgRed}Phis is not installed !${reset}"
    exit 1
fi

sleep 5

# docker exec -it --user root rdf4j /bin/bash /tmp/seed-data.sh
# docker exec -it postgres /bin/bash /tmp/seed-data.sh

cd ..
./healthcheck.sh

if [ ! "$? -ne 0" ]; then
    exit $?
fi

exit 0