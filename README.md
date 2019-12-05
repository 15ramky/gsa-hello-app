AUTHOR  : Ramakrishna Kothamasu
EMAIL   : krishna.ubuntu@gmail.com  
VERSION : 0.0.1 (Draft)

# *GroundSpeed Analytics Hello World App8
This page describes how to run this hello application

## prerequasites
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

### I am trying to deploy the application with terraform (IaaC)

* STEP 1: create backend bucket for terraform state file

#### Chicken end egg problem
IMPARTENT: to create terraform backend, first create Storage bucket (storage_bucket.tf), without backend.tf (TRICK `mv -v backend.tf backend.tf.bkp` and then `mv -v backend.tf.bkp backend.tf`)

* STEP 2: Create k8s cluster with terraform
* STEP 3: Create k8s nodepool with terraform
<!-- fronend for Flask app and backend for postgres pods--> 
* STEP 4: Create k8s deployments with terraform
<!-- frontend will be advertised to outside world as HTTPS LoadBalancer and postgres will use only ClusterIP and only available to pods with in the Cluster -->
* STEP 5: Create k8s services with terraform
* STEP 6: destroy terraform

NOTE: Here you may face many problems with terraform versions and provider version.
NOTE: This terraform code is done with `Terraform v0.12.1`


