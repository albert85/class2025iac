terraform {
  backend "s3" {
    bucket  = "techbleat-cicd-state-bucket-week-7"
    key     = "envs/dev/terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true

  }
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

#-------------------------
# Web EC2 Instance
# ------------------------


resource "aws_instance" "web-node" {
  ami                    = var.project_ami
  instance_type          = var.project_instance_type
  subnet_id              = var.project_subnet
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               =  var.project_keyname

  tags = {
    Name = "web-node"
  }
}

#-------------------------
# Python EC2 Instance
# ------------------------


resource "aws_instance" "python-node" {
  ami                    = var.project_ami
  instance_type          = var.project_instance_type
  subnet_id              = var.project_subnet
  vpc_security_group_ids = [aws_security_group.python_sg.id]
  key_name               =  var.project_keyname

  tags = {
    Name = "python-node"
  }
}

# Java backend setup

#-------------------------
# Java EC2 Instance
# ------------------------


resource "aws_instance" "java-node" {
  ami                    = "ami-0f50f13aefb6c0a5d"
  instance_type          = "t3.micro"
  subnet_id              = "subnet-08cc6a7a9b660d73e"
  vpc_security_group_ids = [aws_security_group.java_sg.id]
  key_name               = "devop-keypair"

  tags = {
    Name = "java-node"
  }
}


#--------------------------------
# Outputs - Public (external) IPs
#--------------------------------


output "web_node_ip" {
  description = " Public IP"
  value  = aws_instance.web-node.public_ip
}

output "python_node_ip" {
  description = " Public IP"
  value  = aws_instance.python-node.public_ip
}

output "java_node_ip" {
  description = " Public IP"
  value  = aws_instance.java-node.public_ip
}
