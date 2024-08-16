# CI/CD pipeline: Minikube Deployment with GitHub Actions, AWS and Terraform.
![Screenshot (15)](https://github.com/user-attachments/assets/c8de1f9f-c5f9-4837-849f-4d680e1cef20)
![Screenshot (14)](https://github.com/user-attachments/assets/8a84d5a1-1979-4cf4-a860-687eba5035a0)
![Screenshot (13)](https://github.com/user-attachments/assets/ca07c75a-1373-45a4-b465-0da53a20b7fc)
![Screenshot (12)](https://github.com/user-attachments/assets/2510392e-de5b-4a38-9efd-e84b14a8a2c4)
![Screenshot (11)](https://github.com/user-attachments/assets/246eb994-c58d-4a4d-89f2-8eaa1d309a5a)
![Screenshot (10)](https://github.com/user-attachments/assets/12deb01d-103a-4a84-9bf1-cb70685e1713)
![Screenshot (9)](https://github.com/user-attachments/assets/9a2d8448-1672-42a9-bc47-e8d48d3ccadc)
![Screenshot (8)](https://github.com/user-attachments/assets/463da2ca-813c-4e3b-9a55-d31f0757e709)
![Screenshot (7)](https://github.com/user-attachments/assets/303fd359-544f-4548-a503-3f68a65cf5ac)
![Screenshot (6)](https://github.com/user-attachments/assets/1496eebd-52b6-49d8-b711-754378beaf97)
![Screenshot (5)](https://github.com/user-attachments/assets/952b8064-a3c8-4c6a-a45f-415692074d35)
![Screenshot (4)](https://github.com/user-attachments/assets/5c7ed603-5588-408b-a7c9-e24212201fbd)
![Screenshot (3)](https://github.com/user-attachments/assets/f17ecaa5-1f6a-403b-953e-bed9bcd8a478)
![Screenshot (2)](https://github.com/user-attachments/assets/c6e99148-7a0c-4997-9e91-beeccad3e8c1)
![Screenshot (1)](https://github.com/user-attachments/assets/cab69112-c728-4ead-8ecb-c51a7561057c)

## Overview
This repository contains a sample project to demonstrate setting up a CI/CD pipeline with GitHub Actions to deploy a simple Python web application to a Minikube cluster running on an EC2 instance provisioned using Terraform (using Windows).

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
          ├── terraform.tfvars
          └── modules
             ├── ec2_instance
                 ├── main.tf
                 ├── outputs.tf
                 ├── scripts
                     └── install_minikube.sh
                     └── install_nginx.sh
                     └── install_postgresql.sh
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
#### 1.8: Docker Image URL
https://hub.docker.com/r/princessujay/myfirstpythonapp

#### 1.9: create a .wslconfig file 

    touch .wsl
#### 1.10: input the following for docker resources configuration

WSL configuration file

    [wsl2]
    # Set the maximum number of processors to be used
    processors=4

    # Set the maximum amount of memory to be allocated
    memory=8GB

    # Set the maximum amount of swap space to be used
    swap=4GB

    # Set the path for the WSL virtual hard disk
    # If you need to specify a custom path, uncomment and modify the following line
    # root=path/to/your/custom/root.vhdx

    root=D:\WSL\CustomRoot.vhdx

* Optional: Set the default user for WSL (change 'your-username' to your WSL username)

      defaultuser=your-username
* For the changes to take effect, restart WSL:

      wsl --shutdown

    Importance of Setting a Custom Path
    * Storage Management: If your system drive (typically C:) has limited space, placing the VHDX file on a different drive can help manage disk usage.
    * Performance: Depending on your setup, using a different drive might improve performance if that drive is faster or less utilized.
    * Data Organization: Keeping WSL data separate from other system data can make backups, migrations, or system maintenance easier.
#### 1.11: Create kubernetes Manifests 
* In your repository, create a directory called ‘k8s’ and  then enter the directory 
      
       mkdir k8s
       cd k8s
#### 1.12: Inside k8s, create these 2 files with the following contents
* deployment.yaml

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

* service.yaml:

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

#### 1.13: Add, commit, and push your Kubernetes manifests:

      git add .
      git commit -m "Add Kubernetes manifests"
      git push 

#### 1.14: Screenshots
![image](https://github.com/user-attachments/assets/ca1ef926-8ce5-4bb6-ab5a-66fc4b7f8d88)
![image](https://github.com/user-attachments/assets/96c911d1-dec7-46f9-a11d-2b2004b0c5c4)
![image](https://github.com/user-attachments/assets/ba23203d-be59-4c4c-a371-b89830b7b656)
![image](https://github.com/user-attachments/assets/c5201d85-6496-49e1-ba0f-f0bde8b2ff66)
![image](https://github.com/user-attachments/assets/07959405-bf05-488a-87ff-19474f309f1a)
![image](https://github.com/user-attachments/assets/787d7c09-b70d-44f8-a190-618a6d071863)
![image](https://github.com/user-attachments/assets/2a979450-2436-4021-b820-68885d1b25fe)

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

#### 2.3: Add, commit, and push the workflow file:

      git add .
      git commit -m "Add GitHub Actions workflow"
      git push
#### 2.4: screenshot
![image](https://github.com/user-attachments/assets/858f90b1-f3b0-4b03-b424-0ead94551b0f)

### Step 3: Set Up Terraform for EC2 and Minikube
#### 3.1 Setup AWS CLI Profile
To connect your AWS CLI to your AWS console for the user 'PrincessKodeCamp' and configure it so that Terraform can create a VPC, follow these steps:
* Create an IAM User
  - Go to the IAM section of the AWS Management Console.
  - Create a new user (if not already created) and name it eg PrincessKodeCamp.
  - Grant the user programmatic access by selecting the checkbox for Access key - Programmatic access.
  - Attach the necessary policies for VPC creation. For simplicity, you can attach the AdministratorAccess policy.
* Generate Access Keys and a keypair
  - After creating the user, you'll be given an Access Key ID, a Secret Access Key, and a keypair. Please note these down as you'll need them to configure the AWS CLI.
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
* Get the current Amazon Machine Image you will use for this project. E.g: Run this if you are using ubuntu 22.04(specify the region):

      aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" --region eu-west-1 --query "Images[*].{ID:ImageId,Name:Name}" --output table

  N/b: this will give you a table then choose the latest ami based on the release date at the end of each row line.
  
#### 3.2 Create Terraform Directory in the repository
    mkdir terraform
    cd terraform
##### Terraform Directory Structure:
Create and set up the following directory structure for it:

     ├── terraform
         └── main.tf
         └── outputs.tf
         └── variables.tf
         └── terraform.tfvars
         └── modules
            ├── ec2_instance
                └── scripts
                   ├── install_minikube.sh
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

#### Write the Terraform Configuration within the created files
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
      my_ip              = "105.112.114.206" # Run curl ifconfig.me on your terminal or visit https://www.whatismyip.com/
    }
    
    module "ec2_instance" {
      source           = "./modules/ec2_instance"
      ami              = "ami-"00bf8c84e3af174f6" # Ubuntu Server 22.04 LTS
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

terraform/terraform.tfvars

    # AWS region where the resources will be deployed
    aws_region = "eu-west-1"

    # AMI ID to use for the EC2 instances
    ami = "ami-0c38b837cd80f13bb" # Ubuntu Server 22.04 LTS

    # Instance type for the EC2 instances
    instance_type = "t2.micro"

    # SSH key pair name for EC2 access
    key_name = "KCVPCkeypair1" # Ensure this key pair exists in your AWS account

    # Path to the SSH private key file
    ssh_key_path = "C:/Users/HP/.ssh/KCVPCkeypair1.pem" # Update with the actual path to your SSH 

    # Public subnet ID (leave blank if you're creating a new subnet)
    public_subnet_id = ""

    # Private subnet ID (leave blank if you're creating a new subnet)
    private_subnet_id = ""

    # Public security group ID (leave blank if you're creating a new security group)
    public_sg_id = ""

    # Private security group ID (leave blank if you're creating a new security group)
    private_sg_id = ""

    # Minikube subnet ID (if different from public_subnet_id)
    minikube_subnet_id = "" # Typically this would be the same as public_subnet_id if Minikube is in the public subnet
    
terraform/modules/ec2_instance/main.tf

    data "aws_key_pair" "key_pair" {
      key_name           = "KCVPCkeypair1"
      include_public_key = true
    }

    resource "aws_instance" "minikube" {
      ami           = var.ami
      instance_type = var.instance_type
      subnet_id     = var.minikube_subnet_id
      security_groups = [var.minikube_sg_id]
      key_name      = data.aws_key_pair.key_pair.key_name

      tags = {
        Name = "MinikubeInstance"
      }

      user_data = file("${path.module}/scripts/install_minikube.sh")

      # provisioner "file" {
      #   source = file("${path.module}/scripts/install_minikube.sh")
      #   destination = "/tmp/install_minikube.sh"
      # }

      # provisioner "remote-exec" {
      #   inline = [
      #     "chmod +x /tmp/install_minikube.sh",
      #     "/tmp/install_minikube.sh"
      #   ]
      # }

      provisioner "file" {
        source = "C:/Users/HP/kodecamp_promotional_task8/k8s"
        destination = "/home/ubuntu/"
      }
  
      provisioner "remote-exec" {
        inline = [
          "sudo chown -R ubuntu:ubuntu /home/ubuntu/k8s",
          "ls -al /home/ubuntu/k8s"
        ]
      }
      connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("C:/Users/HP/.ssh/KCVPCkeypair1.pem")
        host = self.public_ip
      }
    }
        
terraform/modules/ec2_instance/outputs.tf

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
      default     = "eu-west-1"
    }

    variable "ami" {
      description = "AMI ID to use for the instances"
      type        = string
    }

    variable "instance_type" {
      description = "Type of EC2 instance to launch"
      type        = string
    }

    variable "minikube_sg_id" {
      description = "ID of the minikube security group"
      type        = string
    }

    variable "minikube_subnet_id" {
      description = "The ID of the subnet for the Minikube instance."
      type        = string
    }

    variable "ssh_key_path" {
      description = "The path to the SSH key for connecting to the instance."
      type        = string
    }

    variable "key_name" {
      description = "The name of the keypair."
      type        = string
    }

terraform/modules/ec2_instance/scripts/install_minikube.sh

    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    minikube start --driver=docker --memory=4096 --cpus=2
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

terraform/modules/igw/main.tf

    resource "aws_internet_gateway" "igw" {
      vpc_id = var.vpc_id
      tags = {
        Name = "KCVPC-IGW"
      }
    }
    
terraform/modules/igw/outputs.tf

    output "igw_id" {
      value = aws_internet_gateway.igw.id
    }

terraform/modules/igw/variables.tf

    variable "vpc_id" {
      description = "ID of the vpc"
      type        = string
    }

    variable "igw_id" {
      description = "ID of the internet gateway"
      type        = string
    }

terraform/modules/route_table/main.tf

    resource "aws_route_table" "minikube" {
      vpc_id = var.vpc_id
      route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.igw_id
      }
      tags = {
        Name = "MinikubeRouteTable"
      }
    }

    resource "aws_route_table_association" "minikube" {
      subnet_id      = var.minikube_subnet_id
      route_table_id = aws_route_table.minikube.id
    }

terraform/modules/route_table/outputs.tf

    output "minikube_route_table_id" {
      value = aws_route_table.minikube.id
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

    variable "minikube_subnet_id" {
      description = "ID of the public subnet to associate with the public route table"
      type        = string
    }
    
terraform/modules/security_group/main.tf

    resource "aws_security_group" "minikube_sg" {
      vpc_id = var.vpc_id
      name   = "minikube_sg"
      description = "Allow SSH and other necessary traffic"

      ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      ingress {
        from_port   = 6443
        to_port     = 6443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

terraform/modules/security_group/outputs.tf

    output "minikube_sg_id" {
      value = aws_security_group.minikube_sg.id
    }

terraform/modules/security_group/variables.tf

    variable "vpc_id" {
      description = "ID of the VPC to create security groups in"
      type        = string
    }

    variable "minikube_subnet_cidr" {
      description = "CIDR block of the public subnet"
      type        = string
    }

    variable "my_ip" {
      description = "Your public IP address for SSH access"
      type        = string
    }

terraform/modules/subnet/main.tf

    resource "aws_subnet" "minikube" {
      vpc_id            = var.vpc_id
      cidr_block        = var.minikube_subnet_cidr
      map_public_ip_on_launch = true
      tags = {
        Name = "MinikubeSubnet"
      }
    }

terraform/modules/subnet/outputs.tf

    output "minikube_subnet_id" {
      value = aws_subnet.minikube.id
    }

terraform/modules/subnet/variables.tf

    variable "vpc_id" {
      description = "ID of the VPC to create subnets in"
      type        = string
    }

    variable "minikube_subnet_cidr" {
      description = "CIDR block for the public subnet"
      type        = string
    }

terraform/modules/vpc/main.tf

    resource "aws_subnet" "minikube" {
      vpc_id            = var.vpc_id
      cidr_block        = var.minikube_subnet_cidr
      map_public_ip_on_launch = true
      tags = {
        Name = "MinikubeSubnet"
      }
    }

terraform/modules/vpc/outputs.tf
 
    output "vpc_id" {
      value = aws_vpc.main.id
    }
    
terraform/modules/vpc/variables.tf

    variable "vpc_cidr" {
      description = "CIDR block for the VPC"
      type        = string
    }

#### 3.3: Initialize Terraform
* Navigate to the root directory (terraform) and initialize Terraform 
(Run the command):

        terraform init
#### 3.4: Check if the configuration is valid 
* Run

      terraform validate
#### 3.5.0: Create a New Key Pair (if needed)
If you don’t have a key pair or want to create a new one, follow these steps: Using AWS CLI (I prefer command line):

If you have the AWS CLI installed and configured:

      aws ec2 create-key-pair --key-name KCVPCkeypair --query 'KeyMaterial' --output text > ~/.ssh/KCVPCkeypair1.pem

This command will create the key pair in AWS and store the private key in the ~/.ssh/ directory.

#### 3.5.1: Set Permissions for the Private Key
Ensure the permissions on the private key file are set correctly:

      chmod 400 ~/.ssh/KCVPCkeypair1.pem

#### 3.5.2: Add the Key to the SSH Agent (Optional)
If you want to add the key to your SSH agent (which allows you to use the key without specifying its path each time), you can do so with the following commands:

      eval "$(ssh-agent -s)"  # Start the SSH agent
      ssh-add ~/.ssh/KCVPCkeypair1.pem

This is optional but can be convenient if you frequently SSH into servers using this key.

#### 3.6: Run terraform plan if the configuration is valid but before that ensure that your terraform.tfvars file has defined variables to avoid being prompted to enter them manually when you run 'terraform plan'.

#### 3.7: Review Configuration
* Run a plan to review the changes Terraform will make by running the command:

      terraform plan -out=tfplan.json
N/b: this will make the terraform plam show in a json file located at terraform/tfplan.json
#### 3.8: Apply Configuration
Apply the Terraform configuration to create the resources:

      terraform apply
Input 'yes'
#### 3.9: Verify Resources
After applying, check the AWS Console to verify the following:
* VPC creation
* Subnets (Public and Private)
* Route Tables and NAT Gateway
* Security Groups
* Network ACLs
* EC2 Instances in respective subnets

#### 3.10: Test EC2 Instances
* Public Instance: Ensure Nginx is installed and accessible via HTTP (port 80).
* Private Instance: Ensure PostgreSQL is installed and accessible from the public instance.

#### 3.11: Login to your AWS Console to verify that all the resources were created
![image](https://github.com/user-attachments/assets/7386eee6-0e27-4126-91c5-9a34550cf2a6)
![image](https://github.com/user-attachments/assets/50c3180e-dde0-4848-8767-43de836278f0)
![image](https://github.com/user-attachments/assets/1b4fc037-e85a-48e9-aef9-dfa43379ab17)
![image](https://github.com/user-attachments/assets/d2b3111c-adaf-446e-940b-40a1c54a6533)

#### 3.12: screenshots
![image](https://github.com/user-attachments/assets/324b7ef8-c187-4ea7-b5dd-701a9dad3521)
![image](https://github.com/user-attachments/assets/d3001286-0fd0-49ca-b905-a7be1c2db5e5)
![image](https://github.com/user-attachments/assets/8c369adf-b8e9-446d-af65-586d3d56829b)
![image](https://github.com/user-attachments/assets/d0d03702-1494-4176-b4a5-f18082e23947)
![image](https://github.com/user-attachments/assets/09d9d438-f5c2-4e17-9714-3d2bafe8a1cc)
![image](https://github.com/user-attachments/assets/46ca648c-ab25-4808-80ac-bff7dcc62443)
![image](https://github.com/user-attachments/assets/0838e80f-e680-4db5-970d-3db0741580a1)
![image](https://github.com/user-attachments/assets/177a5e95-e04f-4595-b4ce-f15a7a3d8e2f)
![image](https://github.com/user-attachments/assets/bb625f46-e968-427a-91c3-44be91188022)
![image](https://github.com/user-attachments/assets/184e36b3-625d-4457-b7be-8c2e41419663)

### Step 4: Access the Minikube Cluster
#### 4.1 SSH into EC2 Instance
After Terraform apply completes, note the public IP address of your EC2 instance from the output.
* SSH into the EC2 instance using the public IP:
      
      ssh -i ~/.ssh/id_rsa ubuntu@<EC2_INSTANCE_PUBLIC_IP>
      # In this case the minikube cluster public IP

N/B: If you don’t already have OpenSSH installed on your windows system, you can do this to avoid getting an error while connecting to ssh. You can either:
* Use PowerShell to Install OpenSSH Client
      
      * Open PowerShell as Administrator: Right-click on the Start button and select Windows Terminal (Admin) or PowerShell (Admin).
      * Install OpenSSH Client: Run the following command to install the OpenSSH Client feature:

            Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

      * Verify Installation: Check if the installation was successful by running:

      ssh -V

Or

* Use Windows Package Manager (winget): If you have Windows Package Manager (winget) installed, you can use it to install OpenSSH:

      * Open Command Prompt or PowerShell: Run as Administrator.
      * Install OpenSSH Client. Run:

            winget install OpenSSH.Client

These methods should help you install OpenSSH Client.

#### 4.2: Once you ssh into your ec2-User ( for me ubuntu) successfully, Add Your User to the Docker Group by running this command while still logged in:

      sudo usermod -aG docker $USER
#### 4.3: Next, Apply the New Group Membership:
You can either log out and log back in, or use the newgrp command to apply the changes immediately:

      newgrp docker
#### 4.4: Verify Docker Access:
Check if you can run Docker commands without sudo:

      docker info
#### 4.5 start Minikube

      minikube start --driver=docker
N/b you don’t need to specify the driver since you have already specified that in the install_minikube.sh file in terraform/modules/ec2_instance/scripts 
#### 4.6 Configure
* Ensure kubectl is configured to use the Minikube cluster:

      kubectl config use-context minikube
* Verify the Minikube cluster is running:

      kubectl get nodes
* You can Port-forward the service to access it locally by running:

      kubectl port-forward service/myfirstpythonapp 8080:80
Now, access the application in your web browser at http://localhost:8080. 
#### 4.6: Screenshots
![image](https://github.com/user-attachments/assets/30298b27-683f-4c04-b5aa-bb31c7d2f291)
![image](https://github.com/user-attachments/assets/008742ce-a33b-4688-b464-79808fca0b32)
![image](https://github.com/user-attachments/assets/e8d8dfbc-8ff4-4b9e-9133-e9d380fa6d44)

### Step 5: Automate Deployment with GitHub Actions
#### 5.1: Update GitHub Actions Workflow. Ensure your GitHub Actions workflow file (deploy.yml) is correctly set up and committed.
#### 5.2: In your GitHub repository, navigate to "Settings" -> "Secrets and variables" -> "Actions".
* Add/verify these necessary secrets:
  
      DOCKER_USERNAME: Your Docker Hub username.
      DOCKER_PASSWORD: Your Docker Hub password.
      EC2_PUBLIC_IP: The public IP address of your EC2 instance.
      EC2_USER: The username for your EC2 instance (e.g., ubuntu).
      EC2_SSH_KEY: Your EC2 instance's private SSH key.
#### 5.3: Add a .gitignore file

      touch .gitignore
* Add the following content to it to enable it to ignore these large and confidential files

      terraform.tfstate
      terraform.tfstate.backup
      *.terraform
      *.tfstate
#### 5.4: Add and commit to GitHub 
      git add .
      git commit -m "Add GitHub Actions workflow"
      git push 

N/B : 
#### 5.5: Destroy Resources
To clean up all resources created by Terraform, run 

    terraform destroy

* Enter your keypair and follow the prompt to input 'yes'

#### 5.6: Screenshot
![image](https://github.com/user-attachments/assets/749b43f8-1166-49ec-b18c-04d66329aed1)
