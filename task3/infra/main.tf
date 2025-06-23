#You don't really need required_providers for this VM, but it is best pactice :-/
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.51.0"
    }
  }
}


provider "google" {
  project = var.project
  region  = var.region
}

# Read in script file
locals {
  script_content = file("../DockerInstall/install_docker.sh")
}

resource "google_compute_instance" "vm_instance" {
  name         = "task-manager"
  machine_type = "e2-medium"
  zone         = "europe-central2-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240307b"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    user-data = file("../DockerInstall/install_docker_cloudinit.yaml")
  }
}

output "public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}
