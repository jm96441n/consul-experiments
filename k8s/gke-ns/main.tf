variable "project_id" {
  type        = string
  nullable    = false
  description = "The project ID to deploy resources to."
}

variable "cluster_name" {
  type        = string
  nullable    = false
  description = "Name for the single stack cluster."
}


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-west2"
}

data "google_container_engine_versions" "west2a" {
  provider       = google
  location       = "us-west2-a"
  project        = var.project_id
  version_prefix = "1."
}



resource "google_container_cluster" "cluster" {
  name                = var.cluster_name
  project             = var.project_id
  location            = "us-west2-a"
  deletion_protection = false
  initial_node_count  = 4
  networking_mode     = "VPC_NATIVE"
  min_master_version  = data.google_container_engine_versions.west2a.latest_node_version
  node_version        = data.google_container_engine_versions.west2a.latest_node_version
  node_config {
    machine_type = "n1-standard-2"
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
# resource "google_project_service" "compute" {
# service = "compute.googleapis.com"
# project = var.project_id
# }

# resource "google_project_service" "container" {
# service = "container.googleapis.com"
# project = var.project_id
# }

