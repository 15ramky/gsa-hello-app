# Enter all your deployments here

module "frontend" {
  source        = "./modules/deployments"
  image_path = "gcr.io/${var.project}/front-end-app@sha256:62bd2eba37b621e0886c4361f480410cb997aada1897f5a08b289c1c8fc34a2f"
}

module "backend" {
  source        = "./modules/deployments"
  deploy_name = "postgres-db"
  image_path = "gcr.io/${var.project}/backend-app@sha256:1e748f044d50bf41c61c0e96d2286296569c84fbeb21022b627f932eb1d9cffc"
}
