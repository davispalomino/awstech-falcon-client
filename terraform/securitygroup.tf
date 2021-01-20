resource "aws_security_group" "service" {
  name_prefix = "${var.owner}-${var.env}-${var.service}-service"
  description = "virtual firewall that controls the traffic"
  vpc_id      = "${data.aws_vpc.this.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle  {
    create_before_destroy = true
  }
}