#!/bin/bash

account_id=$1
region=$2
application=$3
tag=$4

aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $account_id.dkr.ecr.$region.amazonaws.com
docker run --rm -dti --name challenge -p 80:3000 $account_id.dkr.ecr.$region.amazonaws.com/$application:$tag
