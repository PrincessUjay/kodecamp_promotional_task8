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

   tags = {
     Name = "MinikubeInstance"
   }

  provisioner "file" {
  source      = "${path.module}/scripts/install_minikube.sh"
  destination = "/tmp/install_minikube.sh"
  }

  provisioner "remote-exec" {
    inline = [
  "chmod +x /tmp/install_minikube.sh",
  "/tmp/install_minikube.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:/Users/HP/.ssh/KCVPCkeypair1.pem")
    host        = self.public_ip
    timeout     = "10m"
  }

  depends_on = [aws_instance.minikube]
}    