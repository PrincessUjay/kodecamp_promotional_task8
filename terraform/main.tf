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
  minikube_subnet_cidr   = "10.0.1.0/24"
}

module "igw" {
  source = "./modules/igw"
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.igw.igw_id
}

module "route_table" {
  source              = "./modules/route_table"
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.igw.igw_id
  minikube_subnet_id    = module.subnet.minikube_subnet_id
}

module "security_group" {
  source             = "./modules/security_group"
  vpc_id             = module.vpc.vpc_id
  minikube_subnet_cidr = "10.0.1.0/24"
  my_ip              = "105.112.114.206" # Run curl ifconfig.me on your terminal or visit https://www.whatismyip.com/
}

module "ec2_instance" {
  source           = "./modules/ec2_instance"
  ami              = "ami-0932dacac40965a65" # Ubuntu Server
  instance_type    = "t2.medium"
  minikube_sg_id    = module.security_group.minikube_sg_id
  key_name           = var.key_name
  minikube_subnet_id = module.subnet.minikube_subnet_id
  ssh_key_path      = var.ssh_key_path
}