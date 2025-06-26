#!/bin/bash

# Log everything
exec > >(tee /var/log/setup.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "=== Starting setup script ==="

# Update system packages
sudo yum update -y

# Disable SELinux (Amazon Linux 2 has incompatible versions with k3s-selinux)
echo "Disabling SELinux..."
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

# Install Docker from Amazon Linux Extras
sudo amazon-linux-extras install docker -y

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to the docker group so you can run docker without sudo
sudo usermod -aG docker ec2-user

# Install K3s (lightweight Kubernetes) with SELinux disabled
if ! command -v k3s &> /dev/null; then
  echo "Installing K3s..."
  curl -sfL https://get.k3s.io | INSTALL_K3S_SELINUX_SUPPORT=false sh -
fi

# Alias kubectl to k3s kubectl for ease of use
echo "alias kubectl='k3s kubectl'" >> /home/ec2-user/.bashrc

# Export kubeconfig so GitHub Actions can use it over SSH if needed
mkdir -p /home/ec2-user/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config
sudo chown ec2-user:ec2-user /home/ec2-user/.kube/config

# Log success
echo "✔️ Docker + K3s installed." >> /var/log/setup.log