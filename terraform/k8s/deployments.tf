# Enter all your deployments here

module "frontend" {
  source        = "../modules/deployments"
  image_path = "gcr.io/${var.project}/front-end-app@sha256:109c3a701930a1e558e1bbc4ea19671edf421c5075dcf94ad4667ba13d16b5eb"
}

module "backend" {
  source        = "../modules/deployments"
  deploy_name = "postgres-db"
  image_path = "gcr.io/${var.project}/backend-app@sha256:a9145960734794e66d62e545685c0f4ad02ee92e208b0a77cc5c3f3e26e0c95d"
}
