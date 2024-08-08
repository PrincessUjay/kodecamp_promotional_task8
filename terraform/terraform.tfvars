# AWS region where the resources will be deployed
aws_region = "eu-west-1"

# AMI ID to use for the EC2 instances
ami = "ami-0c38b837cd80f13bb" # Update with your specific AMI ID if different

# Instance type for the EC2 instances
instance_type = "t2.micro"

# SSH key pair name for EC2 access
key_name = "KCVPCkeypair1" # Ensure this key pair exists in your AWS account

# Path to the SSH private key file
ssh_key_path = "C:/Users/HP/.ssh/KCVPCkeypair.pem" # Update with the actual path to your SSH key

# VPC CIDR block
vpc_cidr = "10.0.0.0/16"

# Public subnet CIDR block
public_subnet_cidr = "10.0.1.0/24"

# Private subnet CIDR block
private_subnet_cidr = "10.0.2.0/24"

# Availability zone for the public subnet
public_subnet_az = "eu-west-1a"

# Availability zone for the private subnet
private_subnet_az = "eu-west-1a"

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

# Your public IP address for SSH access (replace with your actual public IP)
my_ip = "105.112.113.236" # Run `curl ifconfig.me` to get your current public IP

