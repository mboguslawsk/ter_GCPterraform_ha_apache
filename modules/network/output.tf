output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet" {
  value = google_compute_subnetwork.subnet.id
}