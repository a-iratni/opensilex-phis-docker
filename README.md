# INRA-MISTEA OPENSILEX-PHIS installation, documentation and development files

This docker set of images build of full running OPENSILEX-PHIS instance on localhost

## Prerequesites

You need to have git, docker and docker-compose installed on your machine

[git installation](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

[docker installation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

[docker-compose installation](https://docs.docker.com/compose/install/)

## Start and install docker containers
 
To install and run OPENSILEX-PHIS, execute these commands:

```{bash}
git clone https://github.com/vincentmigot/PHIS-docker.git
cd PHIS-docker
sudo docker-compose up -d
```

This will create volumes to store database data and web server configurations. 
It will launch images for the tomcat web service, apache php web application, rdf4j, mongodb and postgresql. 
Docker networks 'frontend' and 'backend' are also activated. 

**Notes**

After this first initialization the only commands, you will have to execute to run OPENSILEX-PHIS is:

```{bash}
sudo docker-compose up -d
```

If you change any configuration parameters in docker-compose.yml use the following command to restart your containers:

```{bash}
sudo docker-compose up -d --build
```

To stop all the running containers, execute this commands:

```{bash}
sudo docker-compose down
```

## Initialize databases

Once all services are up and running execute the following command the first time to populate databases:

```
sudo docker exec -it --user root rdf4j /bin/bash /tmp/seed-data.sh
sudo docker exec -it postgres /bin/bash /tmp/seed-data.sh
```

## Access to OPENSILEX-PHIS

Once containers are up and running, you can access to OPENSILEX threw the following links:


Webapp: (http://localhost:8888/phis-webapp)

Web services: (http://localhost:8889/phis2ws)

RDF4J Workbench: (http://localhost:8887/rdf4j-workbench)

You can login on Webapp with the following credentials

As an administrator:
- Login -> admin@opensilex.org
- Password -> admin

As a guest:
- Login -> guest@opensilex.org
- Password -> guest

## Remove existing containers

**/!\ WARNING /!\\** This will destroy all the data loaded into the OPENSILEX-PHIS instance

Having your instance of OPENSILEX-PHIS running type the following commands:

```{bash}
sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)
```



