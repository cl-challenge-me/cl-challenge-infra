resource "google_compute_global_network_endpoint_group" "external_proxy" {
  provider              = google-beta
  project               = module.project-networking.project_id
  name                  = "network-endpoint"
  network_endpoint_type = "INTERNET_FQDN_PORT"
  default_port          = "443"
}

resource "google_compute_global_network_endpoint" "proxy" {
  provider = google-beta
  project  = module.project-networking.project_id

  global_network_endpoint_group = google_compute_global_network_endpoint_group.external_proxy.id
  fqdn                          = "nginx-hello-t2znprr3xa-lz.a.run.app"
  port                          = google_compute_global_network_endpoint_group.external_proxy.default_port
}

resource "google_compute_backend_service" "default" {
  provider = google-beta
  project  = module.project-networking.project_id

  name                            = "backend-service"
  enable_cdn                      = true
  timeout_sec                     = 10
  connection_draining_timeout_sec = 10

  custom_request_headers  = ["host: ${google_compute_global_network_endpoint.proxy.fqdn}"]
  custom_response_headers = ["X-Cache-Hit: {cdn_cache_status}"]

  backend {
    group = google_compute_global_network_endpoint_group.external_proxy.id
  }
  protocol = "HTTPS"
}

resource "google_compute_global_address" "default" {
  provider = google-beta
  project  = module.project-networking.project_id
  name     = "tcp-proxy-xlb-ip"
}

resource "google_compute_target_https_proxy" "default" {
  project = module.project-networking.project_id

  name             = "test-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_ssl_certificate.default.id]
}

resource "google_compute_url_map" "default" {
  project = module.project-networking.project_id

  name        = "url-map"
  description = "a description"

  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["example.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.id
  }
}

resource "google_compute_global_forwarding_rule" "default" {
  project  = module.project-networking.project_id

  name                  = "ssl-proxy-xlb-forwarding-rule"
  provider              = google
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
