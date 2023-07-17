output "prod_url" {
  value = aws_alb.public_alb.dns_name
}