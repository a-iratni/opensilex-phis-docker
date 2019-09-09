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
        echo "postgres: ${fgRed}${bold}$HP${reset}"
    else
        echo "postgres: ${fgGreen}${bold}$HP${reset}"
    fi

    if [ $HM != "healthy" ]; then
        echo "mongodb: ${fgRed}${bold}$HM${reset}" 
    else
        echo "mongodb: ${fgGreen}${bold}$HM${reset}"
    fi

    if [ $HF != "healthy" ]; then
        echo "rdf4j: ${fgRed}${bold}$HF${reset}"
    else
        echo "rdf4j: ${fgGreen}${bold}$HF${reset}"
    fi

    if [ $HWS != "healthy" ]; then
        echo "phis-ws: ${fgRed}${bold}$HWS${reset}"
    else
        echo "phis-ws: ${fgGreen}${bold}$HWS${reset}"
    fi

    if [ $HWA != "healthy" ]; then
        echo "phis-webapp: ${fgRed}${bold}$HWA${reset}"
    else
        echo "phis-webapp: ${fgGreen}${bold}$HWA${reset}"
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