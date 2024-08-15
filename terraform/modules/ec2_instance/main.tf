data "aws_key_pair" "key_pair" {
  key_name           = "KCVPCkeypair1"
  include_public_key = true
}

resource "aws_instance" "minikube" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.minikube_subnet_id
  security_groups = [var.minikube_sg_id]
  key_name      = data.aws_key_pair.key_pair.key_name

  tags = {
    Name = "MinikubeInstance"
  }

  provisioner "file" {
    source = file("C:/Users/HP/kodecamp_promotional_task8/terraform/modules/ec2_instance/scripts/install_minikube.sh")
    destination = "/tmp/install_minikube.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_minikube.sh",
      "/tmp/install_minikube.sh"
    ]
  }

  provisioner "file" {
    source = "C:/Users/HP/kodecamp_promotional_task8/k8s"
    destination = "/home/ubuntu/"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:/Users/HP/.ssh/KCVPCkeypair1.pem")
    host = self.public_ip
  }
}