# CI/CD pipeline: Minikube Deployment with GitHub Actions, AWS and Terraform

## Overview
This repository contains a sample project to demonstrate setting up a CI/CD pipeline with GitHub Actions to deploy a simple Python web application to a Minikube cluster running on an EC2 instance provisioned using Terraform.

## Prerequisites
- An AWS account
- A Docker Hub account
- Terraform installed on your local machine
- An SSH key pair for accessing the EC2 instance
- Git installed on your local machine

## Repository & Directory Structure

kodecamp_promotional_task8

       ├── README.md
       ├── app.py
       ├── Dockerfile
       ├── k8s
          ├── deployment.yaml
          └── service.yaml
       ├── terraform 
          ├── main.tf
          ├── outputs.tf
          ├── variables.tf
          └── modules
             ├── ec2_instance
                 ├── main.tf
                 ├── outputs.tf
                 ├── scripts
                     └── install_nginx.sh
                     └── install_postgresql.sh
                     └── install_minikube.sh
                 └── variables.tf
             ├── nat_gateway
                 ├── main.tf
                 ├── outputs.tf
                 └── variables.tf
             ├── route_table
                 ├── main.tf
                 ├── outputs.tf
                 └── variables.tf
             ├── security_group
                 ├── main.tf
                 ├── outputs.tf
                 └── variables.tf
             ├── subnet
                 ├── main.tf
                 ├── outputs.tf
                 └── variables.tf
             ├── vpc
                 ├── main.tf
                 ├── outputs.tf
                 └── variables.tf
       ├── .github
          └── workflows
             └── deploy.yml

## Steps

