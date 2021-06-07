# Bootstrap from scratch: Website Deployment

## Considerations
1. To execute the user have to at least `awscli version 2` installed
2. To configure awscli with user has access to interact to aws
3. Docker installed
4. Update `__variables.sh` with **AWS_ACCOUNT_ID** , **reAWS_DEFAULT_REGION**, **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**
5. All things has been created from scratch using VPC Default, this will work ONLY in VPC Default.

## Techs
1. First Solution is spinning up an EC2 instance and installing Docker and AWSCLI internally, after that running image from AWS ECR
2. Second Solution is creating an ECS and Fargate using AWS ECR.

## Create application

File's descriptions:
`__variables.sh` this script is used to setup variables needed to deploy to AWS

`__build.sh` this script is reponsible for building the Docker Image and push to AWS ECR.

* This is must be executed firstly before running proposed solutions.
* Change `variables.sh` to run from your own AWS account.
* I put some values as **BRANCH** and **COMMIT_SHA** to simulate a development change. (CI/CD) 

`__run.sh` this script is reponsible for calling functions related to proposed solutions.
In this case, internally we have a **switch case** to determine which solution will be executed.

we can do the following commands using : `__run.sh`
- First Solution:
  - `sh __run.sh solution1 apply`
  - `sh __run.sh solution1 destroy`
  - `sh __run.sh solution1 output`
  - `sh __run.sh solution1 plan`

- Second Solution:
  - `sh __run.sh solution2 apply`
  - `sh __run.sh solution2 destroy`
  - `sh __run.sh solution2 output`
  - `sh __run.sh solution2 plan`

After applying the script to deploy a solution you'll receive at the end an output containing the DNS to access the application.
Both solutions are reachable from all over the world

## Access programatically

Restrict access to the site can be adapted programmatically by changing for example the security groups.
One example of that:
- On file `sg.tf` I added access through SSH by Internet and an specific CIDR Block, this is a way to allow and deny access
- On file `alb.tf` Using ALB we can create routes by specific URI and forward to some target group.


Both types of deployment can be reproduced and both using Terraform.

## Example

`sh __build.sh`
`sh __run.sh solution1 apply`
`sh __run.sh solution2 apply`
Notes: In case of failure try to apply again the commands. It would be happen in some spin up, update some packages or even timeout.


Take the DNS output to test:
`sh __run.sh solution1 output`
`sh __run.sh solution2 output`