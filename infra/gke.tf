# Cluster GKE
resource "google_container_cluster" "primary" {
  name     = "allianceit-gke"
  location = var.zone

  # Boas práticas: remove o node pool default e cria um customizado
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.gke_subnet.name

  # VPC-native — uses the secondary ranges defined in the subnet for Pods and Services
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  # Workload Identity — safe way to provide GCP permissions to workloads running in the cluster
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Release channel — GCP gerencia upgrades automáticos
  release_channel {
    channel = "REGULAR"
  }
}

# Node Pool customizado com autoscaling
resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  location = var.zone
  cluster  = google_container_cluster.primary.name

  # Cluster Autoscaler — escala os nós automaticamente
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 30
    disk_type    = "pd-standard"

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}