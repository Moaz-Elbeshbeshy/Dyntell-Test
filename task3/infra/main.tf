resource "google_compute_address" "vm_static_ip" {
  name   = "php-vm-static-ip"
  region = var.region
}

resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["task-manager"]

  depends_on = [google_compute_address.vm_static_ip]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  metadata = {
    ssh-keys = "moazelbeshbeshy:${file(var.ssh_public_key_path)}"
  }

  metadata_startup_script = <<EOT
#!/bin/bash
set -e

# Log all output to /var/log/startup-script.log
exec > >(tee -a /var/log/startup-script.log) 2>&1
echo "Starting startup script at $(date)"

# Test file to confirm script execution
echo "Startup script ran successfully" > /tmp/startup-test.txt

# Update package index
echo "Updating package index..."
apt-get update

# Install Docker
echo "Installing Docker..."
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
echo "Starting and enabling Docker service..."
systemctl start docker
systemctl enable docker

# Wait for user to exist
echo "Waiting for user moazelbeshbeshy to be available..."
for i in {1..12}; do
  if id -u moazelbeshbeshy > /dev/null 2>&1; then
    echo "User moazelbeshbeshy found"
    break
  fi
  echo "User moazelbeshbeshy not found, retrying in 5 seconds..."
  sleep 5
done

# Add user to docker group
if id -u moazelbeshbeshy > /dev/null 2>&1; then
  echo "Adding moazelbeshbeshy to docker group..."
  usermod -aG docker moazelbeshbeshy
else
  echo "Error: User moazelbeshbeshy does not exist after waiting"
  exit 1
fi

echo "Completed startup script at $(date)"
EOT
}

resource "google_compute_firewall" "allow-frontend-backend" {
  name    = "allow-frontend-backend"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000", "5000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["task-manager"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["37.76.40.225/32"]
  target_tags   = ["task-manager"]
}
