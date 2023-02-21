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

module "gce-lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "7.0.0"

  project = module.project-networking.project_id
  name    = "group-http-lb"
  ssl     = true

  private_key = var.NGINX_HELLO_PRIV_KEY
  certificate = var.NGINX_HELLO_CERT

  firewall_networks = []

  backends = {
    default = {
      description             = null
      port                    = "443"
      protocol                = "HTTPS"
      timeout_sec             = 10
      port_name               = "https"
      enable_cdn              = false
      custom_request_headers  = null
      custom_response_headers = null
      security_policy         = null
      compression_mode        = null

      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null

      health_check = null

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                        = google_compute_region_network_endpoint_group.psc-neg.id
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
          health_check                 = null
        },
      ]

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
}

resource "google_compute_region_network_endpoint_group" "psc-neg" {
  project               = module.project-networking.project_id
  name                  = "nginx-hello-psc-neg"
  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = "projects/nginx-hello-dev-19252/regions/europe-north1/serviceAttachments/hello-app"
  network               = module.project-networking.network_id
  subnetwork            = module.project-networking.subnet_id
  region                = var.region
}