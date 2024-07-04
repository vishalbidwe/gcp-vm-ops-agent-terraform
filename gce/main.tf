# GCP Compute Engine Instance
resource "google_compute_instance" "nginx-server" {
  project                   = var.project
  name                      = "nginx-server"
  machine_type              = "e2-micro"
  zone                      = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    subnetwork = "default"
    access_config { // Ephemeral IP
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = file("./setup.sh")
}
