#!/bin/bash
echo "Iniciando Minikube"
minikube start
echo "Redirigiendo el repositorio de Docker"
eval $(minikube -p minikube docker-env)
echo "Construyendo la imagen"
docker build -t cg-prod-1 -f Dockerfile_production .

cd kubernetes/database
echo "Iniciando la Base de Datos"
kubectl apply -f configmap-db.yaml
kubectl apply -f secret-db.yaml
kubectl apply -f storage.yaml

echo "Iniciando el Backend"
kubectl apply -f deployment-db.yaml
kubectl apply -f service-db.yaml

echo "Iniciando el Frontend"
cd ../application
openssl req -newkey rsa:4096 -nodes -keyout nginx.key -x509 -days 365 -out nginx.crt -subj "/C=PY/O=Coding-Game/OU=Vetting Resources/CN=*.coding-game.org"
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl create secret generic nginx-certs --from-file=./nginx.crt --from-file=./nginx.key
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap migrations --from-file=migrations.sh
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
echo "Esperando que el pod se levante..."
sleep 10s
echo "Todo Listo!! Puedes acceder a la api desde tu navegador: https://localhost:9443/api"
kubectl port-forward service/app-service 9443:443