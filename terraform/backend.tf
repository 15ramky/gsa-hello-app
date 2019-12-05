terraform {
  backend "gcs" {
    bucket  = "k8s-gsa-demo-app"
    prefix = "terraform.tfstate"
  }
}
