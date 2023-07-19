############################## Prod #############################
resource "aws_ecs_cluster" "prod_ecs_cluster" {
  name = var.prod_ecs_cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

resource "aws_ecs_task_definition" "prod_ecs_task_def" {
  family = var.prod_ecs_task_def_family
  requires_compatibilities = ["EC2"]
  execution_role_arn = aws_iam_role.ecs_iam_role.arn
  container_definitions = jsonencode([
    {
      name         = var.prod_ecs_container_name
      image        = "${var.docker_image_url}"
      cpu          = var.prod_task_def_ecs_cpu
      memory       = var.prod_task_def_ecs_memory
      network_mode = var.prod_task_def_ecs_net_mode
      environment = []
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.prod_ecs_log_group.name
          awslogs-region        = var.prod_task_def_awslogs_region
          awslogs-stream-prefix = var.prod_task_def_awslogs_stream_prefix
        }
      }
      portMappings = [
        {
          containerPort = var.prod_task_def_containerport
          hostPort      = 0
          protocol = "tcp"
        }
      ]
      healthCheck = {
        command = [ "CMD-SHELL", "python3 manage.py check  || exit 1" ]
        startPeriod = 10
        interval = 30
        retries = 3
        timeout = 5
      }
      mountPoints = []
      volumesFrom = []
      secrets = [
        {
          name = "DEBUG"
          valueFrom = "${aws_secretsmanager_secret_version.prod_env.arn}:DEBUG::"
        },
        {
          name = "DB_NAME"
          valueFrom = "${aws_secretsmanager_secret_version.prod_env.arn}:DB_NAME::"
        },
        {
          name = "DB_HOST"
          valueFrom = "${aws_secretsmanager_secret_version.prod_env.arn}:DB_HOST::"
        },
        {
          name = "DB_PORT"
          valueFrom = "${aws_secretsmanager_secret_version.prod_env.arn}:DB_PORT::"
        },
        {
          name = "DB_USER"
          valueFrom = "${aws_secretsmanager_secret_version.prod_env.arn}:DB_USER::"
        },
        {
          name = "DB_PASS"
          valueFrom = "${aws_secretsmanager_secret_version.prod_env.arn}:DB_PASS::"
        },
        {
          name = "DJANGO_SECRET_KEY"
          valueFrom = "${aws_secretsmanager_secret_version.prod_env.arn}:DJANGO_SECRET_KEY::"
        },
      ]
    }
  ])
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.active_aws_region}b, ${var.active_aws_region}a]"
  }


  lifecycle {
    create_before_destroy = true

  }
}

resource "aws_ecs_service" "prod_ecs_service" {
  name            = var.prod_ecs_service_name
  cluster         = aws_ecs_cluster.prod_ecs_cluster.id
  task_definition = aws_ecs_task_definition.prod_ecs_task_def.arn
  desired_count   = var.prod_desired_task_count
  launch_type     = "EC2"
  deployment_circuit_breaker {
    enable = true
    rollback = true
  }
  deployment_minimum_healthy_percent = 50
  force_new_deployment = true

  load_balancer {
    target_group_arn = aws_alb_target_group.prod_ecs_alb_targ.arn
    container_name   = var.prod_ecs_container_name
    container_port   = var.prod_task_def_containerport
  }
  
  ordered_placement_strategy {
    type = "spread"
    field = "instanceId"
  }

}

resource "aws_appautoscaling_target" "prod_ecs_service_autoscaling" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = format("service/%s/%s", aws_ecs_cluster.prod_ecs_cluster.name, aws_ecs_service.prod_ecs_service.name)
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "prod_ecs_mem_usage_policy" {
  name               = var.prod_ecs_mem_usage_policy_name
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.prod_ecs_service_autoscaling.resource_id
  scalable_dimension = aws_appautoscaling_target.prod_ecs_service_autoscaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.prod_ecs_service_autoscaling.service_namespace

  target_tracking_scaling_policy_configuration {
    disable_scale_in = false
    scale_in_cooldown = 60
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 70
  }
}