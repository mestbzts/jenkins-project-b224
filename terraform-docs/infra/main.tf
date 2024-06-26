terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.46.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
locals {
  instance-type = "t3a.medium"
  key-name = "Martin"
  secgr-dynamic-ports = [22,5000,3000,5432]
  user = "jenkins-project"
  ami = "ami-0230bd60aa48260c6"
}

resource "aws_security_group" "allow_ssh" {
  name        = "${local.user}-sg"
  description = "Allow SSH inbound traffic"

  dynamic "ingress" {
    for_each = local.secgr-dynamic-ports
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tf-ec2" {
  ami           = local.ami
  instance_type = local.instance-type
  key_name = local.key-name
  vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
  tags = {
      Name = "${local.user}-Docker-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname docker_instance
              yum update -y
              yum install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user
              newgrp docker
              # install docker-compose
              curl -SL https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
	          EOF
}  
output "myec2-public-ip" {
  value = aws_instance.tf-ec2.public_ip
}

output "ssh-connection-command" {
  value = "ssh -i ${local.key-name}.pem ec2-user@${aws_instance.tf-ec2.public_ip}"
}