resource "google_container_node_pool" "gsa-demo-cluster-node-poll" {
  cluster            = "${google_container_cluster.gsa-demo-cluster.name}"
 
  # Taking 3 nodes for demo purpose
  initial_node_count = "1"
  location           = "${var.zone}"

  # Strictly no to auto upgrade
  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  name              = "default-pool"

  node_config {
    disk_size_gb    = "100"
    disk_type       = "pd-standard"
    image_type      = "COS"
    local_ssd_count = "0"
    machine_type    = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/monitoring", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/trace.append"]

    # can be changed to true for demo purposes
    preemptible     = "false"
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = "true"
      enable_secure_boot          = "false"
    }
  }

  project    = "${var.project}"
  version    = "${var.gke_version}"
  zone       = "${var.zone}"
}
