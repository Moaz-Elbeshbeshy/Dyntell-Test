#!/bin/bash

# Log everything
exec > >(tee /var/log/setup.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "=== Starting setup script ==="

# Update system packages
sudo yum update -y

# Install Docker from Amazon Linux Extras
sudo amazon-linux-extras install docker -y

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to the docker group so you can run docker without sudo
sudo usermod -aG docker ec2-user

# Log success
echo "✔️ Docker installed and containers running." >> /var/log/setup.log
