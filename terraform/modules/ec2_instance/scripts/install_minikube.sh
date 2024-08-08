#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker
kubectl apply -f /k8s/deployment.yaml
kubectl apply -f /k8s/service.yaml
