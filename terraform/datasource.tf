# capturar id de vpc
data "aws_vpc" "this" {
  tags = {
    Name = "${var.owner}-${var.env}"
  }
}

# capturar id de subnets publicas
data "aws_subnet_ids" "pub" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    Tier = "pub"
  }
}

# capturar id de subnets privadas
data "aws_subnet_ids" "pri" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    Tier = "pri"
  }
}

# capturar arn load balancer
data "aws_lb" "this" {
  name = "${var.owner}-${var.env}-external"
}

#capturar listener 80
data "aws_lb_listener" "port80" {
  load_balancer_arn = data.aws_lb.this.arn
  port              = 80
}