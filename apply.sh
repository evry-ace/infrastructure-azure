#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

CLUSTER="clusters/$1.tfvars"
CREDENTIALS="secrets/$1.secrets.tfvars"

# Check cluster name
if [ -z "$1" ]; then
  echo "No cluster name supplied"
  exit 1
fi

# Check cluster config file
if [ ! -f ${CLUSTER} ]; then
  echo "Clsuter config '${CLUSTER}' not found!"
  exit 1
fi

# Check cluster credential file
if [ ! -f ${CREDENTIALS} ]; then
  echo "Clsuter credentials '${CREDENTIALS}' not found!"
  exit 1
fi

# Init Terraform
terraform init

# Switch Terraform Workspace
terraform workspace select $1

# Apply Terraform Configuration
terraform apply -var-file ${CREDENTIALS} -var-file ${CLUSTER}
