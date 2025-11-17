Akory ramse ? 
Tsa mahay fa ity no mba vita e! 

Technologies utilisées 
Voici les technologies principales utilisées dans ce projet :

Backend : Java avec Spring Boot.
Messagerie : Apache Kafka. 
Base de Données : PostgreSQL. 
Conteneurisation : Docker. 
Orchestration : Docker Compose. 

Comment lancer le projet ?
Il y a deux façons de lancer ce projet :

Tout lancer avec Docker Compose (Recommandé) - Idéal pour une démonstration rapide.

Lancer toute l'architecture avec Docker Compose
Cette méthode est la plus simple. Elle va construire les images Docker pour chaque microservice et lancer tous les conteneurs définis dans le docker-compose.yaml.

Clonez le projet 

git clone <URL_DU_PROJET>
cd projet-paiement
Lancez Docker Compose : À la racine du projet (où se trouve le fichier docker-compose.yaml), exécutez la commande suivante :

docker-compose up --build
--build : Cette option indique à Docker de construire les images de vos microservices à partir des Dockerfiles avant de démarrer les conteneurs.
La première fois, le build peut prendre quelques minutes, car Maven doit télécharger les dépendances et compiler le code.
C'est tout ! Toute l'infrastructure (PostgreSQL, Kafka) et les quatre microservices sont maintenant en cours d'exécution. Vous devriez voir les logs de tous les services s'afficher dans votre terminal.


Comment tester le flux ?
Une fois que tous les services sont lancés (avec l'une des deux méthodes), vous pouvez tester le flux de création de commande avec un outil comme curl, Insomnia, ou Postman.

Créer un utilisateur (optionnel, mais bonne pratique)
Méthode : POST
URL : http://localhost:8001/api/auth/register
Headers : Content-Type: application/json
Body (JSON) :
{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
}
Commande curl équivalente :
curl -X POST http://localhost:8001/api/auth/register \
-H "Content-Type: application/json" \
-d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "password123"
}'
Créer une nouvelle commande
Cette requête va démarrer tout le flux asynchrone.

Méthode : POST
URL : http://localhost:8002/api/orders
Headers : Content-Type: application/json
Body (JSON) :
{
    "userId": 123,
    "productDescription": "exemple",
    "quantity": 1,
    "totalPrice": 99.99
}
Commande curl équivalente :
curl -X POST http://localhost:8002/api/orders \
-H "Content-Type: application/json" \
-d '{
    "userId": 123,
    "productDescription": "exemple",
    "quantity": 1,
    "totalPrice": 99.99
}'
Observez les logs
Dans les logs du order-service, vous verrez que la commande a été créée et un événement publié sur Kafka.
Dans les logs du invoice-service, vous verrez qu'il a reçu l'événement, créé une facture, et publié un nouvel événement.
Dans les logs du notification-service, vous verrez qu'il a reçu l'événement de facture et a simulé l'envoi d'une notification.

Arrêter l'application : docker-compose down


Misaotra betsaka dia veloma eee

docker-compose down
