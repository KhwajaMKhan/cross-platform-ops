# Minimal GCP lab: Linux + Windows Compute Engine instances.
# Usage: terraform init && terraform apply
# Access: OS Login / IAP TCP forwarding — avoid open SSH/RDP to 0.0.0.0/0.

terraform {
  required_version = ">= 1.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "lab" {
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lab" {
  name          = "${var.name_prefix}-subnet"
  ip_cidr_range = "10.50.0.0/24"
  region        = var.region
  network       = google_compute_network.lab.id
}

resource "google_compute_firewall" "allow_egress" {
  name    = "${var.name_prefix}-egress"
  network = google_compute_network.lab.name

  direction = "EGRESS"
  allow {
    protocol = "all"
  }
  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "linux" {
  name         = "${var.name_prefix}-linux"
  machine_type = var.linux_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lab.id
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  tags = ["lab-linux"]
}

resource "google_compute_instance" "windows" {
  name         = "${var.name_prefix}-windows"
  machine_type = var.windows_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2022"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lab.id
  }

  tags = ["lab-windows"]
}

output "linux_instance_name" {
  value = google_compute_instance.linux.name
}

output "windows_instance_name" {
  value = google_compute_instance.windows.name
}

output "gcloud_ssh_linux_hint" {
  value = "gcloud compute ssh ${google_compute_instance.linux.name} --zone=${var.zone}"
}
