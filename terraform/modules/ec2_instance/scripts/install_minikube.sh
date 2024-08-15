#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo usermod -aG docker $USER
sudo apt-get install -y conntrack
sudo install minikube-linux-amd64 /usr/local/bin/minikube

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

curl -LO minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

# start minikube and apply the kubernetes manifests