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

# Install K3s (skip selinux-related dependencies)
if ! command -v k3s &> /dev/null; then
  echo "Installing K3s..."
  curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_SELINUX_RPM=true sh -
fi

# Create systemd drop-in directory for k3s service override
sudo mkdir -p /etc/systemd/system/k3s.service.d

# Create systemd drop-in override file to set environment variable
sudo tee /etc/systemd/system/k3s.service.d/override.conf > /dev/null <<EOF
[Service]
Environment="K3S_KUBECONFIG_MODE=644"
EOF

# Reload systemd manager configuration and restart k3s so override takes effect
sudo systemctl daemon-reload
sudo systemctl restart k3s

# Symlink k3s to /usr/bin so it's in the PATH for all users
sudo ln -sf /usr/local/bin/k3s /usr/bin/k3s

# Symlink kubectl to /usr/bin as well
sudo ln -sf /usr/local/bin/kubectl /usr/bin/kubectl

# Set up kubeconfig for ec2-user
mkdir -p /home/ec2-user/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config
sudo chown ec2-user:ec2-user /home/ec2-user/.kube/config

# Add kubectl alias to ec2-user's bashrc
echo "alias kubectl='k3s kubectl'" >> /home/ec2-user/.bashrc

echo "✔️ Docker + K3s installed and configured."
