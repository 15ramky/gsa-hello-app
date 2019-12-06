AUTHOR  : Ramakrishna Kothamasu \
EMAIL   : krishna.ubuntu@gmail.com \
VERSION : 0.0.1 (Draft) 

# *GroundSpeed Analytics Hello World App*
This page describes how to run this hello application on GCP gke

## pre-req
This code is testes on GCP, but it should work with other public clouds with minimal changes (except terraform code)

### Creating service account with GCP 
* STEP 1: Creating service account for terraform \
          gcloud iam service-accounts create terraform
* STEP 2: Add sufficiant roles to the service account \
          Example: gcloud projects add-iam-policy-binding gsa-demo-app --member "serviceAccount:terraform@gsa-demo-app.iam.gserviceaccount.com" --role "roles/owner"
* STEP 3: Create a key for service account to use \
          Example: gcloud iam service-accounts keys create key.json --iam-account terraform@gsa-demo-app.iam.gserviceaccount.com
* STEP 4: Adding defualt credentials for tyour terminal \
          Example: export GOOGLE_APPLICATION_CREDENTIALS="./key.json"
 
 NOTE: I used my Mac conputer for demo purposes, it may not work on your computer

## Creating Docker containers and push them to gcr.io as privite images into you project.
* STEP 1: Creating the docker build for both frontend and backend application with Dockerfiles \

Note: you can use docker-cli or other cloud build tools to build the docker image\

* STEP 2: Pushing the docker built images to gcr.io in your project\
          Example: docker build -t gcr.io/gsa-demo-app/front-end-app:v1 .

NOTE: Do not forget to configure the docker with gcloud 
```sh
gcloud auth configure-docker
```

* STEP 3: Verify the images are listed in your GCP project (gcloud container --help)

## Here the Dragons come --< --< --<

## *terraform*

### IaaC --> Plan is to try to deploy all the Infrastructure with terraform

* STEP 1: create backend bucket for terraform state file
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> terraform init

Initializing the backend...

Initializing provider plugins...
...
...
```
Look for all the teraform resources that to be created.

```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> terraform plan | grep -i "will be"
The refreshed state will be used to calculate this plan, but will not be
  # google_container_cluster.gsa-demo-cluster will be created
  # google_container_node_pool.gsa-demo-cluster-node-poll will be created
  # google_storage_bucket.state-file-storage-gcp will be created
  # google_storage_bucket.state-file-storage-k8s will be created
can't guarantee that exactly these actions will be performed if
```
Creating backend storage bucker for storing the terraform state file
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> terraform apply -target=google_storage_bucket.state-file-storage-gcp

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_storage_bucket.state-file-storage-gcp will be created
  + resource "google_storage_bucket" "state-file-storage-gcp" {
      + bucket_policy_only = (known after apply)
      + force_destroy      = false
      + id                 = (known after apply)
      + location           = "US"
      + name               = "gsa-demo-app-gcp"
      + project            = (known after apply)
      + self_link          = (known after apply)
      + storage_class      = "STANDARD"
      + url                = (known after apply)

      + versioning {
          + enabled = true
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_storage_bucket.state-file-storage-gcp: Creating...
google_storage_bucket.state-file-storage-gcp: Creation complete after 6s [id=gsa-demo-app-gcp]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ -->
```
Creating backend bucker for k8s

```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> terraform apply -target=google_storage_bucket.state-file-storage-k8s 

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_storage_bucket.state-file-storage-k8s will be created
  + resource "google_storage_bucket" "state-file-storage-k8s" {
      + bucket_policy_only = (known after apply)
      + force_destroy      = false
      + id                 = (known after apply)
      + location           = "US"
      + name               = "gsa-demo-app-k8s"
      + project            = (known after apply)
      + self_link          = (known after apply)
      + storage_class      = "STANDARD"
      + url                = (known after apply)

      + versioning {
          + enabled = true
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_storage_bucket.state-file-storage-k8s: Creating...
google_storage_bucket.state-file-storage-k8s: Creation complete after 2s [id=gsa-demo-app-k8s]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ -->
```

#### Chicken end egg problem
IMPARTENT: to create terraform backend, first create Storage bucket (storage_bucket.tf), without backend.tf (TRICK `mv -v backend.tf backend.tf.bkp` and then `mv -v backend.tf.bkp backend.tf`)

