# Service Account do Cloud Build
data "google_project" "project" {}

locals {
  cloudbuild_sa = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  clouddeploy_sa = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

# Cloud Build → pode fazer deploy no GKE
resource "google_project_iam_member" "cloudbuild_gke" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = local.cloudbuild_sa
}

# Cloud Build → pode ler/escrever no Artifact Registry
resource "google_project_iam_member" "cloudbuild_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = local.cloudbuild_sa
}

# Cloud Build → pode acionar o Cloud Deploy
resource "google_project_iam_member" "cloudbuild_clouddeploy" {
  project = var.project_id
  role    = "roles/clouddeploy.operator"
  member  = local.cloudbuild_sa
}

# Cloud Deploy → pode fazer deploy no GKE
resource "google_project_iam_member" "clouddeploy_gke" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = local.clouddeploy_sa
}

# Cloud Deploy → pode ler imagens do Artifact Registry
resource "google_project_iam_member" "clouddeploy_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = local.clouddeploy_sa
}

# Cloud Deploy → pode agir como Service Account
resource "google_project_iam_member" "clouddeploy_jobrunner" {
  project = var.project_id
  role    = "roles/clouddeploy.jobRunner"
  member  = local.clouddeploy_sa
}