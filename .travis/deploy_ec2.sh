#!/bin/sh
cd ../terraform
terraform init $tf_init_cli_options
terraform apply $tf_init_cli_options