output "db_subnet_group_name" {
  value = aws_db_subnet_group.prod_db_subnet.name
}

output "sg_ids" {
  value = aws_security_group.prod_rds_sg.id
}