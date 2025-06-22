resource "google_compute_address" "vm_static_ip" {
    name     = "php-vm-static-ip"
    region   = var.region
}


resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["task-manager"]

  depends_on = [ google_compute_address.vm_static_ip ]

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
  ssh-keys = "moazelbeshbeshy:${file("/home/moazelbeshbeshy/.ssh/google_compute_engine.pub")}"
    }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo usermod -aG docker $USER
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

  target_tags = ["task-manager"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["37.76.40.225/32"]  # ✅ Only your IP can access it

  target_tags = ["task-manager"]        # ✅ Again, matches VM tag
}
