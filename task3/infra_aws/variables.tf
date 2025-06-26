variable "aws_region" {
  description = "AWS Region to deploy resouce"
  default     = "eu-central-1"
}

variable "aws_ami" {
  description = "Amazon Linus 2 AMI ID for eu-central-1"
  default     = "ami-0c55825bb0a77f4cf"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name created in AWS EC2"
  default     = "mizo-key"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key on local machine"
  default     = "/home/moazelbeshbeshy/.ssh/mizo-key.pem"
}

