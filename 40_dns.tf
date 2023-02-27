module "cloud-ep-dns" {
  source      = "terraform-google-modules/endpoints-dns/google"
  project     = module.project-networking.project_id
  name        = var.app_name
  external_ip = google_compute_global_address.lb-fe-ip.address

  depends_on = [
    module.project-networking
  ]
}