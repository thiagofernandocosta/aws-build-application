#!/bin/bash

echo "installing docker"
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker ubuntu
sudo chmod 666 /var/run/docker.sock

echo "installing awscli"
sudo apt install awscli -y