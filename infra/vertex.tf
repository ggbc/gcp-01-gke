# Bucket GCS para armazenar dados e artefatos do Vertex AI
resource "google_storage_bucket" "vertex_bucket" {
  name          = "allianceit-vertex-${var.project_id}"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Permissão para a SA padrão ler/escrever no bucket
resource "google_storage_bucket_iam_member" "vertex_bucket_access" {
  bucket = google_storage_bucket.vertex_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

# Output do bucket