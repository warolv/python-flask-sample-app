#!/bin/sh

ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/ec2_deploy_key -q -N ""

export TF_VAR_public_deploy_key=$HOME/.ssh/ec2_deploy_key.pub
export TF_VAR_private_deploy_key=$HOME/.ssh/ec2_deploy_key

cd tf
terraform init $tf_init_cli_options
terraform apply $tf_apply_cli_options