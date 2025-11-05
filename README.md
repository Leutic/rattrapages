# Projet de Paiement - Architecture Microservices

## 1. À propos de ce projet

Bienvenue dans ce projet de plateforme de paiement ! Il est conçu pour démontrer une architecture moderne, robuste et scalable en utilisant des **microservices**.

### Qu'est-ce qu'un microservice ?

Imaginez une grande application (comme un site e-commerce) découpée en plusieurs petites applications indépendantes. Chaque petite application a une seule responsabilité. Par exemple :

-   Un service gère uniquement les comptes utilisateurs (`auth-service`).
-   Un autre gère uniquement les commandes (`order-service`).
-   Un troisième gère uniquement la facturation (`invoice-service`).
-   Un dernier gère uniquement les notifications (`notification-service`).

Ces petites applications sont appelées des **microservices**. Elles communiquent entre elles pour accomplir des tâches complexes, mais restent indépendantes les unes des autres.

### Quel est le problème résolu ici ?

Dans une application traditionnelle (appelée "monolithique"), si une petite partie de l'application plante (par exemple, la facturation), toute l'application devient inutilisable. De plus, si beaucoup de gens passent des commandes en même temps, toute l'application ralentit.

Avec les microservices, si le service de facturation tombe en panne, les clients peuvent toujours créer des comptes et passer des commandes. L'architecture est plus **résiliente** et **scalable** (on peut ajouter plus de puissance uniquement là où c'est nécessaire).

### Comment les services communiquent-ils 

