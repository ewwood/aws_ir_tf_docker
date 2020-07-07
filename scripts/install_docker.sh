#!/bin/bash
#dont forget 'chmod 700 install_docker.sh'
touch start
yum update
yum install -y docker
usermod -aG docker ec2-user #optional, defualt user for aws debian image is admin
yum update
service docker start

#pull and run container from docker hub.
docker run -tid --name=ir ewwood/aws_ir_docker
touch stop
