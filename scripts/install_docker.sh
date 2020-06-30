#!/bin/bash
#dont forget 'chmod 700 install_docker.sh'
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker admin #optional, defualt user for aws debian image is admin

#pull and run container from docker hub.
sudo docker run -tid --name=ir ewwood/aws_ir_docker
