output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.subnet.public_subnet_id
}

output "private_subnet_id" {
  value = module.subnet.private_subnet_id
}

output "public_instance_id" {
  value = module.ec2_instance.public_instance_id
}

output "private_instance_id" {
  value = module.ec2_instance.private_instance_id
}

output "minikube_instance_id" {
  description = "The ID of the Minikube EC2 instance"
  value       = module.ec2_instance.minikube_instance_id
}

output "minikube_instance_public_ip" {
  description = "The public IP address of the Minikube EC2 instance"
  value       = module.ec2_instance.minikube_instance_public_ip
}