### Step 1: Prepare the Code Repository
#### 1.1: Create a Repository on GitHub
1. Go to GitHub(https://github.com/).
2. Click the "+" icon in the top right corner and select "New repository".
3. Enter a repository name (e.g., `kodecamp_promotional_task8`).
4. Choose the repository's visibility (public).
5. Add a readme file (You will edit this as you go with the steps you took) 
6. Click "Create repository".

#### 1.2: Clone Repository to Local machine 
1. Clone the repository to your local machine through your Terminal:

        git clone https://github.com/PrincessUjay/kodecamp_promotional_task8.git
        cd kodecamp_promotional_task8

2. Run the following commands to establish a connection with your GitHub repository 

         git remote -v
         git remote set-url origin git@github.com:PrincessUjay/kodecamp_promotional_task8.git

         #generate ssh key if needed then add it the your GitHub ssh keys 

                  ssh-keygen -t ed25519 -C "your_email@gmail.com"
                  eval "$(ssh-agent -s)"
                  ssh-add ~/.ssh/id_ed25519
                  cat ~/.ssh/id_ed25519.pub

         #Test the ssh Connection

                  ssh -T git@github.com


#### 1.3: Add Your Application Code: Create a Simple Web Application

Create a file named app.py 
    
       touch app.py
* Write the following content in the file:

      from http.server import SimpleHTTPRequestHandler, HTTPServer

      class MyHandler(SimpleHTTPRequestHandler):
          def do_GET(self):
              self.send_response(200)
              self.send_header("Content-type", "text/html")
              self.end_headers()
              self.wfile.write(b"Hello, Welcome to KodeCamp DevOps Bootcamp!")

      def run(server_class=HTTPServer, handler_class=MyHandler):
          server_address = ('', 8000)
          httpd = server_class(server_address, handler_class)
          print("Starting httpd server on port 8000...")
          httpd.serve_forever()

      if __name__ == "__main__":
          run()

#### 1.4: Dockerize the Application

* Create a Dockerfile

       touch dockerfile
* Write the following content in the file:
      
      # Base image from the official Python repository
      FROM python:3.9-slim

      # Set the working directory within the container
      WORKDIR /app

      # Copy all application files
      COPY app.py .

      # Expose port 8000
      EXPOSE 8000

      # Command to run the application
      CMD ["python", "app.py"]

#### 1.5: Add and commit your code:

      git add .
      git commit -m "Initial commit with application code and Dockerfile"
      git push

#### 1.6: Build the Docker Image
* On the terminal run:

      docker build -t myfirstpythonapp:0.0.2.RELEASE .
* Run the Docker Container Locally

      docker container run -d -p 8000:8000 myfirstpythonapp:0.0.2 can.RELEASE

* Test the Application
Open a browser and go to http://localhost:8000 to see the message "Hello, Welcome to KodeCamp DevOps Bootcamp!".

Or

Run this command to see the details of the container

      docker container ls 
#### 1.7: Tag and Push the Docker Image to Docker Hub
* Log in to Docker Hub

          docker login
N/b: you’ll be prompted to input your login credentials or it’ll authenticate with existing credentials and then show Login Succeeded. 

* tag the image
      docker tag myfirstpythonapp:0.0.2.RELEASE princessujay/myfirstpythonapp:0.0.2.RELEASE
   
   * Push the image to Docker Hub

         docker push princessujay/myfirstpythonapp:0.0.2.RELEASE

#### 1.8: Create kubernetes Manifests 
* In your repository, create a directory called ‘k8s’ and  then enter the directory 
      
       mkdir k8s
       cd k8s
#### 1.9: Inside k8s, create these 2 files with the following contents
* deployment.yaml

      apiVersion: apps/v1
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

* service.yaml:

      apiVersion: v1
      kind: Service
      metadata:
        name: myfirstpythonapp-service
      spec:
        type: LoadBalancer
        selector:
           app: myfirstpythonapp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 8000

#### 1.10: Add, commit, and push your Kubernetes manifests:

      git add .
      git commit -m "Add Kubernetes manifests"
      git push 

### Step 2: Set Up GitHub Actions
#### 2.1 Create a GitHub Actions Workflow

* In your repository, create a directory .github/workflows:

      mkdir -p .github/workflows
* Create a file named deploy.yml inside this directory 

      cd .github/workflows
      touch deploy.yml

* add the following content to the deploy.yml file

      name: Deploy to Minikube

      on:
        push:
          branches:
            - main

      jobs:
        build-and-deploy:
          runs-on: ubuntu-latest

          steps:
          - name: Checkout code
            uses: actions/checkout@v2

          - name: Set up Docker Buildx
            uses: docker/setup-buildx-action@v2

          - name: Log in to Docker Hub
            uses: docker/login-action@v2
            with:
              username: ${{ secrets.DOCKER_USERNAME }}
              password: ${{ secrets.DOCKER_PASSWORD }}

          - name: Build and Push Docker image
            uses: docker/build-push-action@v3
            with:
              context: .
              push: true
              tags: princessujay/myfirstpythonapp:0.0.2.RELEASE

          - name: SSH to EC2 and Deploy
            uses: appleboy/ssh-action@v0.1.6
            with:
              host: ${{ secrets.EC2_PUBLIC_IP }}
              username: ${{ secrets.EC2_USER }}
              key: ${{ secrets.EC2_SSH_KEY }}
              script: |
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml

#### 2.2 Add your secrets to GitHub:
* Go to your repository's "Settings".
Under "Secrets and variables", select "Actions".
* Add the following secrets:
      DOCKER_USERNAME: Your Docker Hub username.
      DOCKER_PASSWORD: Your Docker Hub password.
      EC2_PUBLIC_IP: The public IP address of your EC2 instance.
      EC2_USER: The username for your EC2 instance (e.g., ubuntu).
      EC2_SSH_KEY: Your EC2 instance's private SSH key.

#### 2.3 Add, commit, and push the workflow file:

      git add .
      git commit -m "Add GitHub Actions workflow"
      git push

### Step 3: Set Up Terraform for EC2 and Minikube
#### 3.1 Setup AWS CLI Profile
To connect your AWS CLI to your AWS console for the user 'PrincessKodeCamp' and configure it so that Terraform can create a VPC, follow these steps:
* Create an IAM User
  - Go to the IAM section of the AWS Management Console.
  - Create a new user (if not already created) and name it eg PrincessKodeCamp.
  - Grant the user programmatic access by selecting the checkbox for Access key - Programmatic access.
  - Attach the necessary policies for VPC creation. For simplicity, you can attach the AdministratorAccess policy.
* Generate Access Keys and a keypair
  - After creating the user, you'll be given an Access Key ID and a Secret Access Key as well as a keypair. Note these down as you'll need them to configure the AWS CLI.
* Configure AWS CLI
  - Open your terminal or command prompt.
  - Run the following command to configure the AWS CLI:
![Screenshot 2024-07-23 172725](https://github.com/user-attachments/assets/984fc98e-60a4-4f26-ad12-4a0c2e7b6ca0)
  - When prompted, enter the Access Key ID and Secret Access Key for PrincessKodeCamp.
    
        AWS Access Key ID [None]:                YOUR_ACCESS_KEY_ID
        AWS Secret Access Key [None]:         YOUR_SECRET_ACCESS_KEY
        Default region name [None]: eu-west-1
        Default output format [None]: json  # or your preferred output format

* Verify Configuration
To verify that your AWS CLI is configured correctly, you can run a simple command like listing your current VPCs:

    aws ec2 describe-vpcs

If the command returns a list of VPCs or an empty list, your configuration is correct. You can also list your profiles to verify by running:
  
    aws configure list-profiles
    
#### 3.2 Create Terraform Directory in the repository
    mkdir terraform
    cd terraform
##### Terraform Directory Structure:
Create and set up the following directory structure for it:

     ├── terraform

         └── main.tf

         └── outputs.tf

         └── variables.tf

         └── modules

            ├── ec2_instance

                └── scripts

                   ├── install_nginx.sh

                   ├── install_postgresql.sh

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── nat_gateway

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── route_table

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── security_group

                └── main.tf

                └── outputs.tf

                └── variables.tf

            ├── subnet

                └── main.tf

                └── outputs.tf

                └── variables.tf
            ├── vpc

                └── main.tf

                └── outputs.tf

                └── variables.tf

#### Write the Terraform Configuration within the createf files
terraform/main.tf

    provider "aws" {
      profile = "PrincessKodeCamp"
      region = "eu-west-1"
    }
    
    module "vpc" {
      source   = "./modules/vpc"
      vpc_cidr = "10.0.0.0/16"
    }
    
    module "subnet" {
      source               = "./modules/subnet"
      vpc_id               = module.vpc.vpc_id
      public_subnet_cidr   = "10.0.1.0/24"
      private_subnet_cidr  = "10.0.2.0/24"
      public_subnet_az     = "eu-west-1a"
      private_subnet_az    = "eu-west-1a"
    }
    
    module "route_table" {
      source              = "./modules/route_table"
      vpc_id              = module.vpc.vpc_id
      igw_id              = module.vpc.igw_id
      public_subnet_id    = module.subnet.public_subnet_id
      private_subnet_id   = module.subnet.private_subnet_id
    }
    
    module "nat_gateway" {
      source                  = "./modules/nat_gateway"
      public_subnet_id        = module.subnet.public_subnet_id
      private_route_table_id  = module.route_table.private_route_table_id
    }
    
    module "security_group" {
      source             = "./modules/security_group"
      vpc_id             = module.vpc.vpc_id
      public_subnet_cidr = "10.0.1.0/24"
      my_ip              = "105.112.113.236" # Run curl ifconfig.me on your terminal or visit https://www.whatismyip.com/
    }
    
    module "ec2_instance" {
      source           = "./modules/ec2_instance"
      ami              = "ami-0c38b837cd80f13bb" # Ubuntu Server 24.04 LTS
      instance_type    = "t2.micro"
      public_subnet_id = module.subnet.public_subnet_id
      private_subnet_id = module.subnet.private_subnet_id
      public_sg_id      = module.security_group.public_sg_id
      private_sg_id     = module.security_group.private_sg_id
      key_name           = var.key_name
      minikube_subnet_id = module.subnet.public_subnet_id # Assuming Minikube is in the public subnet
      ssh_key_path      = var.ssh_key_path
    }
      
terraform/outputs.tf

    output "vpc_id" {
      value = module.vpc.vpc_id
    }
    
    output "public_subnet_id" {
      value = module.subnet.public_subnet_id
    }
    
    output "private_subnet_id" {
      value = module.subnet.private_subnet_id
    }
    
    output "public_instance_id" {
      value = module.ec2_instance.public_instance_id
    }
    
    output "private_instance_id" {
      value = module.ec2_instance.private_instance_id
    }

    output "minikube_instance_id" {
      description = "The ID of the Minikube EC2 instance"
      value       = module.ec2_instance.minikube_instance_id
    }

    output "minikube_instance_public_ip" {
      description = "The public IP address of the Minikube EC2 instance"
      value       = module.ec2_instance.minikube_instance_public_ip
    }
    
terraform/variables.tf

    variable "aws_region" {
      description = "AWS region where the resources will be deployed"
      type        = string
      default     = "eu-west-1"
    }
    
    variable "ami" {
      description = "The AMI to use for the instances."
      type        = string
    }

    variable "instance_type" {
      description = "The type of instance to use."
      type        = string
    }

    variable "public_subnet_id" {
      description = "The ID of the public subnet."
      type        = string
    }

    variable "private_subnet_id" {
      description = "The ID of the private subnet."
      type        = string
    }

    variable "public_sg_id" {
      description = "The ID of the public security group."
      type        = string
    }

    variable "private_sg_id" {
      description = "The ID of the private security group."
      type        = string
    }

    variable "minikube_subnet_id" {
      description = "The ID of the subnet for the Minikube instance."
      type        = string
    }

    variable "ssh_key_path" {
      description = "The path to the SSH key to use for connecting to the instance."
      type        = string
    }

    variable "key_name" {
      description = "Name of the SSH key pair for accessing EC2 instances"
      type        = string
    }

terraform/modules/ec2_instance/main.tf

    provider "aws" {
      region = var.region
    }
    
    data "aws_key_pair" "key_pair" {
      key_name           = "KCVPCkeypair"
      include_public_key = true
    }
    
    resource "aws_instance" "public_instance" {
      ami                    = var.ami
      instance_type          = var.instance_type
      subnet_id              = var.public_subnet_id
      security_groups         = [var.public_sg_id]
      associate_public_ip_address = true
      key_name                    = data.aws_key_pair.key_pair.key_name
    
      user_data = file("${path.module}/scripts/install_nginx.sh")
    
      tags = {
        Name = "PublicInstance"
      }
    }
    
    resource "aws_instance" "private_instance" {
      ami               = var.ami
      instance_type     = var.instance_type
      subnet_id         = var.private_subnet_id
      security_groups    = [var.private_sg_id]
      key_name                    = data.aws_key_pair.key_pair.key_name
    
      user_data = file("${path.module}/scripts/install_postgresql.sh")
    
      tags = {
        Name = "PrivateInstance"
      }
    }
    
    resource "aws_instance" "minikube" {
      ami           = var.ami
      instance_type = var.instance_type
      subnet_id     = var.minikube_subnet_id
      key_name      = data.aws_key_pair.key_pair.key_name

      tags = {
        Name = "MinikubeInstance"
     }
    
     provisioner "file" {
     source      = "${path.module}/scripts/install_minikube.sh"
     destination = "/tmp/install_minikube.sh"
     }

     provisioner "remote-exec" {
       inline = [
      "chmod +x /tmp/install_minikube.sh",
      "/tmp/install_minikube.sh"
       ]
     }

     connection {
       type        = "ssh"
       user        = "ubuntu"
       private_key = file(var.ssh_key_path)
       host        = self.public_ip
     }
    }    
terraform/modules/ec2_instance/outputs.tf

    output "public_instance_id" {
      value = aws_instance.public_instance.id
    }
    
    output "public_instance_public_ip" {
      description = "The public IP address of the public EC2 instance"
      value       = aws_instance.public_instance.public_ip
    }
    
    output "private_instance_id" {
      value = aws_instance.private_instance.id
    }
    
    output "private_instance_private_ip" {
      description = "The private IP address of the private EC2 instance"
      value       = aws_instance.private_instance.private_ip
    }

    output "minikube_instance_id" {
      description = "The ID of the Minikube EC2 instance"
      value       = aws_instance.minikube.id
    }

    output "minikube_instance_public_ip" {
      description = "The public IP address of the Minikube EC2 instance"
      value       = aws_instance.minikube.public_ip
    }
    
terraform/modules/ec2_instance/variables.tf
      
    variable "region" {
      description = "The AWS region to create resources in."
      type        = string
    }
    
    variable "ami" {
      description = "AMI ID to use for the instances"
      type        = string
    }
    
    variable "instance_type" {
      description = "Type of EC2 instance to launch"
      type        = string
    }
    
    variable "public_subnet_id" {
      description = "ID of the public subnet"
      type        = string
    }
    
    variable "private_subnet_id" {
      description = "ID of the private subnet"
      type        = string
    }
    
    variable "public_sg_id" {
      description = "ID of the public security group"
      type        = string
    }
    
    variable "private_sg_id" {
      description = "ID of the private security group"
      type        = string
    }
    
    variable "minikube_subnet_id" {
      description = "The ID of the subnet for the Minikube instance."
      type        = string
    }

    variable "ssh_key_path" {
      description = "The path to the SSH key to use for connecting to the instance."
      type        = string
    }

terraform/modules/ec2_instance/scripts/install_minikube.sh

    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    minikube start --driver=docker
    kubectl apply -f /kodecamp_promotional_task8/k8s/deployment.yaml
    kubectl apply -f /kodecamp_promotional_task8/k8s/service.yaml
    
terraform/modules/ec2_instance/scripts/install_nginx.sh

    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx

terraform/modules/ec2_instance/scripts/install_postgresql.sh

    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y postgresql postgresql-contrib
    sudo systemctl start postgresql
    sudo systemctl enable postgresql

terraform/modules/nat_gateway/main.tf

    resource "aws_eip" "nat" {
      domain = "vpc"
    }
    
    resource "aws_nat_gateway" "nat" {
      allocation_id = aws_eip.nat.id
      subnet_id     = var.public_subnet_id
      tags = {
        Name = "KCVPC-NAT"
      }
    }
    
    resource "aws_route" "private_nat" {
      route_table_id         = var.private_route_table_id
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = aws_nat_gateway.nat.id
    }

terraform/modules/nat_gateway/outputs.tf

    output "nat_gateway_id" {
      value = aws_nat_gateway.nat.id
    }

terraform/modules/nat_gateway/variables.tf

    variable "public_subnet_id" {
      description = "ID of the public subnet where the NAT gateway will be created"
      type        = string
    }
    
    variable "private_route_table_id" {
      description = "ID of the private route table to associate with the NAT gateway"
      type        = string
    }

terraform/modules/route_table/main.tf

    resource "aws_route_table" "public" {
      vpc_id = var.vpc_id
      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.igw_id
      }
      tags = {
        Name = "PublicRouteTable"
      }
    }
    
    resource "aws_route_table_association" "public" {
      subnet_id      = var.public_subnet_id
      route_table_id = aws_route_table.public.id
    }
    
    resource "aws_route_table" "private" {
      vpc_id = var.vpc_id
      tags = {
        Name = "PrivateRouteTable"
      }
    }
    
    resource "aws_route_table_association" "private" {
      subnet_id      = var.private_subnet_id
      route_table_id = aws_route_table.private.id
    }

terraform/modules/route_table/outputs.tf

    output "public_route_table_id" {
      value = aws_route_table.public.id
    }
    
    output "private_route_table_id" {
      value = aws_route_table.private.id
    }

terraform/modules/route_table/variables.tf

    variable "vpc_id" {
      description = "ID of the VPC to create route tables in"
      type        = string
    }
    
    variable "igw_id" {
      description = "ID of the Internet Gateway to use for the public route table"
      type        = string
    }
    
    variable "public_subnet_id" {
      description = "ID of the public subnet to associate with the public route table"
      type        = string
    }
    
    variable "private_subnet_id" {
      description = "ID of the private subnet to associate with the private route table"
      type        = string
    }

terraform/modules/security_group/main.tf
    
    resource "aws_security_group" "public_sg" {
      vpc_id = var.vpc_id
      name   = "PublicSecurityGroup"
    
      ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    
      ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    
      ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.public_subnet_cidr]
      }
    
      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    
    resource "aws_security_group" "private_sg" {
      vpc_id = var.vpc_id
      name   = "PrivateSecurityGroup"
    
      ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = [var.public_subnet_cidr]
      }
    
      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

