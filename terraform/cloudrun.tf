variable "project" {}

variable "region" {}

provider "google" {
  project = var.project
  region  = var.region
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service" "my_service" {
  name     = "my-cloud-run-service"
  location = var.region

  template {
    spec {
      containers {
        image = "vickcode/react-springboot"
        
      } 
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.run_api
  ]
}

resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.my_service.location
  project     = var.project
  service     = google_cloud_run_service.my_service.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

