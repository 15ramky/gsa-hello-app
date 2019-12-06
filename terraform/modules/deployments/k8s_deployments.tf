resource "kubernetes_deployment" "k8s-deployment" {
  metadata {
    labels = {
      app = "${var.deploy_name}"
    }

    name      = "${var.deploy_name}"
    namespace = "default"
  }

  spec {
    min_ready_seconds         = "0"
    paused                    = "false"
    progress_deadline_seconds = "600"
    replicas                  = "1"
    revision_history_limit    = "10"
    selector {
      match_labels = {

        app = "${var.deploy_name}"
      }
    }

    # Change to 100% to get the quick turnaround for demo applications
    strategy {
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }

      type = "RollingUpdate"
    }

    template {
      metadata {
        generation = "0"

        labels = {
          app = "${var.deploy_name}"
        }
      }

      spec {
        active_deadline_seconds         = "0"
        automount_service_account_token = "false"

        container {
          image                    = "${var.image_path}"
          image_pull_policy        = "IfNotPresent"
          name                     = "front-end-app-sha256"
          stdin                    = "false"
          stdin_once               = "false"
          termination_message_path = "/dev/termination-log"
          tty                      = "false"
        }

        dns_policy                       = "ClusterFirst"
        host_ipc                         = "false"
        host_network                     = "false"
        host_pid                         = "false"
        restart_policy                   = "Always"
        share_process_namespace          = "false"
        termination_grace_period_seconds = "30"
      }
    }
  }
}
