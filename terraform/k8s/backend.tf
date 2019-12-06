terraform {
  backend "gcs" {
    bucket  = "gsa-demo-app-k8s"
    prefix = "terraform.tfstate"
  }
}
