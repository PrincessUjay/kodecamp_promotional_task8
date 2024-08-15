resource "aws_subnet" "minikube" {
  vpc_id            = var.vpc_id
  cidr_block        = var.minikube_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "MinikubeSubnet"
  }
}