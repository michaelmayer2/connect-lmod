#!/bin/bash

VPC_ID="vpc-1486376d"
POSIT_TAGS="{Key=rs:project,Value=solutions}, \
            {Key=rs:environment,Value=development}, \
            {Key=rs:owner,Value=michael.mayer@posit.co}"

AMI_ID="ami-05a40a9d755b0f73a" 

SUBNET_ID="subnet-9bbd91c1" 

aws iam create-policy --policy-name mmayer-docker.io --policy-document file://getsecret.json

aws iam create-role --role-name mmayer-EC2GetSecretRole --assume-role-policy-document file://trust.json

aws iam attach-role-policy --role-name mmayer-EC2GetSecretRole --policy-arn arn:aws:iam::637485797898:policy/mmayer-docker.io

aws iam create-instance-profile --instance-profile-name mmayer-EC2InstanceProfile
aws iam add-role-to-instance-profile --instance-profile-name mmayer-EC2InstanceProfile --role-name MyEC2Role


aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-initiated-shutdown-behavior terminate \
    --instance-type c5.4xlarge \
    --iam-instance-profile Name=mmayer-EC2InstanceProfile \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":100,\"DeleteOnTermination\":true}}]" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=rl9-posit-lmod},${POSIT_TAGS}]" 'ResourceType=volume,Tags=[{Key=Name,Value=rl9-posit-lmod-disk}]' \
    --user-data file://${PWD}/user-data.sh
