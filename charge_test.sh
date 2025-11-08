#!/bin/bash
#example : ./load-test.sh 60 10

URL="http://localhost/api/orders"
DURATION=${1:-60}
REQUESTS_PER_SEC=${2:-10}
INTERVAL=$(echo "scale=2; 1 / $REQUESTS_PER_SEC" | bc)

START_TIME=$(date +%s)
END_TIME=$((START_TIME + DURATION))
COUNT=0

while [ $(date +%s) -lt $END_TIME ]; do
  curl -s -X POST "$URL" \
    -H "Content-Type: application/json" \
    -d '{"userId":1,"productDescription":"Test","quantity":5,"totalPrice":100.00}' \
    > /dev/null
  
  COUNT=$((COUNT + 1))
  echo "[$COUNT] Requête envoyée"
  
  sleep "$INTERVAL"
done

echo "Test terminé. Total requêtes: $COUNT"