resource "kubernetes_service" "default-k8s-service" {
  metadata {
    labels = {
      app = "${var.service_name}"
    }

    name      = "${var.service_name}-service"
    namespace = "default"
  }

  spec {
    port {
      port        = "${var.src_port}"
      protocol    = "TCP"
      target_port = "${var.target_port}"
    }

    selector = {
      app = "${var.service_name}"
    }

    type             = "${var.service_type}"
  }
}
