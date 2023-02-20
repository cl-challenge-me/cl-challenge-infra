# Shared VPC network - proxy-only subnet
resource "google_compute_subnetwork" "proxy" {
  name     = "proxy-only-subnet"
  provider = google-beta
  project  = module.project-networking.project_id

  ip_cidr_range = var.proxy_ip_cidr_range
  role          = "ACTIVE"
  purpose       = "REGIONAL_MANAGED_PROXY"
  network       = module.project-networking.network_id
}

resource "google_compute_address" "default" {
  project      = module.project-networking.project_id
  name         = "ext-${var.region}-lb-fe-ip"
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "default" {
  project = module.project-networking.project_id

  depends_on = [google_compute_subnetwork.proxy]
  name       = "ext-${var.region}-lb"

  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_region_target_https_proxy.default.id
  network               = module.project-networking.network_id
  ip_address            = google_compute_address.default.id
  network_tier          = "STANDARD"
}

resource "google_compute_region_target_https_proxy" "default" {
  project = module.project-networking.project_id

  name             = "ext-${var.region}-lb-https-proxy"
  url_map          = google_compute_region_url_map.default.id
  ssl_certificates = [google_compute_region_ssl_certificate.nginx-hello.id]
}

resource "google_compute_region_url_map" "default" {
  project = module.project-networking.project_id

  name            = "ext-${var.region}-lb-url-map"
  default_service = var.nginx_app_svc
  depends_on = [
    google_compute_shared_vpc_service_project.app-project
  ]
}

data "google_compute_zones" "available" {
  project = module.project-networking.project_id
}

# Compute instance helper VM
resource "google_compute_instance" "magic-vm" {
  project      = module.project-networking.project_id
  name         = "magic-vm-${var.env}"
  machine_type = "f1-micro"
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = module.project-networking.network_id
    subnetwork = module.project-networking.subnet_id
  }
}