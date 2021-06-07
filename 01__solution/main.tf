terraform {
  required_version = ">= 0.12.0"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}

resource "aws_iam_role" "ec2_role_challenge" {
  name = "ec2_role_challenge"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ec2_profile_challenge" {
  name = "ec2_profile_challenge"
  role = aws_iam_role.ec2_role_challenge.name
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role_challenge.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_key_pair" "generated_key" {
  key_name   = "deploy"
  public_key = file("keys/id_rsa.pub")
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name

  root_block_device {
    volume_size = 8
  }

  vpc_security_group_ids = [
    module.ec2_sg.this_security_group_id,
    module.dev_ssh_sg.this_security_group_id
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_challenge.name

  tags = {
    Name = var.application
    Tag = var.tag
  }

  connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.web.public_ip
      private_key = file("keys/id_rsa")
      agent       = false
      timeout     = "2m"
  }

  # Remote provisioner on the instance after creating it.
  provisioner "file" {  
    source      = "./scripts/"
    destination = "/tmp/"
  }
  provisioner "remote-exec" {
    inline = [
      "sh /tmp/install_tools.sh",
      "sh /tmp/run_application.sh ${var.account_id} ${var.region} ${var.application} ${var.tag}"
    ]
  }
}