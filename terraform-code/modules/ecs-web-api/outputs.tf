output "prod_url" {
  value = aws_alb.public_alb.dns_name
}

output "sg_app_layer" {
  value = aws_security_group.prod_ecs_sg.id
}

output "db_host_shorten" {
  value = aws_route53_record.prod_db_dns_record.fqdn
}