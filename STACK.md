# Stack Technique - Projet Microservices Paiement

## 1. Justification des Choix Technologiques

### Backend : Spring Boot
**Pourquoi ?** Spring Boot offre un framework mature et intégré pour développer rapidement des microservices REST. Sa gestion des dépendances, transactions et intégration native avec Kafka facilitent la mise en place d'une architecture asynchrone. Avec seulement 3 jours, nous évitons les frameworks complexes.

### Messaging : Apache Kafka
**Pourquoi ?** Kafka garantit la communication asynchrone et fiable entre microservices. Les événements (commande créée, paiement validé, facture générée) sont publiés et consommés de manière découplée. C'est idéal pour tester la résilience : si un service tombe, les événements restent en queue.

### Base de Données : PostgreSQL
**Pourquoi ?** Base SQL robuste, gratuite et facile à conteneuriser. Parfait pour les données transactionnelles (commandes, paiements). Un seul PostgreSQL centralisé suffit pour ce projet. MongoDB n'est pas nécessaire ici.

### Conteneurisation : Docker + Docker Compose
**Pourquoi ?** Docker Compose permet de définir toute l'infrastructure (services, volumes, réseaux) dans un unique fichier YAML. Contrairement à Kubernetes, zéro courbe d'apprentissage. Le prof lance `docker-compose up` et tout démarre. Parfait pour un déploiement local + git.

### Load Balancing : NGINX
**Pourquoi ?** NGINX est léger, configurable via simple fichier texte, et fait un excellent reverse proxy. Route les requêtes HTTP vers les instances de microservices. Pas besoin de Spring Cloud Gateway (trop lourd pour 3 jours).

### Monitoring : Prometheus + Grafana
**Pourquoi ?** Prometheus scrape les métriques des services Spring Boot (CPU, requêtes, erreurs). Grafana visualise ces données en dashboards. Images Docker officielles, zéro installation. Fait impression sur le prof tout en restant simple.

---

## 2. Architecture Globale

```
┌─────────────────────────────────────────────────────────────┐
│                    DOCKER COMPOSE                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐                                              │
│  │  NGINX   │ (Port 80) - Reverse Proxy                   │
│  │ 1 instance│                                             │
│  └─────┬────┘                                             │
│        │                                                   │
│   ┌────┴────────┬──────────────┬──────────────┐           │
│   │             │              │              │           │
│ ┌─┴──┐    ┌────┴───┐    ┌────┴───┐    ┌────┴───┐        │
│ │Auth│    │Commandes│   │Facturation│  │Notif   │        │
│ │    │    │         │   │          │  │        │        │
│ │:8001│  │:8002│   │:8003│  │:8004│        │
│ └─┬──┘    └──┬──┘    └──┬──┘    └──┬──┘        │
│   │         │          │           │          │
│   └─────────┼──────────┼───────────┘          │
│             │          │                      │
│        ┌────┴──────────┴────┐                │
│        │   KAFKA BROKER     │                │
│        │  + ZOOKEEPER       │                │
│        │ (Port 9092)        │                │
│        └────────────────────┘                │
│                  │                           │
│        ┌─────────┴─────────┐               │
│        │   PostgreSQL      │               │
│        │  (Port 5432)      │               │
│        └───────────────────┘               │
│                                             │
│  ┌──────────────┐  ┌──────────────┐       │
│  │ Prometheus   │  │   Grafana    │       │
│  │ (Port 9090)  │  │ (Port 3000)  │       │
│  └──────────────┘  └──────────────┘       │
│                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Communication Entre Services

### 3.1 Flux Synchrone (HTTP REST)
- **Service Client → NGINX** : Les requêtes HTTP arrivent d'abord au NGINX
- **NGINX → Microservices** : NGINX route vers l'une des instances du microservice cible (round-robin)
- **Exemple** : Créer une commande = POST vers `http://localhost/api/orders` → routé vers une instance du service Commandes

### 3.2 Flux Asynchrone (Kafka)
- **Producteur** : Un microservice publie un événement dans un topic Kafka (ex: `order-created`)
- **Kafka** : Stocke l'événement avec réplication et persistance
- **Consommateur** : Les autres microservices subscribent au topic et reçoivent l'événement de manière asynchrone
- **Avantage** : Si un service est down, les événements attendent en queue. Quand il redémarre, il traite les événements en retard.

### 3.3 Exemple de Flux Complet (Commande)

```
1. Client lance : POST /orders
   ↓
2. NGINX reçoit → route vers Service Commandes (instance 1 ou 2)
   ↓
3. Service Commandes :
   - Valide la commande
   - L'enregistre dans PostgreSQL
   - Publie l'événement "order-created" dans Kafka
   ↓
4. Service Facturation (subscriber au topic "order-created") :
   - Reçoit l'événement
   - Génère la facture
   - Publie "invoice-generated"
   ↓
5. Service Notifications (subscriber à "invoice-generated") :
   - Reçoit l'événement
   - Envoie email/SMS au client
```

**Résultat** : Découplage total. Si Service Notifications crash, la commande et la facture existent déjà. Les notifications attendront son redémarrage.

---

## 4. Scalabilité et Résilience

### Scalabilité Horizontale
**Docker Compose** permet de lancer plusieurs instances d'un même microservice (ex: 2 instances du service Commandes). NGINX load-balance automatiquement les requêtes entre elles. Si besoin de plus de puissance : `docker-compose up --scale orders=3`

### Résilience
- **Kafka** : Événements persistants. Si un service tombe, rien ne se perd.
- **PostgreSQL** : Données centralisées et durables.
- **NGINX** : Reroute automatiquement vers instance saine si une crash.
- **Tests de charge** : Avec des outils simples (Apache JMeter ou `ab`), on peut simuler 1000 requêtes/sec et vérifier qu'aucun événement n'est perdu.

---

## 5. Avantages pour le Projet

| Avantage | Détail |
|----------|--------|
| **Rapidité** | Tout conteneurisé en 1 seul fichier. Déploiement instant. |
| **Gratuit** | Docker (gratuit), Kafka (gratuit), PostgreSQL (gratuit), NGINX (gratuit). |
| **Facilité prof** | `git clone` → `docker-compose up` → C'est prêt. |
| **Observable** | Grafana montre clairement la charge et les performances. |
| **Testable** | On peut arrêter un service et voir comment les autres réagissent. |
| **Production-ready** | Stack utilisé en vrai par des startups/PME. Pas "jouet". |

---

## 6. Fichiers à Créer

```
projet-paiement/
├── docker-compose.yml (orchestration complète)
├── nginx.conf (configuration reverse proxy)
├── microservices/
│   ├── auth-service/ (Spring Boot)
│   ├── order-service/ (Spring Boot)
│   ├── invoice-service/ (Spring Boot)
│   └── notification-service/ (Spring Boot)
├── monitoring/
│   ├── prometheus.yml (scrape les metrics)
│   └── grafana-dashboards/
└── README.md
```

---

## Conclusion

Ce stack est **réaliste, pragmatique et testable en 3 jours**. C'est exactement ce qu'une startup utiliserait pour lancer un MVP microservices. Le prof verra une vraie architecture, pas un brouillon.
