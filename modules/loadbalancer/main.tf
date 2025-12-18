# reserved IP address
resource "google_compute_global_address" "default" {
  name    = "tf-l7-xlb-static-ip-bm"
  project = var.project
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "tf-l7-xlb-forwarding-rule-bm"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "tf-l7-xlb-target-http-proxy-bm"
  url_map = google_compute_url_map.default.id
}

# url map
resource "google_compute_url_map" "default" {
  name            = "tf-l7-xlb-url-map-bm"
  default_service = google_compute_backend_service.default.id
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "default" {
  name                  = "tf-l7-xlb-backend-service-bm"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  port_name             = "http-port"
  timeout_sec           = 10
  enable_cdn            = true

  health_checks = [google_compute_health_check.http-health-check.id]

  backend {
    group           = var.igm_instance_grp
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_health_check" "http-health-check" {
  name    = "tf-http-health-check-bm"
  project = var.project

  http_health_check {
    port               = 80
    port_specification = "USE_FIXED_PORT"
  }
}