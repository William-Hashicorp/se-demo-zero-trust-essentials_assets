#!/bin/bash

#cd /root/terraform

TF_PUBLIC_API_HOST=$(terraform output -json target_ec2_attributes | jq -r .public_api.ip)

ssh -i ~/.ssh/private.key -o "StrictHostKeyChecking=false" ubuntu@$TF_PUBLIC_API_HOST sudo apt install -y ngrep

ssh -t -i ~/.ssh/private.key -o "StrictHostKeyChecking=false" ubuntu@$TF_PUBLIC_API_HOST sudo ngrep -q -d eth0 "" port 8081 or port 21000 or port 21001 or port 21002 or port 18081

#ssh -i ~/.ssh/private.key -o "StrictHostKeyChecking=false" ubuntu@$TF_PUBLIC_API_HOST sudo apt install -y nigrep
#ssh -t -i ~/.ssh/private.key -o "StrictHostKeyChecking=false" ubuntu@$TF_PUBLIC_API_HOST sudo ngrep -q -d eth0 "" port 8081
