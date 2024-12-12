#!/bin/bash

sudo yum install awscli

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker

#sudo docker compose build . 

username=`aws secretsmanager get-secret-value --secret-id michael.mayer-docker-io --query 'SecretString' --output text | jq  -r .username`
password=`aws secretsmanager get-secret-value --secret-id michael.mayer-docker-io --query 'SecretString' --output text | jq  -r .password`

sudo docker login -u $username -p "$password"

sudo docker push mmayer123/posit-lmod 
