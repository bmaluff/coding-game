#!/bin/bash
echo "Enter the public coding-game docker image url previously pushed: "
read DOCKER_IMAGE_URL
echo "Ingrese el nombre de la BD: "
read  DB_NAME
echo "Ingrese el usuario para acceder a la BD: "
read  DB_USER

echo "Inicializando Terraform"
terraform init
echo "Provisionando Capa de Red y Base de Datos"
# terraform apply -auto-approve -target=module.data_layer -target=module.ecs_web_api.aws_route53_record.prod_db_dns_record -target=module.ecs_web_api.aws_route53_zone.prod_private_zone -var="docker_image_url=$DOCKER_IMAGE_URL" -var="db_instance_name=$DB_NAME" -var="db_username=$DB_USER"
terraform plan -target=module.data_layer -target=module.ecs_web_api.aws_route53_record.prod_db_dns_record -target=module.ecs_web_api.aws_route53_zone.prod_private_zone -var="docker_image_url=$DOCKER_IMAGE_URL" -var="db_instance_name=$DB_NAME" -var="db_username=$DB_USER"

DB_HOST=$(terraform output -raw db_host_shorten)
DB_PORT=$(terraform output -raw db_port)

DB_PASS=$(aws secretsmanager get-secret-value --secret-id $(terraform output -raw secrets_arn) --region us-east-1 --profile personal | jq '.SecretString' | jq fromjson | jq -r .password)
ENV_FILE="./modules/ecs-web-api/files/prod_env.json"
sed -i "s/CHANGE_USER/$DB_USER/" $ENV_FILE
sed -i  "s/CHANGE_PASS/$DB_PASS/" $ENV_FILE
sed -i  "s/CHANGE_HOST/$DB_HOST/" $ENV_FILE
sed -i  "s/CHANGE_DB_NAME/$DB_NAME/" $ENV_FILE
echo "Provisionando Capa de Aplicacion"
terraform plan -var="docker_image_url=$DOCKER_IMAGE_URL" -var="db_instance_name=$DB_NAME" -var="db_username=$DB_USER"
# terraform apply -auto-approve -var="docker_image_url=$DOCKER_IMAGE_URL" -var="db_instance_name=$DB_NAME" -var="db_username=$DB_USER"

PUBLIC_URL=$(terraform output -raw public_url)
echo "The public url to test the app is: $PUBLIC_URL/api"