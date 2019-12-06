variable "project" {
  type    = "string"
  default = "gsa-demo-app"
}
variable "region" {
  type    = "string"
  default = "us-central"
}
variable "zone" {
  type    = "string"
  default = "us-central1-a"
}

# Sticking to some default network for this demo app
variable "cluster_ipv4_cidr" {
  type    = "string"
  default = "10.56.0.0/14"
}
variable "max_pods_per_node" {
  type    = "string"
  default = "8"
}

variable "gke_version" {
  type    = "string"
  default = "1.13.11-gke.14"
}

