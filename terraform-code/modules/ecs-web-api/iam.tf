data "aws_iam_policy_document" "ecs_role_permissions"{
    version="2012-10-17"    
    statement {
      sid=""
      effect = "Allow"
      actions=["sts:AssumeRole"]

        principals{
            type="Service"
            identifiers=["ecs-tasks.amazonaws.com"]
        }
    }
}

###################### Task execution Role #####################
resource "aws_iam_role" "ecs_task_execution" {
  assume_role_policy = data.aws_iam_policy_document.ecs_role_permissions.json
  path = "/"
  name = var.ecs_task_execution_role_name
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_att_pol1" {
  role=aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

####################### Task ECS Role ##################

resource "aws_iam_role" "ecs_iam_role" {
    name=var.ecs_iam_role_name
    path = "/"

    assume_role_policy = data.aws_iam_policy_document.ecs_role_permissions.json 
}

resource "aws_iam_role_policy_attachment" "ecs_iam_role_att_pol_1" {
    role = aws_iam_role.ecs_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_iam_role_att_pol_2" {
    role = aws_iam_role.ecs_iam_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy_document" "ecs_instance_role_assume" {
    version="2012-10-17"    
    statement {
      sid=""
      effect = "Allow"
      actions=["sts:AssumeRole"]

        principals{
            type="Service"
            identifiers=["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "ecs_instance_role" {
    name = var.ecs_instance_role_name
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.ecs_instance_role_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_att_pol_1" {
    role = aws_iam_role.ecs_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_att_pol_2" {
    role = aws_iam_role.ecs_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}


resource "aws_iam_instance_profile" "ecs_instance_role_profile" {
  name = var.ecs_instance_role_profile_name
  role = aws_iam_role.ecs_instance_role.name
}

############################# Secrets Integration #####################
resource "aws_iam_policy" "ecs_role_secrets_manager" {
  name = var.ecs_role_secrets_manager_policy_name
  description = "Policy to allow ECS agent to retrieve secrets manager"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "secretsmanager:GetSecretValue"
              ],
          "Resource": [
            "${aws_secretsmanager_secret.prod_env.arn}"
          ]
      }
    ]
}
  POLICY
}

resource "aws_iam_role_policy_attachment" "ecs_role_secrets_manager" {
  role=aws_iam_role.ecs_iam_role.name
  policy_arn = aws_iam_policy.ecs_role_secrets_manager.arn
}