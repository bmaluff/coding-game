resource "aws_launch_template" "prod_ecs_launch_template" {
  name          = var.prod_ecs_template_name
  image_id      = var.prod_ecs_template_image_id
  instance_type = var.prod_ecs_template_instance_type
  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance_role_profile.arn
  }
  user_data = base64encode(templatefile("${path.module}/public_files/user_data_ecs.tftpl", {ECS_CLUSTER_NAME=aws_ecs_cluster.prod_ecs_cluster.name}))
  tags = var.prod_ecs_template_tags
  update_default_version = true
  vpc_security_group_ids = [aws_security_group.prod_ecs_sg.id]

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      encrypted             = true
      volume_size           = 10
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }
  key_name = aws_key_pair.prod_key_pair.key_name
}


resource "aws_autoscaling_group" "prod_ecs_asg" {

  # ... other configuration, including potentially other tags ...
  name                  = var.prod_ecs_asg_name
  min_size              = 0
  max_size              = 2
  desired_capacity      = 1
  vpc_zone_identifier   = var.prod_ecs_asg_vpc_zone_identifiers
  protect_from_scale_in = true
  health_check_grace_period = 120
  default_cooldown      = 60
  warm_pool {
    pool_state                  = "Stopped"
    min_size                    = 1
    max_group_prepared_capacity = 2
  }
  launch_template {
    id      = aws_launch_template.prod_ecs_launch_template.id
    version = aws_launch_template.prod_ecs_launch_template.latest_version
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      checkpoint_delay = 120
      checkpoint_percentages = [50, 100]
      skip_matching = true
    }
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
  tag {
    key                 = "Name"
    value               = var.prod_ecs_asg_tag_name
    propagate_at_launch = true
  }
  depends_on = [
    aws_ecs_cluster.prod_ecs_cluster
  ]

}

resource "aws_ecs_capacity_provider" "prod_ecs_cap_prov" {
  name = var.prod_ecs_cap_prov_name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.prod_ecs_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 100
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 80
      instance_warmup_period = 120
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "prod_ecs_clus_cap_prov" {
  cluster_name = aws_ecs_cluster.prod_ecs_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.prod_ecs_cap_prov.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.prod_ecs_cap_prov.name
  }
}
