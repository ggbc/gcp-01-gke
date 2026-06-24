# Pipeline do Cloud Deploy
resource "google_clouddeploy_delivery_pipeline" "pipeline" {
  name     = "allianceit-pipeline"
  location = var.region

  description = "Delivery pipeline for AllianceIT microservices"

  serial_pipeline {
    stages {
      target_id = google_clouddeploy_target.gke_target.target_id
    }
  }
}

# Target — cluster GKE onde o Cloud Deploy vai fazer o rollout
resource "google_clouddeploy_target" "gke_target" {
  name     = "allianceit-gke-target"
  location = var.region

  description = "GKE cluster target for AllianceIT pipeline"

  gke {
    cluster = "projects/${var.project_id}/locations/${var.zone}/clusters/${google_container_cluster.primary.name}"
  }

  require_approval = false
}