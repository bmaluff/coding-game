#!/bin/bash
echo "Iniciando Minikube"
minikube start
echo "Redirigiendo el repositorio de Docker"
eval $(minikube -p minikube docker-env)
echo "Construyendo la imagen"
docker build -t cg-prod-1 -f Dockerfile_production .

cd database
echo "Iniciando la Base de Datos"
kubectl apply -f configmap-db.yaml
kubectl apply -f secret-db.yaml
kubectl apply -f storage.yaml

echo "Iniciando el Backend"
kubectl apply -f deployment-db.yaml
kubectl apply -f service-db.yaml

echo "Iniciando el Frontend"
cd ../application
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap migrations --from-file=migrations.sh
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
echo "Esperando que el pod se levante..."
sleep 10s
kubectl port-forward service/app-service 8080:80