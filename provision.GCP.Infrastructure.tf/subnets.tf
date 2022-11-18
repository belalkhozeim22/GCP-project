resource "google_compute_subnetwork" "managment-subnet" {
  name          = "managment-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc-network-gcp.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "restricted-subnet" {
  name          = "restricted-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc-network-gcp.id
  private_ip_google_access = true
}

