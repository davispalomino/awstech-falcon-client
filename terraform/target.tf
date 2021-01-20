resource "aws_lb_target_group" "this" {
  name        = "${var.owner}-${var.env}-${var.service}"
  target_type = var.type_targetgroup
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${data.aws_vpc.this.id}"

  health_check {
    interval            = 30
    path                = var.health_path
    protocol            = "HTTP"
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 10
    matcher             = "200-299"
  }
}

resource "aws_lb_listener_rule" "this" {
    listener_arn = "${data.aws_lb_listener.port80.arn}"
    priority     = var.alb_priority

    action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.this.arn}"
    }

    condition {
        host_header {
        values = ["${var.service}.${var.owner}.pe"]
        }
    }
  
}


