output "minikube_instance_id" {
  description = "The ID of the Minikube EC2 instance"
  value       = aws_instance.minikube.id
}

output "minikube_instance_public_ip" {
  description = "The public IP address of the Minikube EC2 instance"
  value       = aws_instance.minikube.public_ip
}
