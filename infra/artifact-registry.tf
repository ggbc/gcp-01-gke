resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "allianceit-images"
  format        = "DOCKER"
  description   = "Docker images for AllianceIT GKE Lab"
}