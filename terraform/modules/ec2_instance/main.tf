data "aws_key_pair" "key_pair" {
  key_name           = "KCVPCkeypair1"
  include_public_key = true
}

resource "aws_instance" "public_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  security_groups         = [var.public_sg_id]
  associate_public_ip_address = true
  key_name                    = data.aws_key_pair.key_pair.key_name

  user_data = file("${path.module}/scripts/install_nginx.sh")

  tags = {
    Name = "PublicInstance"
  }
}

resource "aws_instance" "private_instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  subnet_id         = var.private_subnet_id
  security_groups    = [var.private_sg_id]
  key_name                    = data.aws_key_pair.key_pair.key_name

  user_data = file("${path.module}/scripts/install_postgresql.sh")

  tags = {
    Name = "PrivateInstance"
  }
}

resource "aws_instance" "minikube" {
   ami           = var.ami
   instance_type = var.instance_type
   subnet_id     = var.minikube_subnet_id
   security_groups = [var.minikube_sg_id]
   key_name      = data.aws_key_pair.key_pair.key_name

   user_data = file("${path.module}/scripts/install_minikube.sh")

   tags = {
     Name = "MinikubeInstance"
   }

   provisioner "file" {
    source = "C:/Users/HP/kodecamp_promotional_task8/k8s"
    destination = "/home/ubuntu/k8s"
   }

   provisioner "remote-exec" {
    inline = [
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/k8s",
      "ls -al /home/ubuntu/k8s"
    ]
   }
}
