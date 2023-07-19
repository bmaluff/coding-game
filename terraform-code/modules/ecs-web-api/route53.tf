resource "aws_route53_zone" "prod_private_zone" {
  name = var.private_zone_name
  vpc {
    vpc_id = var.vpc_id_route53
  }
}

resource "aws_route53_record" "prod_db_dns_record" {
  zone_id = aws_route53_zone.prod_private_zone.zone_id
  name = "db"
  type = "CNAME"
  ttl = 300
  records = var.db_records
}