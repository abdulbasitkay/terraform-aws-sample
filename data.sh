#!/usr/bin/env bash

sudo yum -y update
sudo yum -y install docker
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo docker-compose --version
git clone https://github.com/abdulbasitkay/terraform-aws-sample.git
cd terraform-aws-sample
sudo docker-compose up -d