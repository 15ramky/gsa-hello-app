resource "google_container_cluster" "gsa-demo-cluster" {
  # This option will vary with node scaling attribute
  addons_config {
    horizontal_pod_autoscaling {
      disabled = "false"
    }

    http_load_balancing {
      disabled = "false"
    }

    network_policy_config {
      disabled = "true"
    }
  }

  # Enabling cluster autoscaling
  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = "default"
    }

    enabled = "true"

    resource_limits {
      maximum       = "16"
      minimum       = "1"
      resource_type = "cpu"
    }

    resource_limits {
      maximum       = "32"
      minimum       = "1"
      resource_type = "memory"
    }
  }

  # Manually choosing the 10.56.0.0/14 network
  cluster_ipv4_cidr         = "${var.cluster_ipv4_cidr}"
  enable_kubernetes_alpha   = "false"
  enable_legacy_abac        = "false"
  initial_node_count        = "3"

  location        = "us-central1-a"
  logging_service = "logging.googleapis.com/kubernetes"

  monitoring_service = "monitoring.googleapis.com/kubernetes"
  name               = "demo-cluster"
  network            = "projects/${var.project}/global/networks/default"

  project      = "${var.project}"

  # Adding some custom labels for future usage
  resource_labels = {
    project = "sbx"
  }
}
