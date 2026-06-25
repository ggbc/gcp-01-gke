# Impede criação de recursos fora das regiões permitidas
resource "google_project_organization_policy" "restrict_locations" {
  project    = var.project_id
  constraint = "constraints/gcp.resourceLocations"

  list_policy {
    allow {
      values = [
        "in:southamerica-east1-locations",
      ]
    }
  }
}

# Impede VMs com IP público
resource "google_project_organization_policy" "restrict_vm_external_ip" {
  project    = var.project_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}

# Impede criação de service account keys
resource "google_project_organization_policy" "disable_sa_key_creation" {
  project    = var.project_id
  constraint = "constraints/iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = true
  }
}

# Exige que buckets GCS não sejam públicos
resource "google_project_organization_policy" "restrict_public_buckets" {
  project    = var.project_id
  constraint = "constraints/storage.publicAccessPrevention"

  boolean_policy {
    enforced = true
  }
}


# Habilita Data Access audit logs para os serviços principais
resource "google_project_iam_audit_config" "audit_logs" {
  project = var.project_id
  service = "allServices"

  audit_log_config {
    log_type = "ADMIN_READ"
  }

  audit_log_config {
    log_type = "DATA_READ"
  }

  audit_log_config {
    log_type = "DATA_WRITE"
  }
}