terraform/modules/security_group/outputs.tf

    output "public_sg_id" {
      value = aws_security_group.public_sg.id
    }
    
    output "private_sg_id" {
      value = aws_security_group.private_sg.id
    }

terraform/modules/security_group/variables.tf

    variable "vpc_id" {
      description = "ID of the VPC to create security groups in"
      type        = string
    }
    
    variable "public_subnet_cidr" {
      description = "CIDR block of the public subnet"
      type        = string
    }
    
    variable "my_ip" {
      description = "Your public IP address for SSH access"
      type        = string
    }

terraform/modules/subnet/main.tf

    resource "aws_subnet" "public" {
      vpc_id            = var.vpc_id
      cidr_block        = var.public_subnet_cidr
      availability_zone = var.public_subnet_az
      map_public_ip_on_launch = true
      tags = {
        Name = "PublicSubnet"
      }
    }
    
    resource "aws_subnet" "private" {
      vpc_id            = var.vpc_id
      cidr_block        = var.private_subnet_cidr
      availability_zone = var.private_subnet_az
      tags = {
        Name = "PrivateSubnet"
      }
    }

terraform/modules/subnet/outputs.tf

    output "public_subnet_id" {
      value = aws_subnet.public.id
    }
    
    output "private_subnet_id" {
      value = aws_subnet.private.id
    }

