provider "aws" {}

provider "google" {
  region  = "us-central1"
  project = "nomad-multi-cloud"
}

# Create AWS resources including a Nomad cluster and network
module "aws" {
  source = "./aws"

  vpc_cidr_block = "10.0.0.0/16"
}

/*
# Create GCP resources including a Nomad cluster and network
module "gcp" {
  source = "./gcp"

  vpc_cidr_block = "10.128.0.0/20"
}

# Create a VPN connection between GCP and AWS
module "vpn" {
  source  = "nicholasjackson/gcp-vpn/aws"
  version = "0.1.0"

  aws_cidr = "10.0.0.0/16"
  gcp_cidr = "10.128.0.0/20"

  aws_region = "eu-west-1"
  gcp_region = "us-central1"

  gcp_network = "${module.gcp.network}"

  aws_vpc            = "${module.aws.vpc_id}"
  aws_sg             = "${module.aws.security_group_id}"
  aws_route_table_id = "${module.aws.route_table_id}"
}
*/

