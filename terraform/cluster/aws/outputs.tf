output "security_group_id" {
  value = "${aws_security_group.nomad.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "route_table_id" {
  value = "${aws_vpc.default.main_route_table_id}"
}

output "alb" {
  value = "${aws_alb.nomad.dns_name}"
}
