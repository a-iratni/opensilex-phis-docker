#!/bin/bash

# Chargement des variables
source ./_env.conf
source ./_tput.conf

# Vérification du statut des containers
echo ""
echo "Checking containers:"
sleep 1 
echo ""
echo "------------------------"
i=0
while [ $i -le 5 ]
do
    HP=`docker inspect -f "{{ .State.Health.Status }}" postgres`
    HM=`docker inspect -f "{{ .State.Health.Status }}" mongodb`
    HF=`docker inspect -f "{{ .State.Health.Status }}" rdf4j`
    HWS=`docker inspect -f "{{ .State.Health.Status }}" phis-ws`
    HWA=`docker inspect -f "{{ .State.Health.Status }}" phis-webapp`

    if [ $HP != "healthy" ]; then
        echo "postgres: ${fgRed}${bold}$HP${reset}${fgWhite}"
    else
        echo "postgres: ${fgGreen}${bold}$HP${reset}${fgWhite}"
    fi

    if [ $HM != "healthy" ]; then
        echo "mongodb: ${fgRed}${bold}$HM${reset}${fgWhite}" 
    else
        echo "mongodb: ${fgGreen}${bold}$HM${reset}${fgWhite}"
    fi

    if [ $HF != "healthy" ]; then
        echo "rdf4j: ${fgRed}${bold}$HF${reset}${fgWhite}"
    else
        echo "rdf4j: ${fgGreen}${bold}$HF${reset}${fgWhite}"
    fi

    if [ $HWS != "healthy" ]; then
        echo "phis-ws: ${fgRed}${bold}$HWS${reset}${fgWhite}"
    else
        echo "phis-ws: ${fgGreen}${bold}$HWS${reset}${fgWhite}"
    fi

    if [ $HWA != "healthy" ]; then
        echo "phis-webapp: ${fgRed}${bold}$HWA${reset}${fgWhite}"
    else
        echo "phis-webapp: ${fgGreen}${bold}$HWA${reset}${fgWhite}"
    fi  
    
    echo "------------------------"

    if [ $i -eq 5 ]
    then
        echo "ERROR: At less one container is unhealthy"
        echo "PHIS doesn't work correctly, please check the status of container using 'docker ps' or try uninstall and reinstall the containers."
        exit 1
    fi
    if [ $HP != "healthy" ] || [ $HWS != "healthy" ] || [ $HWA != "healthy" ]\
    || [ $HM != "healthy" ] || [ $HF != "healthy" ]
    then
        i=$((i+1))
        sleep 7
    else
        echo ""
        echo "All containers are available !"
        i=6
    fi

done