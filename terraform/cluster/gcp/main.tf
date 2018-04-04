module "gcp" {
  source  = "nicholasjackson/hashicorp-suite/gcp"
  version = "0.2.0"

  namespace = "${var.namespace}"
  zone      = "${var.zone}"

  min_servers = "3"
  max_servers = "5"
  min_agents  = "5"
  max_agents  = "8"

  vpc_id   = "${google_compute_network.nomad.name}"
  key_name = "~/.ssh/id_rsa.pub"

  /*
  client_target_groups = ["${aws_alb_target_group.proxy.arn}"]
  server_target_groups = ["${aws_alb_target_group.nomad.arn}"]
  */

  consul_enabled        = true
  consul_version        = "1.0.6"
  consul_join_tag_key   = "autojoin"
  consul_join_tag_value = "${var.namespace}"
  nomad_enabled         = true
  nomad_version         = "0.7.1"
}