```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> mv -v backend.tf.bkp backend.tf
backend.tf.bkp -> backend.tf
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> terraform init 

Initializing the backend...
Acquiring state lock. This may take a few moments...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "gcs" backend. No existing state was found in the newly
  configured "gcs" backend. Do you want to copy this state to the new "gcs"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes


Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.google: version = "~> 3.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> 
```

* STEP 2: Create k8s cluster with terraform

```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> terraform apply -target=google_container_cluster.gsa-demo-cluster

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_container_cluster.gsa-demo-cluster will be created
  + resource "google_container_cluster" "gsa-demo-cluster" {
      + cluster_ipv4_cidr           = "10.56.0.0/14"
      + default_max_pods_per_node   = (known after apply)
      + enable_binary_authorization = (known after apply)
      + enable_kubernetes_alpha     = false
      + enable_legacy_abac          = false
      + enable_tpu                  = (known after apply)
      + endpoint                    = (known after apply)
      + id                          = (known after apply)
      + initial_node_count          = 3
      + instance_group_urls         = (known after apply)
      + location                    = "us-central1-a"
      + logging_service             = "logging.googleapis.com/kubernetes"
      + master_version              = (known after apply)
      + monitoring_service          = "monitoring.googleapis.com/kubernetes"
      + name                        = "demo-cluster"
      + network                     = "projects/gsa-demo-app/global/networks/default"
      + node_locations              = (known after apply)
      + node_version                = (known after apply)
      + project                     = "gsa-demo-app"
      + resource_labels             = {
          + "project" = "sbx"
        }
      + services_ipv4_cidr          = (known after apply)
      + subnetwork                  = (known after apply)

      + addons_config {
          + horizontal_pod_autoscaling {
              + disabled = false
            }

          + http_load_balancing {
              + disabled = false
            }

          + network_policy_config {
              + disabled = true
            }
        }

      + authenticator_groups_config {
          + security_group = (known after apply)
        }

      + cluster_autoscaling {
          + enabled = true

          + auto_provisioning_defaults {
              + service_account = "default"
            }

          + resource_limits {
              + maximum       = 16
              + minimum       = 1
              + resource_type = "cpu"
            }
          + resource_limits {
              + maximum       = 32
              + minimum       = 1
              + resource_type = "memory"
            }
        }

      + master_auth {
          + client_certificate     = (known after apply)
          + client_key             = (sensitive value)
          + cluster_ca_certificate = (known after apply)
          + password               = (sensitive value)
          + username               = (known after apply)

          + client_certificate_config {
              + issue_client_certificate = (known after apply)
            }
        }

      + network_policy {
          + enabled  = (known after apply)
          + provider = (known after apply)
        }

      + node_config {
          + disk_size_gb      = (known after apply)
          + disk_type         = (known after apply)
          + guest_accelerator = (known after apply)
          + image_type        = (known after apply)
          + labels            = (known after apply)
          + local_ssd_count   = (known after apply)
          + machine_type      = (known after apply)
          + metadata          = (known after apply)
          + min_cpu_platform  = (known after apply)
          + oauth_scopes      = (known after apply)
          + preemptible       = (known after apply)
          + service_account   = (known after apply)
          + tags              = (known after apply)
          + taint             = (known after apply)

          + sandbox_config {
              + sandbox_type = (known after apply)
            }

          + shielded_instance_config {
              + enable_integrity_monitoring = (known after apply)
              + enable_secure_boot          = (known after apply)
            }

          + workload_metadata_config {
              + node_metadata = (known after apply)
            }
        }

      + node_pool {
          + initial_node_count  = (known after apply)
          + instance_group_urls = (known after apply)
          + max_pods_per_node   = (known after apply)
          + name                = (known after apply)
          + name_prefix         = (known after apply)
          + node_count          = (known after apply)
          + version             = (known after apply)

          + autoscaling {
              + max_node_count = (known after apply)
              + min_node_count = (known after apply)
            }

          + management {
              + auto_repair  = (known after apply)
              + auto_upgrade = (known after apply)
            }

          + node_config {
              + disk_size_gb      = (known after apply)
              + disk_type         = (known after apply)
              + guest_accelerator = (known after apply)
              + image_type        = (known after apply)
              + labels            = (known after apply)
              + local_ssd_count   = (known after apply)
              + machine_type      = (known after apply)
              + metadata          = (known after apply)
              + min_cpu_platform  = (known after apply)
              + oauth_scopes      = (known after apply)
              + preemptible       = (known after apply)
              + service_account   = (known after apply)
              + tags              = (known after apply)
              + taint             = (known after apply)

              + sandbox_config {
                  + sandbox_type = (known after apply)
                }

              + shielded_instance_config {
                  + enable_integrity_monitoring = (known after apply)
                  + enable_secure_boot          = (known after apply)
                }

              + workload_metadata_config {
                  + node_metadata = (known after apply)
                }
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_container_cluster.gsa-demo-cluster: Creating...
google_container_cluster.gsa-demo-cluster: Still creating... [10s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [20s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [30s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [40s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [50s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [1m0s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [1m10s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [1m20s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [1m30s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [1m40s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [1m50s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [2m0s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [2m10s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [2m20s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [2m30s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [2m40s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [2m50s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [3m0s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [3m10s elapsed]
google_container_cluster.gsa-demo-cluster: Still creating... [3m20s elapsed]
google_container_cluster.gsa-demo-cluster: Creation complete after 3m24s [id=projects/gsa-demo-app/locations/us-central1-a/clusters/demo-cluster]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> 

```

