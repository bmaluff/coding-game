locals {
  prod_env = "${var.main_product_name}-prod"

}

module "network_layer" {
  source  = "terraform-aws-modules/vpc/aws"
  name              = "test-bader"
  cidr = "10.10.0.0/16"
  azs             = ["${var.active_aws_region}a", "${var.active_aws_region}b"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.10.0/24", "10.10.20.0/24"]
  enable_nat_gateway = true
  enable_dns_hostnames = true
  tags = {
    Terraform = "true"
    Environment = "production"
  }
}

module "ecs_web_api" {
  source = "./modules/ecs-web-api"
  active_aws_region = var.active_aws_region
  
  ################################# ASG #######################
  
  ##################### Prod #####################
  prod_ecs_template_name = "${local.prod_env}-ecs"
  prod_ecs_template_image_id = data.aws_ami.aws_ami_ecs_64.id
  prod_ecs_template_instance_type = var.default_instance_type
  prod_ecs_template_tags = {
    "Name" = "${local.prod_env}-ec2"
  }
  prod_ecs_asg_name = "${local.prod_env}-ecs"
  prod_ecs_asg_tag_name = "${local.prod_env}"
  prod_ecs_asg_vpc_zone_identifiers = module.network_layer.private_subnets
  prod_ecs_cap_prov_name = "${local.prod_env}-ecs"

  ###################################### cloudwatch ################################
  ############################ Prod ################################
  prod_ecs_log_group_name = "/tle/${local.prod_env}-ecs"
  prod_ecs_log_group_tags = {
    Environment = "Prod"
    Application = "${local.prod_env}"
  }
  prod_ecs_log_stream_name = "${local.prod_env}-ecs"

  ######################################## SECRETS ###################################
  ############################ Prod ################################
  prod_env_secret_name = "${local.prod_env}-env"

  ######################################## ECS ###########################################
  docker_image_url = var.docker_image_url
  ############################ Prod ################################
  prod_ecs_cluster_name = "${local.prod_env}"
  prod_ecs_task_def_family = "${local.prod_env}"
  prod_ecs_container_name = "${local.prod_env}"
  prod_task_def_ecs_cpu = var.prod_cpu
  prod_task_def_ecs_memory = var.prod_memory
  prod_task_def_ecs_net_mode = var.default_net_mode
  prod_task_def_awslogs_region = var.active_aws_region
  prod_task_def_awslogs_stream_prefix = "${local.prod_env}-ecs"
  prod_task_def_containerport = var.prod_containerport
  prod_ecs_service_name = "${local.prod_env}"
  prod_desired_task_count = 1
  prod_ecs_mem_usage_policy_name = "${local.prod_env}-service-mem-usage-policy"

  ######################################## IAM #######################################
  ecs_task_execution_role_name = "${var.main_product_name}_ecs_task_exec"
  ecs_iam_role_name = "${var.main_product_name}-ecs"
  ecs_instance_role_name = "${var.main_product_name}-ec2-ecs"
  ecs_instance_role_profile_name = "${var.main_product_name}-ecs"
  events_api_invocation_role_name = "${var.main_product_name}_eventbridge_invocation"
  events_api_invocation_policy_name = "${var.main_product_name}_eventbridge_invocation"
  ecs_role_secrets_manager_policy_name = "${var.main_product_name}_ecs_secrets"

  ####################################### ALB #######################################
  public_alb_name = "${var.main_product_name}-ecs"
  public_alb_subnets = module.network_layer.public_subnets

  ############################## Prod #######################
  prod_ecs_alb_targ_name = "${local.prod_env}"
  prod_ecs_alb_targ_port = var.prod_containerport
  prod_ecs_alb_targ_vpc_id = module.network_layer.vpc_id
  prod_ecs_alb_targ_health_check_path = var.default_health_check_tg

  ########################################### SG ###############################
  ecs_alb_sg_name = "${var.main_product_name}-alb"
  ecs_alb_sg_vpc_id = module.network_layer.vpc_id
  ecs_alb_sg_tags = {
    "Name" = "${var.main_product_name}-alb"
  }
  ######################## Prod ##########################
  prod_ecs_sg_name = "${local.prod_env}"
  prod_ecs_sg_vpc_id = module.network_layer.vpc_id
  prod_ecs_sg_tags = {
    "Name" = "${local.prod_env}"
  }

}