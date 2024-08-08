# CI/CD pipeline: Minikube Deployment with GitHub Actions, AWS and Terraform

## Overview
This repository contains a sample project to demonstrate setting up a CI/CD pipeline with GitHub Actions to deploy a simple Python web application to a Minikube cluster running on an EC2 instance provisioned using Terraform.

## Prerequisites
- An AWS account
- A Docker Hub account
- Terraform installed on your local machine
- An SSH key pair for accessing the EC2 instance
- Git installed on your local machine



## Steps

### Step 1: Prepare the Code Repository
#### 1.1 Create a Repository on GitHub
1. Go to GitHub(https://github.com/).
2. Click the "+" icon in the top right corner and select "New repository".
3. Enter a repository name (e.g., `kodecamp_promotional_task8`).
4. Choose the repository's visibility (public).
5. Add a readme file (You will edit this as you go with the steps you took) 
6. Click "Create repository".

#### 1.2 Clone Repository to Local machine 
1. Clone the repository to your local machine through your Terminal:

        git clone https://github.com/PrincessUjay/kodecamp_promotional_task8.git
        cd kodecamp_promotional_task8
