variable "namespace" {
  default = "nomad-multi-cloud"
}

variable "ssh_key" {
  default     = "~/.ssh/id_rsa.pub"
  description = "SSH public key to add to instances"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "instance_type" {
  default = "t2.micro"
}
