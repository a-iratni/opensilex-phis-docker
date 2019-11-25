cd ./phis-docker

# Lancement de l'installation
docker-compose up -d

sleep 5

# Lancement des scripts pots-installation
docker exec -it --user root rdf4j /bin/bash /tmp/seed-data.sh
docker exec -it postgres /bin/bash /tmp/seed-data.sh


sleep 5

docker exec -it phis-ws -w /home/phis/phis-ws/phis2-ws mvn verify

