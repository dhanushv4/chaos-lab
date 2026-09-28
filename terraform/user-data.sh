#!/bin/bash

yum update -y
yum install -y docker git

systemctl start docker
systemctl enable docker

usermod -aG docker ec2-user

# install docker-compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# clone project
cd /home/ec2-user
git clone https://github.com/YOUR_REPO/ec2-chaos-project.git

cd ec2-chaos-project

docker-compose up -d
