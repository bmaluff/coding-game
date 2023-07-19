################################## Global #######################################
variable "active_aws_region" {
  default = "us-east-1"
}

###################################### Autoscale ################################
############################ Prod ################################

variable "prod_ecs_template_name" {
  type = string
}
variable "prod_ecs_template_image_id" {
  type = string
}
variable "prod_ecs_template_instance_type" {
  type = string
}
variable "prod_ecs_template_tags" {
  type = map(string)
  default = {}
}

variable "prod_ecs_asg_name" {
  type = string
}
variable "prod_ecs_asg_vpc_zone_identifiers" {
  type = list(string)
}
variable "prod_ecs_asg_tag_name" {
  type = string
}
variable "prod_ecs_cap_prov_name" {
  type = string
}

###################################### cloudwatch ################################
############################ Prod ################################

variable "prod_ecs_log_group_name" {
  type = string
}

variable "prod_ecs_log_group_tags" {
  type = map(string)
  default = {}
}

variable "prod_ecs_log_stream_name" {
  type = string
}

######################################## ECS ###########################################
variable "docker_image_url" {
  type = string
}
############################ Prod ################################
variable "prod_ecs_cluster_name" {
  type = string
}

variable "prod_ecs_task_def_family" {
  type = string
}
variable "prod_ecs_container_name" {
  type = string
}
variable "prod_task_def_ecs_cpu" {
  type = number
}
variable "prod_task_def_ecs_memory" {
  type = number
}
variable "prod_task_def_ecs_net_mode" {
  type = string
}
variable "prod_task_def_awslogs_region" {
  type = string
}
variable "prod_task_def_awslogs_stream_prefix" {
  type = string
}
variable "prod_task_def_containerport" {
  type = number
}
variable "prod_ecs_service_name" {
  type = string
}
variable "prod_desired_task_count" {
  type = string
}

variable "prod_ecs_mem_usage_policy_name" {
  type = string
}


############################################# IAM #############################################
variable "ecs_task_execution_role_name" {
  type = string
}
variable "ecs_iam_role_name" {
  type = string
}
variable "ecs_instance_role_name" {
  type = string
}
variable "ecs_instance_role_profile_name" {
  type = string
}
variable "events_api_invocation_role_name" {
  type = string
}
variable "events_api_invocation_policy_name" {
  type = string
}
variable "ecs_role_secrets_manager_policy_name" {
  type = string
}

############################################# ALB #############################################
variable "public_alb_name" {
  type = string
}
variable "public_alb_subnets" {
  type = list(string)
}
variable "public_alb_http_listener_port" {
  type = number
  default = 80
}
variable "public_alb_https_listener_port" {
  type = number
  default = 443
}

############################ Prod ################################
variable "prod_ecs_alb_targ_name" {
  type = string
}
variable "prod_ecs_alb_targ_port" {
  type = string
}
variable "prod_ecs_alb_targ_vpc_id" {
  type = string
}
variable "prod_ecs_alb_targ_health_check_path" {
  type = string
}

############################################## SG #####################################
variable "ecs_alb_sg_name" {
  type = string
}
variable "ecs_alb_sg_vpc_id" {
  type = string
}
variable "ecs_alb_sg_tags" {
  type = map(string)
  default = {}
}

################################## Prod ######################
variable "prod_ecs_sg_name" {
  type = string
}
variable "prod_ecs_sg_vpc_id" {
  type = string
}
variable "prod_ecs_sg_tags" {
  type = map(string)
  default = {}
}

############################ Secrets ###########################
variable "prod_env_secret_name" {
  type = string
}

variable "vpc_id_route53" {
 type = string 
}

variable "db_records" {
  type = list(string)
}

variable "private_zone_name" {
  type = string
}