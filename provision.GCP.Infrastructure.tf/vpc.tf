resource "google_compute_network" "vpc-network-gcp" {
  project  = "deploy-application-368815"
  name                    = "vpc-network-gcp"
  auto_create_subnetworks = false
  mtu                     = 1460

}

