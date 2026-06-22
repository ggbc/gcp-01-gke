# custom VPC
resource "google_compute_network" "vpc" {
  name                    = "allianceit-vpc"
  auto_create_subnetworks = false
  description             = "Custom VPC for AllianceIT GKE Lab"
}

# Subnet for the GKE cluster
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-subnet"
  ip_cidr_range = "10.0.0.0/20"
  region        = var.region
  network       = google_compute_network.vpc.id

  # Secondary Ranges — mandatory for GKE VPC-native
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.48.0.0/14"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.52.0.0/20"
  }
}

# Firewall — internal communication between nodes
resource "google_compute_firewall" "allow_internal" {
  name    = "allianceit-allow-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/8"]
}