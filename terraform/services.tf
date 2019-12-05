# Add all the k8s services here

# Exposing to outer world, should be accessble from anywhere
module "frontend-service" {
  source       = "./modules/services"
  service_name = "front-end"
  src_port     = "80"
  target_port  = "5000"
  service_type = "LoadBalancer"
}

# not exposing to outer world, only available to internal Cluster only
module "backend-service" {
  source       = "./modules/services"
  service_name = "front-end"
  src_port     = "5432"
  target_port  = "5432"
  service_type = "ClusterIP"
}
