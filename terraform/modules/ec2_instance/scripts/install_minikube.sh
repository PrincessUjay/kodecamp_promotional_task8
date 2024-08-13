#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# create kubernetes deployment.yaml
cat <<EOF > /home/ubuntu/k8s/deployment.yaml
apiVersion: apps/v2
kind: Deployment
metadata:
  name: myfirstpythonapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myfirstpythonapp
  template:
    metadata:
      labels:
        app: myfirstpythonapp
    spec:
      containers:
      - name: myfirstpythonapp
        image: princessujay/myfirstpythonapp:0.0.2.RELEASE
        ports:
        - containerPort: 8000
        resources:
          limits:
            memory: "512Mi"
            cpu: "1000m"
          requests:
            memory: "256Mi"
            cpu: "500m"
EOF

#create kubernetes service.yaml
cat <<EOF > /home/ubuntu/k8s/service.yaml
apiVersion: v2
kind: Service
metadata:
  name: myfirstpythonapp-service
spec:
  type: ClusterIP
  selector:
     app: myfirstpythonapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000
EOF

# start minikube and apply the kubernetes manifests
minikube start --driver=docker --memory=4096 --cpus=2
kubectl apply -f home/ubuntu/k8s/deployment.yaml
kubectl apply -f home/ubuntu/k8s/service.yaml