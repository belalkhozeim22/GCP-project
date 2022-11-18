resource "google_compute_instance" "jenkins-management-vm" {
  name         = "jenkins-management-vm"
  machine_type = "e2-medium"
  zone         = "${google_compute_subnetwork.managment-subnet.region}-a"

  service_account {
    email  = google_service_account.manage-sa.email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
     image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network =google_compute_network.vpc-network-gcp.id
    subnetwork =google_compute_subnetwork.managment-subnet.id
  }
}



