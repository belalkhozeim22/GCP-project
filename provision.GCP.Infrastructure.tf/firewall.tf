resource "google_compute_firewall" "allow-ssh" {
  project     = "deploy-application-368815"
  name        = "allow-ssh"
  network     =  google_compute_network.vpc-network-gcp.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  description = "Creates firewall rule for instances"
  depends_on = [
    google_compute_network.vpc-network-gcp
  ]

  allow {
    protocol  = "tcp"
    ports     = ["22", "80","8000"]
  }
  
}

