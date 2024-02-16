variable "project" {}

variable "region" {}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_sql_database_instance" "master" {
  name            = "bharvest"
  database_version = "MYSQL_5_7"
  region          = var.region
  deletion_protection = false

  settings {
    tier = "db-n1-standard-2"
  }
}

resource "google_sql_database" "database" {
  name     = "payroll"
  instance = google_sql_database_instance.master.name
  charset  = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "users" {
  name     = "myuser"
  instance = google_sql_database_instance.master.name
  host     = "%"
  password = "p@ss**##"
}

resource "google_project_service" "cloudsql_api" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = true
}

