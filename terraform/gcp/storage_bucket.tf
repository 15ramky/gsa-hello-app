resource "google_storage_bucket" "state-file-storage-gcp" {
  name = "gsa-demo-app-gcp"
  versioning {
    enabled = true
  }
}

# Creating the terraform storage bucker for Kubernetes also
resource "google_storage_bucket" "state-file-storage-k8s" {
  name = "gsa-demo-app-k8s"
  versioning {
    enabled = true
  }
}

