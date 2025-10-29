# Projet de rattrapage Technologies Web Avancées 1 & 2

**Conception et déploiement d’une architecture microservices scalable avec Spring Boot, JEE, Docker, Cloud et Apache Kafka pour la gestion intelligente des transactions en temps réel**

## Problématique

Dans un contexte de digitalisation croissante, les entreprises font face à des volumes massifs de données et d’événements. Les architectures monolithiques atteignent rapidement leurs limites face à la montée en charge et à la tolérance aux pannes.

**Comment concevoir une architecture microservices cloud-native capable de traiter des transactions en temps réel avec haute disponibilité et résilience, tout en garantissant la communication asynchrone entre les services ?**

## Objectif général

Développer et déployer une application distribuée basée sur Spring Boot et JEE, conteneurisée avec Docker, orchestrée avec un système de messagerie et load balancer pour la scalabilité (OpenStack local), intégrant Kafka.

## Objectifs spécifiques

1. Concevoir une architecture microservices (authentification, gestion utilisateur, facturation)
2. Mettre en place un système de communication Spring Boot asynchrone avec Apache Kafka
3. Conteneuriser les microservices avec Docker et les déployer sur un cluster cloud
4. Intégrer un load balancer (NGINX/HAProxy/Spring Cloud Gateway) pour assurer la répartition de charge
5. Mettre en oeuvre un système de monitoring (Prometheus + Grafana) pour observer les performances
6. Tester la résilience et la scalabilité horizontale du système en situation de forte charge

## Environnement technique

### Backend
- **Java, Spring Boot, Jakarta EE (JEE 10)**

### Messaging
- **Apache Kafka**

### Base de données
- **PostgreSQL / MongoDB**

### Conteneurisation
- **Cloud : AWS, GCP ou OpenStack (selon disponibilité)**

### Load Balancing
- **NGINX / HAProxy / Spring Cloud Gateway**

### CI/CD (optionnel)
- **Jenkins / GitHub Actions**

### Monitoring
- **Prometheus, Grafana**

## Cas d’étude proposé

**Plateforme de paiement et de gestion des commandes en temps réel**

Chaque commande déclenche une série d’événements (vérification de solde, génération de facture, envoi de notification) traités par différents microservices communiquant via Kafka.

**L’objectif est de pouvoir s’adapter dynamiquement à la charge des utilisateurs et garantir la continuité de service en cas de panne d’un service ou d’un nœud.**

## Livrables attendus

1. **Diagramme d’architecture (UML + schéma Docker)**
2. **Code source complet sur GitHub**
3. **Rapport technique-composé** présentant les choix d’architecture, la scalabilité et la tolérance aux pannes
4. **Tableau comparatif des performances** avec et sans Kafka / load balancing
5. **Fichiers Docker-compose.yml**

### Monitoring, Grafana
- Mise en oeuvre d’un système de monitoring (Prometheus + Grafana) **pour observer**
- **Tester la résilience et la scalabilité horizontale du système en situation de forte charge**

## Date de présentation : Samedi 08 Novembre 2025
