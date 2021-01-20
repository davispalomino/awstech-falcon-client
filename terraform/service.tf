resource "aws_ecs_service" "this" {
  name            = "${var.owner}-${var.env}-${var.service}"
  cluster         = "${var.owner}-${var.env}"
  launch_type     = var.type_task
  task_definition = "${aws_ecs_task_definition.this.arn}"
  desired_count   = 1

  # fargate
  # network_configuration {
  #   subnets         = "${data.aws_subnet_ids.pri.ids}"
  #   security_groups = ["${aws_security_group.service.id}"]
  # }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.this.arn}"
    container_name   = "${var.owner}-${var.env}-${var.service}"
    container_port   = 80
  }
}

resource "aws_appautoscaling_target" "this" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${var.owner}-${var.env}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}