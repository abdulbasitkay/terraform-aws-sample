#!/bin/bash
touch /home/ec2-user/fs.txt
sudo yum -y update
echo "=============install docker============="
sudo yum -y install docker
sudo usermod -aG docker $USER
echo "=============download docker-compose============="
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
echo "=============install docker-compose============="
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo docker-compose --version
echo "=============git clone============="
git clone https://github.com/abdulbasitkay/terraform-aws-sample.git
cd terraform-aws-sample
echo "=============docker-compose up============="
sudo docker-compose up -d