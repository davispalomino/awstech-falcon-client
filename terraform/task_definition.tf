data "template_file" "task_definition" {
  template = "${file("task_definition.tpl")}"
  vars = {
    name  = "${var.owner}-${var.env}-${var.service}"
    image  = "${var.image}"
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.owner}-${var.env}-${var.service}"
  requires_compatibilities = [var.type_task]
  network_mode             = var.type_network
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${aws_iam_role.role-task.arn}"
  task_role_arn            = "${aws_iam_role.role-task.arn}"
  container_definitions    = "${data.template_file.task_definition.rendered}"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.owner}-${var.env}-${var.service}"
  retention_in_days = 7
  tags = {
    Owner = "${var.owner}"
    Env = "${var.env}"
    Service = "${var.service}"
  }
}
