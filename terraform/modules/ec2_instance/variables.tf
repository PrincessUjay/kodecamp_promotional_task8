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

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "public_sg_id" {
  description = "ID of the public security group"
  type        = string
}

variable "private_sg_id" {
  description = "ID of the private security group"
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