![GCP Cluster](https://drive.google.com/file/d/1OMUfvLjNGiQESVwGYlF0kA0z8eu8wS78/view?usp=sharing)

<!-- fronend for Flask app and backend for postgres pods--> 
* STEP 4: Create backend deployment with terraform
Creating backend deployment(postgres) and backend service (Expose ClusterIP) first, so it will be easyto get the backend ClusterIP and attach it to front-end Dockerfile

```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> terraform apply -target=module.backend.kubernetes_deployment.front-end-app
Acquiring state lock. This may take a few moments...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.backend.kubernetes_deployment.front-end-app will be created
  + resource "kubernetes_deployment" "front-end-app" {
      + id = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + labels           = {
              + "app" = "postgres-db"
            }
          + name             = "postgres-db"
          + namespace        = "default"
          + resource_version = (known after apply)
          + self_link        = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + min_ready_seconds         = 0
          + paused                    = false
          + progress_deadline_seconds = 600
          + replicas                  = 1
          + revision_history_limit    = 10

          + selector {
              + match_labels = {
                  + "app" = "postgres-db"
                }
            }

          + strategy {
              + type = "RollingUpdate"

              + rolling_update {
                  + max_surge       = "25%"
                  + max_unavailable = "25%"
                }
            }

          + template {
              + metadata {
                  + generation       = 0
                  + labels           = {
                      + "app" = "postgres-db"
                    }
                  + name             = (known after apply)
                  + resource_version = (known after apply)
                  + self_link        = (known after apply)
                  + uid              = (known after apply)
                }

              + spec {
                  + active_deadline_seconds          = 0
                  + automount_service_account_token  = false
                  + dns_policy                       = "ClusterFirst"
                  + host_ipc                         = false
                  + host_network                     = false
                  + host_pid                         = false
                  + hostname                         = (known after apply)
                  + node_name                        = (known after apply)
                  + restart_policy                   = "Always"
                  + service_account_name             = (known after apply)
                  + share_process_namespace          = false
                  + termination_grace_period_seconds = 30

                  + container {
                      + image                    = "gcr.io/gsa-demo-app/backend-app@sha256:a9145960734794e66d62e545685c0f4ad02ee92e208b0a77cc5c3f3e26e0c95d"
                      + image_pull_policy        = "IfNotPresent"
                      + name                     = "front-end-app-sha256"
                      + stdin                    = false
                      + stdin_once               = false
                      + termination_message_path = "/dev/termination-log"
                      + tty                      = false

                      + resources {
                          + limits {
                              + cpu    = (known after apply)
                              + memory = (known after apply)
                            }

                          + requests {
                              + cpu    = (known after apply)
                              + memory = (known after apply)
                            }
                        }

                      + volume_mount {
                          + mount_path        = (known after apply)
                          + mount_propagation = (known after apply)
                          + name              = (known after apply)
                          + read_only         = (known after apply)
                          + sub_path          = (known after apply)
                        }
                    }

                  + image_pull_secrets {
                      + name = (known after apply)
                    }

                  + volume {
                      + name = (known after apply)

                      + aws_elastic_block_store {
                          + fs_type   = (known after apply)
                          + partition = (known after apply)
                          + read_only = (known after apply)
                          + volume_id = (known after apply)
                        }

                      + azure_disk {
                          + caching_mode  = (known after apply)
                          + data_disk_uri = (known after apply)
                          + disk_name     = (known after apply)
                          + fs_type       = (known after apply)
                          + read_only     = (known after apply)
                        }

                      + azure_file {
                          + read_only   = (known after apply)
                          + secret_name = (known after apply)
                          + share_name  = (known after apply)
                        }

                      + ceph_fs {
                          + monitors    = (known after apply)
                          + path        = (known after apply)
                          + read_only   = (known after apply)
                          + secret_file = (known after apply)
                          + user        = (known after apply)

                          + secret_ref {
                              + name = (known after apply)
                            }
                        }

                      + cinder {
                          + fs_type   = (known after apply)
                          + read_only = (known after apply)
                          + volume_id = (known after apply)
                        }

                      + config_map {
                          + default_mode = (known after apply)
                          + name         = (known after apply)

                          + items {
                              + key  = (known after apply)
                              + mode = (known after apply)
                              + path = (known after apply)
                            }
                        }

                      + downward_api {
                          + default_mode = (known after apply)

                          + items {
                              + mode = (known after apply)
                              + path = (known after apply)

                              + field_ref {
                                  + api_version = (known after apply)
                                  + field_path  = (known after apply)
                                }

                              + resource_field_ref {
                                  + container_name = (known after apply)
                                  + quantity       = (known after apply)
                                  + resource       = (known after apply)
                                }
                            }
                        }

                      + empty_dir {
                          + medium = (known after apply)
                        }

                      + fc {
                          + fs_type      = (known after apply)
                          + lun          = (known after apply)
                          + read_only    = (known after apply)
                          + target_ww_ns = (known after apply)
                        }

                      + flex_volume {
                          + driver    = (known after apply)
                          + fs_type   = (known after apply)
                          + options   = (known after apply)
                          + read_only = (known after apply)

                          + secret_ref {
                              + name = (known after apply)
                            }
                        }

                      + flocker {
                          + dataset_name = (known after apply)
                          + dataset_uuid = (known after apply)
                        }

                      + gce_persistent_disk {
                          + fs_type   = (known after apply)
                          + partition = (known after apply)
                          + pd_name   = (known after apply)
                          + read_only = (known after apply)
                        }

                      + git_repo {
                          + directory  = (known after apply)
                          + repository = (known after apply)
                          + revision   = (known after apply)
                        }

                      + glusterfs {
                          + endpoints_name = (known after apply)
                          + path           = (known after apply)
                          + read_only      = (known after apply)
                        }

                      + host_path {
                          + path = (known after apply)
                          + type = (known after apply)
                        }

                      + iscsi {
                          + fs_type         = (known after apply)
                          + iqn             = (known after apply)
                          + iscsi_interface = (known after apply)
                          + lun             = (known after apply)
                          + read_only       = (known after apply)
                          + target_portal   = (known after apply)
                        }

                      + local {
                          + path = (known after apply)
                        }

                      + nfs {
                          + path      = (known after apply)
                          + read_only = (known after apply)
                          + server    = (known after apply)
                        }

                      + persistent_volume_claim {
                          + claim_name = (known after apply)
                          + read_only  = (known after apply)
                        }

                      + photon_persistent_disk {
                          + fs_type = (known after apply)
                          + pd_id   = (known after apply)
                        }

                      + quobyte {
                          + group     = (known after apply)
                          + read_only = (known after apply)
                          + registry  = (known after apply)
                          + user      = (known after apply)
                          + volume    = (known after apply)
                        }

                      + rbd {
                          + ceph_monitors = (known after apply)
                          + fs_type       = (known after apply)
                          + keyring       = (known after apply)
                          + rados_user    = (known after apply)
                          + rbd_image     = (known after apply)
                          + rbd_pool      = (known after apply)
                          + read_only     = (known after apply)

                          + secret_ref {
                              + name = (known after apply)
                            }
                        }

                      + secret {
                          + default_mode = (known after apply)
                          + optional     = (known after apply)
                          + secret_name  = (known after apply)

                          + items {
                              + key  = (known after apply)
                              + mode = (known after apply)
                              + path = (known after apply)
                            }
                        }

                      + vsphere_volume {
                          + fs_type     = (known after apply)
                          + volume_path = (known after apply)
                        }
                    }
                }
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.backend.kubernetes_deployment.front-end-app: Creating...
module.backend.kubernetes_deployment.front-end-app: Still creating... [10s elapsed]
module.backend.kubernetes_deployment.front-end-app: Still creating... [20s elapsed]
module.backend.kubernetes_deployment.front-end-app: Still creating... [30s elapsed]
module.backend.kubernetes_deployment.front-end-app: Still creating... [40s elapsed]
module.backend.kubernetes_deployment.front-end-app: Still creating... [50s elapsed]
module.backend.kubernetes_deployment.front-end-app: Still creating... [1m0s elapsed]
module.backend.kubernetes_deployment.front-end-app: Still creating... [1m10s elapsed]
...
module.backend.kubernetes_deployment.front-end-app: Still creating... [10m0s elapsed]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```
Verify for k8d deployments
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> kubectl get deployments
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
postgres-db   1/1     1            1           11m
```
<!-- frontend will be advertised to outside world as HTTPS LoadBalancer and postgres will use only ClusterIP and only available to pods with in the Cluster -->
* STEP 5: Create backend service with terraform
Enabling ClusterIP for backend to make it accesseble from with in the Cluster only
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> terraform apply -target=module.backend-service.kubernetes_service.default-k8s-service

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.backend-service.kubernetes_service.default-k8s-service will be created
  + resource "kubernetes_service" "default-k8s-service" {
      + id                    = (known after apply)
      + load_balancer_ingress = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + labels           = {
              + "app" = "backend-end"
            }
          + name             = "backend-end-service"
          + namespace        = "default"
          + resource_version = (known after apply)
          + self_link        = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + cluster_ip                  = (known after apply)
          + external_traffic_policy     = (known after apply)
          + publish_not_ready_addresses = false
          + selector                    = {
              + "app" = "backend-end"
            }
          + session_affinity            = "None"
          + type                        = "ClusterIP"

          + port {
              + node_port   = (known after apply)
              + port        = 5432
              + protocol    = "TCP"
              + target_port = "5432"
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.backend-service.kubernetes_service.default-k8s-service: Creating...
module.backend-service.kubernetes_service.default-k8s-service: Creation complete after 0s [id=default/backend-end-service]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> kubectl get services
NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
backend-end-service   ClusterIP   10.59.243.249   <none>        5432/TCP   7s
kubernetes            ClusterIP   10.59.240.1     <none>        443/TCP    40m
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> 
```
* STEP 6: Create front-end app and here we're adding the backend connection as well while we building the docker build
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/helloworld-app$ 💃🏏🍎🌴 ☕️ --> kubectl get services
NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
backend-end-service   ClusterIP   10.59.243.249   <none>        5432/TCP   2m46s
kubernetes            ClusterIP   10.59.240.1     <none>        443/TCP    43m
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/helloworld-app$ 💃🏏🍎🌴 ☕️ --> vim Dockerfile 
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/helloworld-app$ 💃🏏🍎🌴 ☕️ --> grep 10.59.243.249 Dockerfile 
ENV DATABASE_URL postgresql://postgres:postgres@10.59.243.249:5432/groundspeed_devops'
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/helloworld-app$ 💃🏏🍎🌴 ☕️ --> 
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/helloworld-app$ 💃🏏🍎🌴 ☕️ --> docker build -t gcr.io/gsa-demo-app/front-end-app:v1 .
Sending build context to Docker daemon  10.24kB
Step 1/8 : FROM python:2.7-slim
 ---> f090c78858fa
Step 2/8 : MAINTAINER Ramakrishna Kothamasu "krishna.ubuntu@gmail.com"
 ---> Using cache
 ---> 1d5c0867842f
Step 3/8 : WORKDIR /app
 ---> Using cache
 ---> d3764195237a
Step 4/8 : COPY . /app
 ---> 6bc82a73f89e
Step 5/8 : RUN pip install --trusted-host pypi.python.org -r requirements.txt
 ---> Running in 90b0dd3d123c
Collecting Click==7.0 (from -r requirements.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/fa/37/45185cb5abbc30d7257104c434fe0b07e5a195a6847506c074527aa599ec/Click-7.0-py2.py3-none-any.whl (81kB)
Collecting Flask==1.0.2 (from -r requirements.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/7f/e7/08578774ed4536d3242b14dacb4696386634607af824ea997202cd0edb4b/Flask-1.0.2-py2.py3-none-any.whl (91kB)
Collecting Flask-Migrate==2.2.1 (from -r requirements.txt (line 3))
  Downloading https://files.pythonhosted.org/packages/59/97/f681c9e43d2e2ace4881fa588d847cc25f47cc98f7400e237805d20d6f79/Flask_Migrate-2.2.1-py2.py3-none-any.whl
Collecting Flask-SQLAlchemy==2.3.2 (from -r requirements.txt (line 4))
  Downloading https://files.pythonhosted.org/packages/a1/44/294fb7f6bf49cc7224417cd0637018db9fee0729b4fe166e43e2bbb1f1c8/Flask_SQLAlchemy-2.3.2-py2.py3-none-any.whl
Collecting itsdangerous==0.24 (from -r requirements.txt (line 5))
  Downloading https://files.pythonhosted.org/packages/dc/b4/a60bcdba945c00f6d608d8975131ab3f25b22f2bcfe1dab221165194b2d4/itsdangerous-0.24.tar.gz (46kB)
Collecting Jinja2==2.10 (from -r requirements.txt (line 6))
  Downloading https://files.pythonhosted.org/packages/7f/ff/ae64bacdfc95f27a016a7bed8e8686763ba4d277a78ca76f32659220a731/Jinja2-2.10-py2.py3-none-any.whl (126kB)
Collecting Mako==1.0.7 (from -r requirements.txt (line 7))
  Downloading https://files.pythonhosted.org/packages/eb/f3/67579bb486517c0d49547f9697e36582cd19dafb5df9e687ed8e22de57fa/Mako-1.0.7.tar.gz (564kB)
Collecting MarkupSafe==1.0 (from -r requirements.txt (line 8))
  Downloading https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz
Collecting psycopg2==2.7.5 (from -r requirements.txt (line 9))
  Downloading https://files.pythonhosted.org/packages/7c/e6/d5161798a5e8900f24216cb730f2c2be5e4758a80d35c8588306831c0c99/psycopg2-2.7.5-cp27-cp27mu-manylinux1_x86_64.whl (2.7MB)
Collecting python-dateutil==2.7.3 (from -r requirements.txt (line 10))
  Downloading https://files.pythonhosted.org/packages/cf/f5/af2b09c957ace60dcfac112b669c45c8c97e32f94aa8b56da4c6d1682825/python_dateutil-2.7.3-py2.py3-none-any.whl (211kB)
Collecting python-editor==1.0.3 (from -r requirements.txt (line 11))
  Downloading https://files.pythonhosted.org/packages/65/1e/adf6e000ea5dc909aa420352d6ba37f16434c8a3c2fa030445411a1ed545/python-editor-1.0.3.tar.gz
Collecting six==1.11.0 (from -r requirements.txt (line 12))
  Downloading https://files.pythonhosted.org/packages/67/4b/141a581104b1f6397bfa78ac9d43d8ad29a7ca43ea90a2d863fe3056e86a/six-1.11.0-py2.py3-none-any.whl
Collecting SQLAlchemy==1.2.12 (from -r requirements.txt (line 13))
  Downloading https://files.pythonhosted.org/packages/25/c9/b0552098cee325425a61efdf380c51b5c721e459081c85bbb860f501c091/SQLAlchemy-1.2.12.tar.gz (5.6MB)
Collecting Werkzeug==0.14.1 (from -r requirements.txt (line 14))
  Downloading https://files.pythonhosted.org/packages/20/c4/12e3e56473e52375aa29c4764e70d1b8f3efa6682bef8d0aae04fe335243/Werkzeug-0.14.1-py2.py3-none-any.whl (322kB)
Collecting alembic>=0.7 (from Flask-Migrate==2.2.1->-r requirements.txt (line 3))
  Downloading https://files.pythonhosted.org/packages/84/64/493c45119dce700a4b9eeecc436ef9e8835ab67bae6414f040cdc7b58f4b/alembic-1.3.1.tar.gz (1.1MB)
Building wheels for collected packages: itsdangerous, Mako, MarkupSafe, python-editor, SQLAlchemy, alembic
  Running setup.py bdist_wheel for itsdangerous: started
  Running setup.py bdist_wheel for itsdangerous: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/2c/4a/61/5599631c1554768c6290b08c02c72d7317910374ca602ff1e5
  Running setup.py bdist_wheel for Mako: started
  Running setup.py bdist_wheel for Mako: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/15/35/25/dbcb848832ccb1a4b4ad23f529badfd3bce9bf88017f7ca510
  Running setup.py bdist_wheel for MarkupSafe: started
  Running setup.py bdist_wheel for MarkupSafe: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/33/56/20/ebe49a5c612fffe1c5a632146b16596f9e64676768661e4e46
  Running setup.py bdist_wheel for python-editor: started
  Running setup.py bdist_wheel for python-editor: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/36/e0/98/ba386b125a00ea9dd52e2c16aa2ec0adbbd639b84bfe2e001d
  Running setup.py bdist_wheel for SQLAlchemy: started
  Running setup.py bdist_wheel for SQLAlchemy: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/ed/bd/2e/d3874a6e97b8cc71e7e177c8d065ead30f67f380c4d9bbadaa
  Running setup.py bdist_wheel for alembic: started
  Running setup.py bdist_wheel for alembic: finished with status 'done'
  Stored in directory: /root/.cache/pip/wheels/b2/d4/19/5ab879d30af7cbc79e6dcc1d421795b1aa9d78f455b0412ef7
Successfully built itsdangerous Mako MarkupSafe python-editor SQLAlchemy alembic
Installing collected packages: Click, itsdangerous, MarkupSafe, Jinja2, Werkzeug, Flask, SQLAlchemy, Mako, python-editor, six, python-dateutil, alembic, Flask-SQLAlchemy, Flask-Migrate, psycopg2
Successfully installed Click-7.0 Flask-1.0.2 Flask-Migrate-2.2.1 Flask-SQLAlchemy-2.3.2 Jinja2-2.10 Mako-1.0.7 MarkupSafe-1.0 SQLAlchemy-1.2.12 Werkzeug-0.14.1 alembic-1.3.1 itsdangerous-0.24 psycopg2-2.7.5 python-dateutil-2.7.3 python-editor-1.0.3 six-1.11.0
You are using pip version 18.1, however version 19.3.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
Removing intermediate container 90b0dd3d123c
 ---> 232cac3963ac
Step 6/8 : ENTRYPOINT [ "python" ]
 ---> Running in a6a37dcbb5e7
Removing intermediate container a6a37dcbb5e7
 ---> 311e91bfe72f
Step 7/8 : ENV DATABASE_URL postgresql://postgres:postgres@10.59.243.249:5432/groundspeed_devops'
failed to process "postgresql://postgres:postgres@10.59.243.249:5432/groundspeed_devops'": unexpected end of statement while looking for matching single-quote
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/helloworld-app$ 💃🏏🍎🌴 ☕️ --> docker push gcr.io/gsa-demo-app/front-end-app:v1
The push refers to repository [gcr.io/gsa-demo-app/front-end-app]
6368ec3fc119: Pushed 
f175d7ca904f: Pushed 
5826f2ea046e: Pushed 
af9628477752: Pushed 
f1bd403e5041: Pushed 
b7fcb2747224: Pushed 
7b4e562e58dc: Pushed 
v1: digest: sha256:603123268a77f0a5363cc356e67d013c99ee67d6334b1b572914ad112e66bae3 size: 1789
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/helloworld-app$ 💃🏏🍎🌴 ☕️ --> 
```

* STEP 7: Create front end app
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> terraform apply -target=module.frontend.kubernetes_deployment.k8s-deployment
Acquiring state lock. This may take a few moments...
module.frontend.kubernetes_deployment.k8s-deployment: Refreshing state... [id=default/front-end]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # module.frontend.kubernetes_deployment.k8s-deployment will be updated in-place
  ~ resource "kubernetes_deployment" "k8s-deployment" {
        id = "default/front-end"

        metadata {
            annotations      = {}
            generation       = 1
            labels           = {
                "app" = "front-end"
            }
            name             = "front-end"
            namespace        = "default"
            resource_version = "24551"
            self_link        = "/apis/apps/v1/namespaces/default/deployments/front-end"
            uid              = "b274846d-180e-11ea-b2f5-42010a8000e0"
        }

      ~ spec {
            min_ready_seconds         = 0
            paused                    = false
            progress_deadline_seconds = 600
            replicas                  = 1
            revision_history_limit    = 10

            selector {
                match_labels = {
                    "app" = "front-end"
                }
            }

            strategy {
                type = "RollingUpdate"

                rolling_update {
                    max_surge       = "25%"
                    max_unavailable = "25%"
                }
            }

          ~ template {
                metadata {
                    annotations = {}
                    generation  = 0
                    labels      = {
                        "app" = "front-end"
                    }
                }

              ~ spec {
                    active_deadline_seconds          = 0
                    automount_service_account_token  = false
                    dns_policy                       = "ClusterFirst"
                    host_ipc                         = false
                    host_network                     = false
                    host_pid                         = false
                    node_selector                    = {}
                    restart_policy                   = "Always"
                    share_process_namespace          = false
                    termination_grace_period_seconds = 30

                  ~ container {
                        args                     = []
                        command                  = []
                      ~ image                    = "gcr.io/gsa-demo-app/front-end-app@sha256:0f43990575d5773ef4ffe868ded50967dd6f40c01fadaa8261168e8f540a95c1" -> "gcr.io/gsa-demo-app/front-end-app@sha256:7e128bb73a5a5080b9fcb2f8f3d01aada67220c90a96c628b23e46e1cffa903f"
                        image_pull_policy        = "IfNotPresent"
                        name                     = "front-end-app-sha256"
                        stdin                    = false
                        stdin_once               = false
                        termination_message_path = "/dev/termination-log"
                        tty                      = false

                        resources {
                        }
                    }
                }
            }
        }
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.frontend.kubernetes_deployment.k8s-deployment: Modifying... [id=default/front-end]
module.frontend.kubernetes_deployment.k8s-deployment: Modifications complete after 5s [id=default/front-end]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> kubectl get deployments
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
front-end     1/1     1            1           3m58s
postgres-db   1/1     1            1           43m
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> 
```

*  STEP 8: Expose front ip to outer worl as k8s LoadBlancer
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> kubectl get services
NAME                  TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
backend-end-service   ClusterIP      10.59.243.249   <none>         5432/TCP       65m
front-end-service     LoadBalancer   10.59.253.190   34.67.153.21   80:32033/TCP   62s <-- PUBLIC IP TO ACCESS THE APP
kubernetes            ClusterIP      10.59.240.1     <none>         443/TCP        106m

Verifying App can be accessible at 34.67.153.21:80

```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app$ 💃🏏🍎🌴 ☕️ --> curl -k 34.67.153.21
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Subnet calculation</title>
        <style>
body {background-color: powderblue;}
body {
    text-align: center;
}
form {
    display: inline-block;
}
        </style>
    </head>
    <body>
        <br>
        <br>
        <div class="form">
            <form method="POST">
                Enter network details:
                <input name="text">
                <input type="submit">
            </form>
    </body>
</html>krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app$ 💃🏏🍎🌴 ☕️ --> 
```

Verifying backend-service is not accessble from outside world.
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app$ 💃🏏🍎🌴 ☕️ --> curl -k 10.59.243.249
^C
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app$ 💃🏏🍎🌴 ☕️ --> 
```
* STEP 8: `terraform destroy`

NOTE: Here you may face many problems with terraform versions and provider versions. This terraform code is done with `Terraform v0.12.1`


## Troubleshooting tips

**Enabling the gcloud default application credentials**
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> terraform init 

Initializing the backend...

Error: storage.NewClient() failed: dialing: google: could not find default credentials. See https://developers.google.com/accounts/docs/application-default-credentials for more information.


krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> export GOOGLE_APPLICATION_CREDENTIALS="./key.json"
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/gcp$ 💃🏏🍎🌴 ☕️ --> 
```
**generating kubectlentry before kubernates provider**
```sh
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> kubectl config current-context
gke_gsa-demo-app_us-central1-a_demo-cluster
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> gcloud container clusters get-credentials demo-cluster --zone=us-central1-a
Fetching cluster endpoint and auth data.
kubeconfig entry generated for demo-cluster.
krishna@RamakrishnasMBP:~/to_gsa/gsa-hello-app/terraform/k8s$ 💃🏏🍎🌴 ☕️ --> kubectl get pods
No resources found in default namespace.
```
