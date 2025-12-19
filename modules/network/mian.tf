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

# healthcheck firewall rule
resource "google_compute_firewall" "default" {
  name    = "tf-firewall-bm"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }



  target_tags = ["http-back-server"]
}

resource "google_compute_security_policy" "allow_ip_only" {
  name = "tf-allow-ip-only-bm"

  description = "Allow specific traffic"

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = var.allow_ip
      }
    }
    description = "Allow access to IPs in var.allow_ip"
  }

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule: deny all"
  }
}
