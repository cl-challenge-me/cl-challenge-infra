resource "google_compute_region_ssl_certificate" "nginx-hello" {
  project     = module.project-networking.project_id
  name        = "nginx-hello-cert-${var.env}"
  private_key = var.NGINX_HELLO_PRIV_KEY
  certificate = var.NGINX_HELLO_CERT
}