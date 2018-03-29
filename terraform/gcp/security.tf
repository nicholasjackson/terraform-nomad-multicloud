resource "google_compute_firewall" "internal" {
  name          = "internal"
  network       = "${google_compute_network.nomad.name}"
  source_ranges = ["${var.vpc_cidr_block}"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "external" {
  name          = "external"
  network       = "${google_compute_network.nomad.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
  }
}
