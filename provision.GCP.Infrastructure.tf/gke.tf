resource "google_container_cluster" "jenkins-gke-cluster" {
  project  = "deploy-application-368815" 
  location = "us-central1-a" 
  name     = "jenkins-gke-cluster"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc-network-gcp.id
  subnetwork               = google_compute_subnetwork.restricted-subnet.id

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.1.0/24"
    }
  }

  ip_allocation_policy {

  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.1.0/28"
  }
}

resource "google_container_node_pool" "jenkins-cluster-nodes" {
  name       = "jenkins-cluster-nodes"
  location           = google_container_cluster.jenkins-gke-cluster.location
  cluster    = google_container_cluster.jenkins-gke-cluster.name
  node_count = 1

  node_config {
    machine_type    = "e2-medium"
    service_account = google_service_account.gke-sa.email
  }
}


  


 