terraform/modules/subnet/variables.tf

    variable "vpc_id" {
      description = "ID of the VPC to create subnets in"
      type        = string
    }
    
    variable "public_subnet_cidr" {
      description = "CIDR block for the public subnet"
      type        = string
    }
    
    variable "private_subnet_cidr" {
      description = "CIDR block for the private subnet"
      type        = string
    }

terraform/modules/vpc/main.tf

    resource "aws_vpc" "main" {
      cidr_block = var.vpc_cidr
      tags = {
        Name = "KCVPC"
      }
    }
    
    resource "aws_internet_gateway" "main" {
      vpc_id = aws_vpc.main.id
      tags = {
        Name = "KCVPC-IGW"
      }
    }

terraform/modules/vpc/outputs.tf
 
    output "vpc_id" {
      value = aws_vpc.main.id
    }
    
    output "igw_id" {
      value = aws_internet_gateway.main.id
    }

terraform/modules/vpc/variables.tf

    variable "vpc_cidr" {
      description = "CIDR block for the VPC"
      type        = string
    }

### Initialize Terraform
* Navigate to the root directory (terraform) and initialize Terraform 
(Run the command terraform init):

### Check if the configuration is valid 
* Run terraform plan if the configuration is valid.
* Enter your keypair and follow the prompt to input 'yes'.

