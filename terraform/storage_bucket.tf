resource "google_storage_bucket" "state-file-storage" {
  name = "k8s-gsa-demo-app"
  versioning {
    enabled = true
  }
}

