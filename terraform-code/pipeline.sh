#!/bin/bash
echo "Enter the public coding-game docker image url previously pushed:"
read DOCKER_IMAGE_URL

terraform init
# terraform apply -auto-approve -var="docker_image_url=$DOCKER_IMAGE_URL"
terraform plan -var="docker_image_url=$DOCKER_IMAGE_URL"
PUBLIC_URL = $(terraform output -raw public_url)
echo "The public url to test the app is: $PUBLIC_URL/api"