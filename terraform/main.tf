provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "chaos_sg" {
  name = "chaos-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "small_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.small_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.chaos_sg.id]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "chaos-small"
  }
}

resource "aws_instance" "large_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.large_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.chaos_sg.id]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "chaos-large"
  }
}
