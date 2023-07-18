output "vpc_id" {
  value = module.network_layer.vpc_id
}

output "public_subnet_ids" {
  value = module.network_layer.public_subnets
}

output "private_subnets_ids" {
  value = module.network_layer.private_subnets
}

output "public_url" {
  value = module.ecs_web_api.prod_url
}

output "db_host" {
  value = module.data_layer.db_instance_address
}

output "db_port" {
  value = module.data_layer.db_instance_port
}

output "secrets_arn" {
  value = module.data_layer.db_instance_master_user_secret_arn
}