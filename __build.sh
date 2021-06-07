#!/bin/bash

source __variables.sh;

# set -ex

echo "Creating ECR Repository through Terraform"
(cd 00__build ; terraform init ; terraform apply -var application=$APPLICATION_NAME --auto-approve)

# We need to build image to push to ECR
echo "building image as: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$APPLICATION_NAME:$TAG $APPLICATION_NAME ."
docker build -t "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$APPLICATION_NAME:$TAG" .

# We need to push this image to ECR
# Here let's suppose we're pushing some change from development team
echo "pushing image: $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$APPLICATION_NAME:$TAG"
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$APPLICATION_NAME:$TAG