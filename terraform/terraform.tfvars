# AWS region where the resources will be deployed
aws_region = "eu-west-1"

# AMI ID to use for the EC2 instances
ami = "ami-0932dacac40965a65" # Ubuntu Server

# Instance type for the EC2 instances
instance_type = "t2.medium"

# SSH key pair name for EC2 access
key_name = "KCVPCkeypair1" # Ensure this key pair exists in your AWS account

# Path to the SSH private key file
ssh_key_path = "C:/Users/HP/.ssh/KCVPCkeypair1.pem" # Update with the actual path to your SSH 

# internet gateway ID
igw_id = ""

# vpc ID
vpc_id = ""

# Minikube subnet ID (if different from public_subnet_id)
minikube_subnet_id = "" # Typically this would be the same as public_subnet_id if Minikube is in the public subnet