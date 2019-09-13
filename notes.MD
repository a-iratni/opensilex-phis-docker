#### Remarques

* Pour quelle raison utiliser la commande *sudo* dans la documentation pour l'administration des containers ? En ajoutant l'utilisateur courant au groupe de gestion des containers cela devrait fonctionner sans avoir à appeler *sudo*.

* Pour l'arrêt des containers, je pense qu'il faut privilégier la commande "docker-compose stop" à "docker-compose down". La commande *stop* détruit les containers alors que *stop* ne fait que les arrêter. Indiquez moi s'il y a une raison particulière pour laquelle *down* est préconisée.

* J'ai retiré les déclarations "ENV" dans les dockerfiles si elles étaient déjà déclarées dans le docker-compose pour éviter les confusions.

* J'ai détecté plusieurs problèmes que je ne pense pas pourvoir résoudre facilement :
    * Une fois installé, le rdf4j-workbench se connecte par défaut sur l'adresse http://*$HOTE*:8887/rdf4j-server ce qui est incorrect car cela devrait plutôt être http://localhost:8080/rdf4j-server/ (étant donné que la connexion au serveur rdf4j est géré coté serveur). En recherchant des informations sur internet sur comment était définie l'adresse par défaut, il semble qu'elle est effectivement déduite de l'adresse du workbench. Donc je ne suis pas sûr que l'on puisse résoudre ce problème.
    * Incohérence entre la version du container rdf4j-workbench (latest) et la version spécifiée présente dans le script d'initialisation de ce meme container (seed-data.sh).
        **Solution 1** : Fixer la version du container rdf4j-workbench
        **Solution 2** : Rendre variable le script seed-data.sh pour tenir compte des éventuels changements de version de rdf4j.
        **Question 1** : Est ce que c'est valable pour d'autres containers ?
