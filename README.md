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

### Comment les services communiquent-ils ?

Ce projet utilise **Apache Kafka**, un système de messagerie ultra-rapide et fiable. Quand un événement important se produit (comme la création d'une commande), le service concerné publie un message dans Kafka. Les autres services intéressés par cet événement s'y abonnent et réagissent en conséquence.

**Exemple de flux :**
1. Un client crée une commande via le `order-service`.
2. `order-service` enregistre la commande et publie un message "Commande créée" dans Kafka.
3. `invoice-service` voit ce message, le lit, et crée une facture. Il publie ensuite un message "Facture générée" dans Kafka.
4. `notification-service` voit le message de facture, le lit, et envoie une notification au client (simulée par un message dans la console).

Cette communication est **asynchrone**, ce qui signifie que les services n'ont pas à s'attendre les uns les autres.

## 2. Technologies utilisées (la Stack)

Voici les technologies principales utilisées dans ce projet :

-   **Backend :** [Java](https://www.java.com/fr/) avec [Spring Boot](https://spring.io/projects/spring-boot). Un framework très populaire et puissant pour créer des applications web et des microservices.
-   **Messagerie :** [Apache Kafka](https://kafka.apache.org/). Le "système nerveux" de notre architecture pour une communication asynchrone et fiable entre les services.
-   **Base de Données :** [PostgreSQL](https://www.postgresql.org/). Une base de données relationnelle robuste et open-source pour stocker les données des utilisateurs, des commandes et des factures.
-   **Conteneurisation :** [Docker](https://www.docker.com/). Un outil qui permet d'emballer nos applications et leurs dépendances dans des "conteneurs" légers et portables.
-   **Orchestration :** [Docker Compose](https://docs.docker.com/compose/). Un outil pour définir et lancer des applications multi-conteneurs. Avec un seul fichier de configuration (`docker-compose.yaml`), nous pouvons lancer toute notre infrastructure.
-   **Monitoring :** [Prometheus](https://prometheus.io/) + [Grafana](https://grafana.com/). Pour observer les performances de vos microservices en temps réel.

## 3. Pré-requis

-   [Docker](https://docs.docker.com/get-docker/) et [Docker Compose](https://docs.docker.com/compose/install/) doivent être installés et en cours d'exécution.
-   [Java 17 (ou supérieur)](https://www.oracle.com/java/technologies/downloads/) et [Maven](https://maven.apache.org/download.cgi) sont nécessaires pour construire les microservices.
-   Un client `git` pour cloner le projet.

## 4. Comment lancer le projet ?

### Étape 1 : Clonez le projet

```sh
git clone <URL_DU_PROJET>
cd projet-paiement
```

### Étape 2 : Construisez les microservices

> ⚠️ **À faire UNE FOIS au démarrage initial, puis À CHAQUE FOIS que vous modifiez le code source des microservices**

Avant de lancer Docker Compose, vous devez construire les JAR de chaque microservice. Ces fichiers JAR seront copiés dans les images Docker (voir les `Dockerfile`).

```sh
cd microservices/auth-service
./mvnw clean package -DskipTests
cd ../../microservices/order-service
./mvnw clean package -DskipTests
cd ../../microservices/invoice-service
./mvnw clean package -DskipTests
cd ../../microservices/notification-service
./mvnw clean package -DskipTests
cd ../../
```

> **Astuce :** La première fois, cette étape peut prendre quelques minutes car Maven télécharge les dépendances. Les fois suivantes, ce sera beaucoup plus rapide.

**⚠️ Important :** Si vous ne faites pas ce build et que vous lancez `docker-compose up`, Docker ne trouvera pas les fichiers JAR et les conteneurs vont crash !

### Étape 3 : Lancez Docker Compose

> ⚠️ **À faire chaque fois que vous voulez démarrer votre application**

À la racine du projet (où se trouve le fichier `docker-compose.yaml`), exécutez :

```sh
docker-compose up --build
```

-   `--build` : Cette option indique à Docker de construire les images à partir des `Dockerfile`s.
-   Tous les services (PostgreSQL, Kafka, les 4 microservices, Prometheus, Grafana, NGINX) vont démarrer.

Vous devriez voir les logs de tous les services s'afficher dans votre terminal. **Attendez quelques secondes** que tous les services soient complètement démarrés.

### Étape 4 : Vérifiez que tout fonctionne

#### Vérification avec Prometheus

1. Ouvrez votre navigateur et allez à : **http://localhost:9090/**

![Prometheus Home](assets/prometheus/prom_1.png)

2. Cliquez sur l'onglet **Status** en haut, puis sélectionnez **Targets**

![Prometheus Targets](assets/prometheus/prom_2.png)

Vous devriez voir tous les services listés avec le statut **UP** (en vert). Cela confirme que Prometheus scrape correctement les métriques de vos microservices.

## 5. Monitoring avec Grafana

> ⚠️ **À faire UNE FOIS après le premier lancement** (configuration initiale uniquement)

Maintenant que vos services fonctionnent, configurez Grafana pour visualiser les métriques en temps réel.

### Étape 1 : Accédez à Grafana

Ouvrez votre navigateur et allez à : **http://localhost:3000/**

![Grafana Home](assets/grafana/graf_1.png)

Grafana s'ouvre en accès anonyme (aucun login nécessaire).

### Étape 2 : Ajoutez Prometheus comme source de données

1. Dans le menu de gauche, cliquez sur **Connections**

![Grafana Connections](assets/grafana/graf_2.png)

2. Cliquez sur **Data sources**

3. Cliquez sur **Add data source** (en haut à droite)

![Grafana Add Data Source](assets/grafana/graf_3.png)

4. Sélectionnez **Prometheus** dans la liste

5. Dans le champ **URL**, entrez : `http://prometheus:9090`

![Grafana Prometheus URL](assets/grafana/graf_4.png)

6. Cliquez sur **Save & test** (en bas)

![Grafana Save](assets/grafana/graf_5.png)

Vous devriez voir un message de succès : "Data source is working".

### Étape 3 : Importez le dashboard

1. Dans le menu de gauche, cliquez sur **Dashboards**

![Grafana Dashboards](assets/grafana/graf_6.png)

2. Cliquez sur **New** (en haut à droite) et sélectionnez **Import**

![Grafana Import](assets/grafana/graf_7.png)

3. Sélectionnez le fichier `Grafana_dashboard.json` depuis la racine du projet

![Grafana Upload](assets/grafana/graf_8.png)

4. Cliquez sur **Import**

![Grafana Import Confirm](assets/grafana/graf_9.png)

### Étape 4 : Visualisez votre dashboard

Vous verrez maintenant un dashboard avec 4 panneaux :

![Grafana Dashboard](assets/grafana/graf_10.png)

-   **Haut gauche :** Nombre total de commandes créées
-   **Haut droit :** Uptime des services (en secondes)
-   **Bas gauche :** Utilisation mémoire (en MB)
-   **Bas droit :** Nombre de commandes par seconde (requêtes/sec)

## 6. Comment tester le flux ?

> ✅ **À faire à chaque fois que vous voulez tester votre application**

Maintenant que tous les services sont lancés et le monitoring configuré, testez le flux complet.

### Créer une commande

Utilisez `curl` ou un outil comme **Insomnia** ou **Postman** :

```sh
curl -X POST http://localhost/api/orders \
-H "Content-Type: application/json" \
-d '{
    "userId": 123,
    "productDescription": "Un produit fantastique",
    "quantity": 1,
    "totalPrice": 99.99
}'
```

> **Note :** Vous accédez à l'endpoint via **NGINX** sur le port 80 (http://localhost/api/orders), pas directement sur http://localhost:8002.


### Observer les logs

-   Dans les logs du `order-service`, vous verrez que la commande a été créée et un événement publié sur Kafka.
-   Dans les logs du `invoice-service`, vous verrez qu'il a reçu l'événement, créé une facture, et publié un nouvel événement.
-   Dans les logs du `notification-service`, vous verrez qu'il a reçu l'événement de facture et a simulé l'envoi d'une notification.

### **Générer du trafic pour les tests de charge (Phase 3.2)**

Pour tester la résilience et la scalabilité, vous pouvez utiliser les scripts que vous avez créés.

1.  **Pour Linux/WSL (Bash) :**
    Naviguez à la racine de votre projet et rendez le script exécutable si ce n'est pas déjà fait :
    ```sh
    chmod +x charge_test.sh
    ```
    Puis lancez le script, par exemple, pour 60 secondes avec 10 requêtes par seconde :
    ```sh
    ./charge_test.sh 60 10
    ```
    Vous pouvez ajuster `DURATION` (durée en secondes) et `REQUESTS_PER_SEC` (requêtes par seconde).

2.  **Pour Windows (PowerShell) :**
    Ouvrez PowerShell, naviguez à la racine de votre projet et lancez le script :
    ```powershell
    .\charge_test.ps1 -Duration 60 -RequestsPerSec 10
    ```
    Vous pouvez ajuster `-Duration` et `-RequestsPerSec`.

**Pendant que les scripts tournent, observez votre dashboard Grafana !** Vous devriez voir les graphiques s'animer, indiquant l'augmentation du nombre de requêtes, l'utilisation CPU des services, etc.


## 7. Structure du projet

```
projet-paiement/
├── docker-compose.yaml          # Orchestration de tous les services
├── nginx.conf                   # Configuration du reverse proxy
├── monitoring/
│   └── prometheus.yml           # Configuration de Prometheus
├── microservices/
│   ├── auth-service/
│   │   ├── Dockerfile           # Construit l'image Docker
│   │   ├── pom.xml              # Dépendances Maven
│   │   └── src/
│   ├── order-service/
│   │   ├── Dockerfile
│   │   ├── pom.xml
│   │   └── src/
│   ├── invoice-service/
│   │   ├── Dockerfile
│   │   ├── pom.xml
│   │   └── src/
│   └── notification-service/
│       ├── Dockerfile
│       ├── pom.xml
│       └── src/
├── Grafana_dashboard.json       # Dashboard Grafana pré-configuré
└── README.md
```

## 8. Arrêter l'application

> ✅ **À faire quand vous avez fini de développer**

Pour arrêter tous les conteneurs, à la racine du projet :

```sh
docker-compose down
```

Pour arrêter et supprimer aussi les volumes de données :

```sh
docker-compose down -v
```

## 9. Résumé : Quand faire quoi ?

| Action | Moment | Commande |
|--------|--------|----------|
| **Build des JAR** | 🔴 Démarrage initial + À chaque modification du code | `mvnw clean package` (x4) |
| **Lancer Docker** | Chaque démarrage | `docker-compose up --build` |
| **Configurer Prometheus/Grafana** | 🟢 UNE SEULE FOIS (config initiale) | Via l'interface web |
| **Tester les endpoints** | À chaque fois qu'on développe | `curl -X POST...` |
| **Arrêter** | À la fin de la session | `docker-compose down` |

**Légende :**
- 🔴 = Important : Ne pas oublier !
- 🟢 = À faire une seule fois

## 10. Architecture Dockerfile

Chaque microservice utilise un `Dockerfile` optimisé :

```dockerfile
FROM eclipse-temurin:17-jre-focal
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8001
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Explication :**
- **`FROM eclipse-temurin:17-jre-focal`** : Utilise une image Java 17 légère
- **`COPY target/*.jar app.jar`** : Copie le JAR pré-compilé (pas de recompilation à chaque build)
- **`EXPOSE`** : Expose le port du service
- **`ENTRYPOINT`** : Lance l'application au démarrage du conteneur

> **Important :** C'est pourquoi vous devez faire `mvnw clean package` avant de lancer `docker-compose up --build`. Sinon, les fichiers JAR n'existeront pas.

## 11. Installation de Maven sur Windows

> ℹ️ **Si vous êtes sur Windows et Maven n'est pas installé**

### Option 1 : Installation manuelle

1. **Téléchargez Maven** depuis [maven.apache.org](https://maven.apache.org/download.cgi)
   - Prenez la version "Binary zip archive" (ex: `apache-maven-3.9.5-bin.zip`)

2. **Extrayez le fichier** dans un dossier, par exemple : `C:\Program Files\apache-maven-3.9.5\`

3. **Ajoutez Maven aux variables d'environnement Windows :**
   - Ouvrez : **Panneau de configuration → Système → Paramètres avancés → Variables d'environnement**
   - Cliquez sur **Nouvelle** (sous "Variables utilisateur")
   - **Nom :** `MAVEN_HOME`
   - **Valeur :** `C:\Program Files\apache-maven-3.9.5` (ajustez selon votre chemin)
   - Cliquez **OK**

4. **Ajoutez Maven au PATH :**
   - Dans les variables d'environnement, sélectionnez **Path** (sous "Variables système")
   - Cliquez **Modifier**
   - Cliquez **Nouveau** et ajoutez : `%MAVEN_HOME%\bin`
   - Cliquez **OK** x2

5. **Vérifiez l'installation :** Ouvrez un terminal (CMD ou PowerShell) et tapez :
   ```cmd
   mvn --version
   ```
   Vous devriez voir la version de Maven.

### Option 2 : Installation avec Chocolatey (plus rapide)

Si vous avez [Chocolatey](https://chocolatey.org/install) installé :

```powershell
choco install maven
```

Puis vérifiez :
```cmd
mvn --version
```

---

## 12. Générer du trafic sur Windows (alternative au script Bash)

> ℹ️ **Windows n'a pas de Bash, voici les alternatives**

### Option 1 : Script PowerShell (recommandé pour Windows)

Créez un fichier `load-test.ps1` à la racine du projet :

```powershell
$url = "http://localhost/api/orders"
$headers = @{"Content-Type" = "application/json"}

while ($true) {
    $body = @{
        userId = 1
        productDescription = "Test"
        quantity = 5
        totalPrice = 100.00
    } | ConvertTo-Json

    try {
        Invoke-WebRequest -Uri $url -Method POST -Headers $headers -Body $body -ErrorAction SilentlyContinue | Out-Null
    } catch {
        # Ignore les erreurs
    }

    Start-Sleep -Milliseconds 500
}
```

Puis, ouvrez **PowerShell** en tant qu'administrateur et exécutez :

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
cd C:\chemin\vers\projet-paiement
.\load-test.ps1
```

**Astuce :** Pour arrêter le script, appuyez sur **Ctrl + C**

---

### Option 2 : Script Batch (CMD)

Créez un fichier `load-test.bat` à la racine du projet :

```batch
@echo off
:loop
curl -X POST http://localhost/api/orders ^
  -H "Content-Type: application/json" ^
  -d "{\"userId\": 1, \"productDescription\": \"Test\", \"quantity\": 5, \"totalPrice\": 100.00}"
timeout /t 1 /nobreak
goto loop
```

Puis, exécutez le fichier en double-cliquant ou via CMD :

```cmd
load-test.bat
```

> **Note :** `timeout /t 1` = attendre 1 seconde entre les requêtes. Ajustez le chiffre comme vous le souhaitez.

---

### Option 3 : Utiliser Apache Bench (AB)

Si vous avez [Apache Bench](https://httpd.apache.org/docs/current/programs/ab.html) installé (ou via [Git Bash](https://git-scm.com/)) :

```bash
ab -n 100 -c 10 -p order.json http://localhost/api/orders
```

Créez d'abord un fichier `order.json` :

```json
{"userId": 1, "productDescription": "Test", "quantity": 5, "totalPrice": 100.00}
```

---

### Option 4 : Utiliser Postman ou Insomnia

Les outils visuels comme [Postman](https://www.postman.com/) ou [Insomnia](https://insomnia.rest/) ont des features de test de charge intégrées :

1. Créez une requête POST vers `http://localhost/api/orders`
2. Utilisez leur feature "Runner" ou "Load Testing" pour envoyer plusieurs requêtes
3. Observez les résultats en temps réel

---

## 13. Troubleshooting

### Les services mettent longtemps à démarrer

Les services Spring Boot peuvent prendre **30-60 secondes** au premier démarrage. Attendez les logs `Started ... in ... seconds` dans chaque conteneur.

### Prometheus n'affiche aucune cible

Vérifiez que le fichier `monitoring/prometheus.yml` contient les bons noms de services (les hostnames Docker).

### Pas de données dans Grafana

1. Vérifiez que Prometheus scrape bien les services (http://localhost:9090/status/targets)
2. Générez du trafic avec le script `while true` ci-dessus
3. Attendez 30 secondes que Prometheus collecte les données
4. Rafraîchissez Grafana

### Erreur de port déjà utilisé

Vérifiez qu'aucun autre conteneur n'utilise les ports (80, 3000, 5433, 9090, etc.) :

```sh
docker ps -a
docker-compose ps
```

---

**Bon développement ! 🚀**