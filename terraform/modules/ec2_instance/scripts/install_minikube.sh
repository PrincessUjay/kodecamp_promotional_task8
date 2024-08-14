#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker --memory=4096 --cpus=2
kubectl apply -f /kodecamp_promotional_task8/k8s/deployment.yaml
kubectl apply -f /kodecamp_promotional_task8/k8s/service.yaml
