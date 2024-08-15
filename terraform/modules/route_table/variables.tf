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