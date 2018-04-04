resource "aws_alb" "nomad" {
  name            = "${var.namespace}-nomad"
  internal        = false
  security_groups = ["${aws_security_group.nomad.id}"]
  subnets         = ["${aws_subnet.default.*.id}"]
}

resource "aws_alb_target_group" "nomad" {
  name     = "${var.namespace}-nomad"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.default.id}"

  health_check {
    path    = "/"
    matcher = "200,202"
  }
}

resource "aws_alb_listener" "nomad" {
  load_balancer_arn = "${aws_alb.nomad.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.nomad.arn}"
    type             = "forward"
  }
}
