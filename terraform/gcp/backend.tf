terraform {
  backend "gcs" {
    bucket  = "gsa-demo-app-gcp"
    prefix = "terraform.tfstate"
  }
}