Ce projet utilise **Apache Kafka**, un système de messagerie ultra-rapide et fiable. Quand un événement important se produit (comme la création d'une commande), le service concerné publie un message dans Kafka. Les autres services intéressés par cet événement s'y abonnent et réagissent en conséquence.

**Exemple de flux :**
1.  Un client crée une commande via le `order-service`.
2.  `order-service` enregistre la commande et publie un message "Commande créée" dans Kafka.
3.  `invoice-service` voit ce message, le lit, et crée une facture. Il publie ensuite un message "Facture générée" dans Kafka.
4.  `notification-service` voit le message de facture, le lit, et envoie une notification au client (simulée par un message dans la console).

Cette communication est **asynchrone**, ce qui signifie que les services n'ont pas à s'attendre les uns les autres.

## 2. Technologies utilisées (la Stack)

Voici les technologies principales utilisées dans ce projet :

-   **Backend :** [Java](https://www.java.com/fr/) avec [Spring Boot](https://spring.io/projects/spring-boot). Un framework très populaire et puissant pour créer des applications web et des microservices.
-   **Messagerie :** [Apache Kafka](https://kafka.apache.org/). Le "système nerveux" de notre architecture pour une communication asynchrone et fiable entre les services.
-   **Base de Données :** [PostgreSQL](https://www.postgresql.org/). Une base de données relationnelle robuste et open-source pour stocker les données des utilisateurs, des commandes et des factures.
-   **Conteneurisation :** [Docker](https://www.docker.com/). Un outil qui permet d'emballer nos applications et leurs dépendances dans des "conteneurs" légers et portables. Cela garantit que l'application fonctionnera de la même manière partout.
-   **Orchestration :** [Docker Compose](https://docs.docker.com/compose/). Un outil pour définir et lancer des applications multi-conteneurs. Avec un seul fichier de configuration (`docker-compose.yaml`), nous pouvons lancer toute notre infrastructure (base de données, Kafka, et tous nos microservices) avec une seule commande.

## 3. Comment lancer le projet ?

Il y a deux façons de lancer ce projet :

1.  **Méthode 1 : Tout lancer avec Docker Compose (Recommandé)** - Idéal pour une démonstration rapide.
2.  **Méthode 2 : Lancer chaque microservice manuellement** - Idéal pour le développement et le débogage.

### Pré-requis

-   [Docker](https://docs.docker.com/get-docker/) doit être installé et en cours d'exécution sur votre machine.
-   [Java 17 (ou supérieur)](https://www.oracle.com/java/technologies/downloads/) et [Maven](https://maven.apache.org/download.cgi) sont nécessaires pour la méthode 2.
-   Un client `git` pour cloner le projet.

### Méthode 1 : Lancer toute l'architecture avec Docker Compose

Cette méthode est la plus simple. Elle va construire les images Docker pour chaque microservice et lancer tous les conteneurs définis dans le `docker-compose.yaml`.

1.  **Clonez le projet (si ce n'est pas déjà fait) :**
    ```sh
    git clone <URL_DU_PROJET>
    cd projet-paiement
    ```

2.  **Lancez Docker Compose :**
    À la racine du projet (où se trouve le fichier `docker-compose.yaml`), exécutez la commande suivante :
    ```sh
    docker-compose up --build
    ```
    -   `--build` : Cette option indique à Docker de construire les images de vos microservices à partir des `Dockerfile`s avant de démarrer les conteneurs.
    -   La première fois, le build peut prendre quelques minutes, car Maven doit télécharger les dépendances et compiler le code.

3.  **C'est tout !**
    Toute l'infrastructure (PostgreSQL, Kafka) et les quatre microservices sont maintenant en cours d'exécution. Vous devriez voir les logs de tous les services s'afficher dans votre terminal.

### Méthode 2 : Lancer chaque microservice manuellement

Cette méthode est utile si vous voulez développer ou déboguer un service spécifique.

1.  **Préparez le fichier `docker-compose-postgres-only.yaml` :**
    À la racine du projet, créez un fichier nommé `docker-compose-postgres-only.yaml`. Ce fichier ne lancera que l'infrastructure (PostgreSQL, Kafka, Zookeeper) nécessaire pour faire tourner vos services localement.
    (Je vous fournis le contenu de ce fichier dans une section séparée ci-dessous.)

2.  **Lancez l'infrastructure de base avec Docker Compose :**
    Dans un terminal, à la racine du projet, lancez uniquement l'infrastructure :
    ```sh
    docker-compose -f docker-compose-postgres-only.yaml up -d
    ```
    -   `-d` : L'option "detached" lance les conteneurs en arrière-plan.

3.  **Lancez chaque microservice dans un terminal séparé :**
    Ouvrez un nouveau terminal pour chaque microservice, naviguez vers son répertoire et lancez-le avec Maven.

    -   **Terminal 1 : `auth-service`**
        ```sh
        cd microservices/auth-service
        ./mvnw spring-boot:run
        ```
    -   **Terminal 2 : `order-service`**
        ```sh
        cd microservices/order-service
        ./mvnw spring-boot:run
        ```
    -   **Terminal 3 : `invoice-service`**
        ```sh
        cd microservices/invoice-service
        ./mvnw spring-boot:run
        ```
    -   **Terminal 4 : `notification-service`**
        ```sh
        cd microservices/notification-service
        ./mvnw spring-boot:run
        ```

    Chaque service va démarrer et se connecter à l'infrastructure Docker que vous avez lancée à l'étape 2.

## 4. Comment tester le flux ?

Une fois que tous les services sont lancés (avec l'une des deux méthodes), vous pouvez tester le flux de création de commande avec un outil comme `curl`, **Insomnia**, ou **Postman**.

### Créer un utilisateur (optionnel, mais bonne pratique)

-   **Méthode :** `POST`
-   **URL :** `http://localhost:8001/api/auth/register`
-   **Headers :** `Content-Type: application/json`
-   **Body (JSON) :**
    ```json
    {
        "username": "testuser",
        "email": "test@example.com",
        "password": "password123"
    }
    ```
-   **Commande `curl` équivalente :**
    ```sh
    curl -X POST http://localhost:8001/api/auth/register \
    -H "Content-Type: application/json" \
    -d '{
        "username": "testuser",
        "email": "test@example.com",
        "password": "password123"
    }'
    ```

### Créer une nouvelle commande

Cette requête va démarrer tout le flux asynchrone.

-   **Méthode :** `POST`
-   **URL :** `http://localhost:8002/api/orders`
-   **Headers :** `Content-Type: application/json`
-   **Body (JSON) :**
    ```json
    {
        "userId": 123,
        "productDescription": "Un produit fantastique",
        "quantity": 1,
        "totalPrice": 99.99
    }
    ```
-   **Commande `curl` équivalente :**
    ```sh
    curl -X POST http://localhost:8002/api/orders \
    -H "Content-Type: application/json" \
    -d '{
        "userId": 123,
        "productDescription": "Un produit fantastique",
        "quantity": 1,
        "totalPrice": 99.99
    }'
    ```

### Observez les logs

-   Dans les logs du `order-service`, vous verrez que la commande a été créée et un événement publié sur Kafka.
-   Dans les logs du `invoice-service`, vous verrez qu'il a reçu l'événement, créé une facture, et publié un nouvel événement.
-   Dans les logs du `notification-service`, vous verrez qu'il a reçu l'événement de facture et a simulé l'envoi d'une notification.

## 5. Arrêter l'application

### Pour la Méthode 1 (tout avec Docker Compose)

Pour arrêter tous les conteneurs, assurez-vous d'être dans le répertoire racine du projet et exécutez :
```sh
docker-compose down
