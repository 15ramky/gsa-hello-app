provider "google" {
  credentials = "${file("key.json")}"
  project     = "gsa-demo-app"
  region      = "us-central1"
}

/*
provider "kubernetes" {
  config_context_cluster = "gke_gsa-demo-app_us-central1-a_demo-cluster"
}

resource "kubernetes_namespace" "defualt" {
  metadata {
    name = "default"
  }
}
*/
