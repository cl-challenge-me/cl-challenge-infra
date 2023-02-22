locals {
  services = [
    "compute.googleapis.com"
  ]
}

module "project-networking" {
  source = "../cl-challenge-base-project"
  # "git@github.com:pavelrn/cl-challenge-base-project.git?ref=v1.4"
  name            = "networking-${var.env}"
  folder_id       = var.folder_id
  services        = local.services
  billing_account = var.billing_account
  region          = var.region
  ip_cidr_range   = var.ip_cidr_range
}