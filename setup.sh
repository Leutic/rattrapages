#!/bin/bash

# Créer le répertoire racine du projet
mkdir -p projet-paiement
cd projet-paiement

# Nettoyer si microservices existe déjà
rm -rf microservices
mkdir -p microservices
cd microservices

echo "📦 Création du Service Authentification..."
mkdir -p temp-auth
cd temp-auth
curl -s https://start.spring.io/starter.zip \
  -d dependencies=web,security,kafka,data-jpa,postgresql,actuator \
  -d name=auth-service \
  -d type=maven-project \
  -d javaVersion=17 \
  -o auth-service.zip && unzip -o -q auth-service.zip && rm auth-service.zip
cd ..
mv temp-auth auth-service

echo "📦 Création du Service Commandes..."
mkdir -p temp-order
cd temp-order
curl -s https://start.spring.io/starter.zip \
  -d dependencies=web,kafka,data-jpa,postgresql,actuator \
  -d name=order-service \
  -d type=maven-project \
  -d javaVersion=17 \
  -o order-service.zip && unzip -o -q order-service.zip && rm order-service.zip
cd ..
mv temp-order order-service

echo "📦 Création du Service Facturation..."
mkdir -p temp-invoice
cd temp-invoice
curl -s https://start.spring.io/starter.zip \
  -d dependencies=web,kafka,data-jpa,postgresql,actuator \
  -d name=invoice-service \
  -d type=maven-project \
  -d javaVersion=17 \
  -o invoice-service.zip && unzip -o -q invoice-service.zip && rm invoice-service.zip
cd ..
mv temp-invoice invoice-service

echo "📦 Création du Service Notifications..."
mkdir -p temp-notification
cd temp-notification
curl -s https://start.spring.io/starter.zip \
  -d dependencies=web,kafka,data-jpa,postgresql,actuator \
  -d name=notification-service \
  -d type=maven-project \
  -d javaVersion=17 \
  -o notification-service.zip && unzip -o -q notification-service.zip && rm notification-service.zip
cd ..
mv temp-notification notification-service

cd ..
echo "✅ Tous les microservices ont été créés!"
tree microservices