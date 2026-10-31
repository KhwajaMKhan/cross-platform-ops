# Minimal AWS lab: one Linux + one Windows EC2 with SSM (no public SSH/RDP required).
# Usage: terraform init && terraform apply -var="allowed_ssh_cidr=YOUR_IP/32"
# Destroy: terraform destroy

terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_ami" "win2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

resource "aws_iam_role" "ssm" {
  name = "${var.name_prefix}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm" {
  name = "${var.name_prefix}-ssm-profile"
  role = aws_iam_role.ssm.name
}

resource "aws_security_group" "lab" {
  name        = "${var.name_prefix}-sg"
  description = "Lab: prefer SSM; optional SSH/RDP from allowed_ssh_cidr only"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.allowed_ssh_cidr != "" ? [1] : []
    content {
      description = "Optional break-glass SSH/RDP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.allowed_ssh_cidr]
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_ssh_cidr != "" ? [1] : []
    content {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = [var.allowed_ssh_cidr]
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "linux" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.linux_instance_type
  vpc_security_group_ids = [aws_security_group.lab.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  tags                   = { Name = "${var.name_prefix}-linux" }
}

resource "aws_instance" "windows" {
  ami                    = data.aws_ami.win2022.id
  instance_type          = var.windows_instance_type
  vpc_security_group_ids = [aws_security_group.lab.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  tags                   = { Name = "${var.name_prefix}-windows" }
}

output "linux_instance_id" {
  value = aws_instance.linux.id
}

output "windows_instance_id" {
  value = aws_instance.windows.id
}

output "ssm_start_session_linux" {
  value = "aws ssm start-session --target ${aws_instance.linux.id}"
}

output "ssm_start_session_windows" {
  value = "aws ssm start-session --target ${aws_instance.windows.id}"
}
