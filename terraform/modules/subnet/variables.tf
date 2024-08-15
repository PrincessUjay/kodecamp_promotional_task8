variable "vpc_id" {
  description = "ID of the VPC to create subnets in"
  type        = string
}

variable "minikube_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}