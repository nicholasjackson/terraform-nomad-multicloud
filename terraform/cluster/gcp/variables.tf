variable "namespace" {
  default = "nomadgcp"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "vpc_cidr_block" {
  default = "10.128.0.0/20"
}
