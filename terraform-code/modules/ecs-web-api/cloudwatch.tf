############################################ Prod ###############################################
resource "aws_cloudwatch_log_group" "prod_ecs_log_group" {
  name = var.prod_ecs_log_group_name
  tags = var.prod_ecs_log_group_tags

}

resource "aws_cloudwatch_log_stream" "prod_ecs_log_stream" {
  name           = var.prod_ecs_log_stream_name
  log_group_name = aws_cloudwatch_log_group.prod_ecs_log_group.name
}