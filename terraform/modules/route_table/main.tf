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