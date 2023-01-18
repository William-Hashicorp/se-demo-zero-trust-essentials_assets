#!/bin/bash

# cd /root/terraform

TF_PRODUCT_API_HOST=$(terraform output -json target_ec2_attributes | jq -r .product_api.ip)

while true; do
  DB_CONFIG=$(ssh -i ~/.ssh/private.key -o "StrictHostKeyChecking=false" ubuntu@$TF_PRODUCT_API_HOST cat /opt/hashicups/product-api-go/conf.json)
  clear
  echo "$DB_CONFIG"
  sleep 5
done
