# INRA-MISTEA 
# OPENSILEX-PHIS Docker installation

This docker set of images build of full running OPENSILEX-PHIS instance on localhost

## Prerequesites

You need to have git, docker and docker-compose installed on your machine

[git installation](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

[docker installation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

[docker-compose installation](https://docs.docker.com/compose/install/)

## Start and install docker containers
 
To install and run OPENSILEX-PHIS, execute these commands:

```{bash}
git clone https://github.com/OpenSILEX/opensilex-phis-docker.git
cd opensilex-phis-docker
./install.sh
```

This will create volumes to store database data and web server configurations. 
It will launch images for the tomcat web service, apache php web application, rdf4j, mongodb and postgresql. 
Docker networks 'frontend' and 'backend' are also activated. 

During installation [configuration settings](#configuration-settings-during-installation) will be prompted by the installation script.

**Notes**

After this first initialization the only commands, you will have to execute to run OPENSILEX-PHIS is:

```{bash}
./start.sh
```

If you change any configuration parameters in docker-compose.yml use the following command to restart your containers:

```{bash}
./rebuild.sh
```

To stop all the running containers, execute this commands:

```{bash}
./stop.sh
```
## Configuration settings during installation

During installation configuration settings will be prompted by the installation script :

* **BASEURI**: Template URI for generating variables in the application (Ex: *http://www.opensilex.org/*)
* **APP_NAME**: Application name (Ex: *OpenSILEX*)
* **PLATFORM**: Platform id (Ex: *opensilex*)
* **PLATFORM_CODE**: Platform code (Ex: *OS*)
* **VERSION**: Source version (Ex: *3.2.5*)
* **HOSTNAME**: External address (*opensilex.example.com*)

## Access to OPENSILEX-PHIS

Once containers are up and running, you can access to OPENSILEX through the links given by the install script.

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
./uninstall.sh
```



