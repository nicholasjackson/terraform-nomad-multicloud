resource "google_compute_network" "nomad" {
  name                    = "${var.namespace}-nomad"
  auto_create_subnetworks = "true"
}

/*
resource "google_compute_subnetwork" "nomad" {
  name          = "${var.namespace}-nomad-subnetwork"
  ip_cidr_range = "${var.cidr_block}"
  network       = "${google_compute_network.nomad.self_link}"
  region        = "${var.region}"
}
*/

