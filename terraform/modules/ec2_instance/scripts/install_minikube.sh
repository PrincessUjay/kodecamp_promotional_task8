#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo apt-get install -y conntrack

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

curl -LO minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

# start minikube and apply the kubernetes manifests
minikube start --driver=docker --memory=4096 --cpus=2
kubectl apply -f home/ubuntu/k8s/deployment.yaml
kubectl apply -f home/ubuntu/k8s/service.yaml
