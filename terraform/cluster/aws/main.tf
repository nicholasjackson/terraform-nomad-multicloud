module "suite" {
  source = "/Users/nicj/Developer/terraform/terraform-aws-hashicorp-suite"

  //source  = "nicholasjackson/hashicorp-suite/aws"
  //version = "0.2.1"

  namespace             = "${var.namespace}"
  min_servers           = "1"
  max_servers           = "3"
  min_agents            = "3"
  max_agents            = "5"
  subnets               = ["${aws_subnet.default.*.id}"]
  vpc_id                = "${aws_vpc.default.id}"
  key_name              = "${aws_key_pair.nomad.id}"
  security_group        = "${aws_security_group.nomad.id}"
  client_target_groups  = ["${aws_alb_target_group.nomad.arn}"]
  consul_enabled        = true
  consul_version        = "1.0.6"
  consul_join_tag_key   = "autojoin"
  consul_join_tag_value = "${var.namespace}"
  nomad_enabled         = true
  nomad_version         = "0.8.0-rc1"
  //nomad_version = "0.7.1"
  vault_enabled = true
  vault_version = "0.9.6"
}
