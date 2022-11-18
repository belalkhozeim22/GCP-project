resource "google_compute_router" "route-table" {
  name    = "route-table"
  region  = "us-central1"
  network = google_compute_network.vpc-network-gcp.id
}