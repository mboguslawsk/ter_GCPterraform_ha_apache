output "healthcheck_id" {
  value = google_compute_health_check.http-health-check.id
}

output "l7_public_ip" {
  value = google_compute_global_address.default.address
}