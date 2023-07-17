################ Shared Components ##################
resource "aws_alb" "public_alb" {
  name               = var.public_alb_name
  subnets            = var.public_alb_subnets
  security_groups    = [ aws_security_group.ecs_alb_sg.id ]
  load_balancer_type = "application"
  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }
}

#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "public_alb_http_listener" {
  load_balancer_arn = aws_alb.public_alb.id
  port              = var.public_alb_http_listener_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      protocol = "HTTPS"
      port = "443"
    }
  }
}

resource "aws_alb_listener" "public_alb_https_listener" {
  load_balancer_arn = aws_alb.public_alb.id
  port              = var.public_alb_https_listener_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.prod_self_cert.arn
  #enable above 2 if you are using HTTPS listner and change protocal from HTTPS to HTTPS
  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_alb_target_group.prod_ecs_alb_targ.arn
      }
    }
  }
}

#############################Prod Environment#####################

resource "aws_alb_target_group" "prod_ecs_alb_targ" {
  name     = var.prod_ecs_alb_targ_name
  port     = var.prod_ecs_alb_targ_port
  protocol = "HTTP"
  deregistration_delay = 60
  vpc_id   = var.prod_ecs_alb_targ_vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = var.prod_ecs_alb_targ_health_check_path
    interval            = 30
  }
}