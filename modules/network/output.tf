output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet" {
  value = google_compute_subnetwork.subnet.id
}

output "security_policy_id" {
  value = google_compute_security_policy.allow_ip_only.id
}