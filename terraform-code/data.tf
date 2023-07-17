data "aws_ami" "aws_ami_ecs_64" {
  most_recent = true
  filter {
    name = "name"
    values = [ "amzn2-ami-ecs-hvm-2.*-x86_64-ebs" ]
  }
}