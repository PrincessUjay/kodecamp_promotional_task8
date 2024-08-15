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

variable "minikube_subnet_id" {
  description = "The ID of the subnet for the Minikube instance."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the vpc."
  type        = string
}

variable "igw_id" {
  description = "ID of the internet gateway"
  type        = string
}

variable "ssh_key_path" {
  description = "The path to the SSH key for connecting to the instance."
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair for accessing EC2 instances"
  type        = string
}