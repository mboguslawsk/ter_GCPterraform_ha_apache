resource "google_compute_instance" "instance_for_image" {
  name         = "tf-vm-for-image-bm"
  machine_type = "e2-medium"
  zone = var.zone

  tags = ["http-back-server", "allow-health-check"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-noble-amd64-v20251210" # <-- Ubuntu 24.04 LTS
    }
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet
    access_config {
      # This creates an ephemeral external IP for each VM
    }

  }

  metadata_startup_script = file("${path.module}/scripts/apache-startup.sh")
  desired_status = "TERMINATED"
}


resource "google_compute_image" "apache_golden" {
  name        = "tf-apache-golden-bm"
  source_disk = google_compute_instance.instance_for_image.boot_disk[0].source

  description = "Ubuntu image with preinstalled Apache"
}


resource "google_compute_instance_template" "default" {
  name    = "tf-apache-template-bm"
  project = var.project

  tags = ["http-back-server", "allow-health-check"]

  machine_type = "e2-medium"

  // Use an existing disk resource
  disk {
    source_image = google_compute_image.apache_golden.self_link
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = var.vpc_id
    subnetwork = var.subnet
  }  

  metadata_startup_script = file("${path.module}/scripts/apache-index.sh")
}


resource "google_compute_region_instance_group_manager" "appserver" {
  name = "tf-apache-mig-bm"

  base_instance_name = "apache-host"
  region             = var.region

  named_port {
    name = "http-port"
    port = 80
  }

  version {
    instance_template = google_compute_instance_template.default.self_link
  }

  target_size = 3

}