### Review Configuration
* Run a plan to review the changes Terraform will make by running the command:

      terraform plan -out=tfplan.out
  
 * Enter your keypair and follow the prompt to input 'yes' 

### Apply Configuration
Apply the Terraform configuration to create the resources:

### Verify Resources
After applying, check the AWS Console to verify the following:
* VPC creation
* Subnets (Public and Private)
* Route Tables and NAT Gateway
* Security Groups
* Network ACLs
* EC2 Instances in respective subnets

### Test EC2 Instances
* Public Instance: Ensure Nginx is installed and accessible via HTTP (port 80).
* Private Instance: Ensure PostgreSQL is installed and accessible from the public instance.

### Make the tfplan show in a json file

### Login to your AWS Console to verify that all the resources were created

### Step 4: Access the Minikube Cluster
#### 4.1 SSH into EC2 Instance
After Terraform apply completes, note the public IP address of your EC2 instance from the output.
* SSH into the EC2 instance using the public IP:
      
      ssh -i ~/.ssh/id_rsa ubuntu@<EC2_PUBLIC_IP>
#### 4.2 Configure

* Once logged in, ensure kubectl is configured to use the Minikube cluster:

      minikube start --driver=docker
kubectl config use-context minikube
* Verify the Minikube cluster is running:

      kubectl get nodes

### Step 5: Automate Deployment with GitHub Actions
#### 5.1 Update GitHub Actions Workflow
* Ensure your GitHub Actions workflow file (deploy.yml) is correctly set up and committed.
* In your GitHub repository, navigate to "Settings" -> "Secrets and variables" -> "Actions".
* Add/verify these necessary secrets:
      DOCKER_USERNAME: Your Docker Hub username.
      DOCKER_PASSWORD: Your Docker Hub password.
      EC2_PUBLIC_IP: The public IP address of your EC2 instance.
      EC2_USER: The username for your EC2 instance (e.g., ubuntu).
      EC2_SSH_KEY: Your EC2 instance's private SSH key.

* Add and commit to GitHub 
      git add .
      git commit -m "Add GitHub Actions workflow"
      git push 

N/B :
### Destroy Resources
To clean up all resources created by Terraform, run 

    terraform destroy

* Enter your keypair and follow the prompt to input 'yes'
