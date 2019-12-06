provider "google" {
  credentials = "${file("key.json")}"
  project     = "gsa-demo-app"
  region      = "us-central1"
}
