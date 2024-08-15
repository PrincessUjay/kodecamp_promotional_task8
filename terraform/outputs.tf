output "vpc_id" {
  value = module.vpc.vpc_id
}

output "minikube_instance_id" {
  description = "The ID of the Minikube EC2 instance"
  value       = module.ec2_instance.minikube_instance_id
}

output "igw_id" {
  description = "The ID of the Internet gateway"
  value       = module.igw.igw_id
}

output "minikube_instance_public_ip" {
  description = "The public IP address of the Minikube EC2 instance"
  value       = module.ec2_instance.minikube_instance_public_ip
}