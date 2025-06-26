provider "aws" {
  region  = var.aws_region # Your chosen AWS region (e.g., eu-central-1)
  profile = "default"      # Matches your AWS CLI profile name
}

# Elastic IP resource
resource "aws_eip" "task_manager_eip" {
  instance = aws_instance.task_manager.id
}

resource "aws_instance" "task_manager" {
  ami                    = var.aws_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.task_manager_sg.id]

  tags = {
    Name = "task-manager-vm" # Tag for easy identification
  }

  user_data = file("${path.module}/scripts/setup.sh") # Provision Docker + run app
}

resource "aws_security_group" "task_manager_sg" {
  name        = "task-manager-sg"
  description = "Allow ports for backend, frontend, and SSH"

  ingress {
    from_port   = 22 # SSH access
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80 # Frontend app
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000 # Backend API
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0 # Allow all outbound traffic
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elastic_ip" {
  value = aws_eip.task_manager_eip.public_ip
}
