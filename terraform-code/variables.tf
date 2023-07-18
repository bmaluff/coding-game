variable "main_product_name" {
  default = "django-api"
}

variable "default_instance_type" {
  default = "t2.micro"
}

variable "active_aws_region" {
  default = "us-east-1"
}
variable "default_health_check_tg" {
  default = "/api/"
}
variable "default_net_mode" {
  default     = "bridge"
  description = "network mode for the ecs instances"
}

variable "docker_image_url" {
  type = string
}

###################################### Test ##############################
variable "test_cpu" {
  default     = 200
  description = "instance CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "test_memory" {
  default     = 450
  description = "instance memory to provision (in MiB) not MB"
}

variable "test_containerport" {
  default     = 8000
  description = "default app port"
}

###################################### Stage ##############################
variable "stage_cpu" {
  default     = 200
  description = "instance CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "stage_memory" {
  default     = 450
  description = "instance memory to provision (in MiB) not MB"
}

variable "stage_containerport" {
  default     = 8000
  description = "default app port"
}

###################################### Prod ##############################
variable "prod_cpu" {
  default     = 200
  description = "instance CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "prod_memory" {
  default     = 450
  description = "instance memory to provision (in MiB) not MB"
}

variable "prod_containerport" {
  default     = 8000
  description = "default app port"
}

################################ RDS ################################
variable "db_instance_name" {
  type = string
  default = "coding-game"
}

variable "db_username" {
  type = string
  default = "coding-game"
}