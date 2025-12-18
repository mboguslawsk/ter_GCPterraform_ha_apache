resource "google_compute_network" "vpc" {
  name                    = "tf-vpc-bm"
  project                 = var.project
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "tf-subnet-bm"
  ip_cidr_range = "10.0.8.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "default" {
  name    = "tf-firewall-bm"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  # source_ranges = concat(var.allow_ip, ["130.211.0.0/22", "35.191.0.0/16"])
  source_ranges = var.allow_ip
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-back-server"]
}