############################# Shared ##################################
resource "aws_security_group" "ecs_alb_sg" {
  name        = var.ecs_alb_sg_name
  description = "controls access to the ALB"
  vpc_id      = var.ecs_alb_sg_vpc_id

  ingress {
    protocol = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.ecs_alb_sg_tags

  lifecycle {
    ignore_changes = [
      ingress
    ]
  }
}

############################## Prod #####################################
# this security group for ecs - Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "prod_ecs_sg" {
  name        = var.prod_ecs_sg_name
  description = "allow inbound access from the ALB only"
  vpc_id      = var.prod_ecs_sg_vpc_id

  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    security_groups = [aws_security_group.ecs_alb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.prod_ecs_sg_tags

}