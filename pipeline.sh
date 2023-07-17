#!/bin/bash
# ejecutar tests
# ejecutar coverage tests
# construir y subir
# deplegar la app en kubernetes
minikube start
eval $(minikube -p minikube docker-env)
docker build -t cg-prod-1 -f Dockerfile_production .

cd database
kubectl apply -f configmap-db.yaml
kubectl apply -f secret-db.yaml
kubectl apply -f storage.yaml
kubectl apply -f deployment-db.yaml
kubectl apply -f service-db.yaml

cd ../application
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap migrations --from-file=migrations.sh
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
echo "Waiting on pods to start..."
sleep 10s
kubectl port-forward service/app-service 8080:80