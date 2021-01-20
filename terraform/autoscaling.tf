#CPU
resource "aws_cloudwatch_metric_alarm" "autoscaling_high" {
  alarm_name          = "${var.owner}-${var.env}-${var.service}-CPU-Utilization-High-${var.autoscaling_high}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.autoscaling_high

  dimensions = {
    ClusterName = "${var.owner}-${var.env}"
    ServiceName = aws_ecs_service.this.name
  }

}

resource "aws_cloudwatch_metric_alarm" "autoscaling_low" {
  alarm_name          = "${var.owner}-${var.env}-${var.service}-CPU-Utilization-Low-${var.autoscaling_low}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.autoscaling_low

  dimensions = {
    ClusterName = "${var.owner}-${var.env}"
    ServiceName = aws_ecs_service.this.name
  }

}

resource "aws_appautoscaling_policy" "cpu_app_up" {
  name               = "cpu_app-scale-up"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
        scaling_adjustment          = 1
        metric_interval_lower_bound = 0 
        metric_interval_upper_bound = 10
    }
    step_adjustment {
        scaling_adjustment          = 2
        metric_interval_lower_bound = 10
        metric_interval_upper_bound = 20
    }
    step_adjustment {
        scaling_adjustment          = 3
        metric_interval_lower_bound = 20
    }
  }
}

resource "aws_appautoscaling_policy" "cpu_app_down" {
  name               = "cpu_app-scale-down"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

#RAM
resource "aws_cloudwatch_metric_alarm" "ram_high" {
  alarm_name          = "${var.owner}-${var.env}-${var.service}-CPU-MemoryUtilization-High-${var.autoscaling_high}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.autoscaling_high

  dimensions = {
    ClusterName = "${var.owner}-${var.env}"
    ServiceName = aws_ecs_service.this.name
  }

}

resource "aws_cloudwatch_metric_alarm" "ram_low" {
  alarm_name          = "${var.owner}-${var.env}-${var.service}-CPU-MemoryUtilization-Low-${var.autoscaling_low}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.autoscaling_low

  dimensions = {
    ClusterName = "${var.owner}-${var.env}"
    ServiceName = aws_ecs_service.this.name
  }

}

resource "aws_appautoscaling_policy" "ram_app_up" {
  name               = "ram_app-scale-up"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
        scaling_adjustment          = 1
        metric_interval_lower_bound = 0 
        metric_interval_upper_bound = 10
    }
    step_adjustment {
        scaling_adjustment          = 2
        metric_interval_lower_bound = 10
        metric_interval_upper_bound = 20
    }
    step_adjustment {
        scaling_adjustment          = 3
        metric_interval_lower_bound = 20
    }
  }
}

resource "aws_appautoscaling_policy" "ram_app_down" {
  name               = "ram_app-scale-down"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}