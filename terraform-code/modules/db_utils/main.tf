resource "aws_db_subnet_group" "prod_db_subnet" {
  name       = var.subnet_group_name
  subnet_ids = var.private_subnets
  tags = var.db_subnet_tags
}

resource "aws_security_group" "prod_rds_sg" {
  name   = var.rds_sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = var.sg_privates
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.sg_tags
}