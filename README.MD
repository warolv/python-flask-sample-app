## CI/CD using travis ci and terraform and example application written in Python/Flask

# Objective

 Create a CI/CD with Travis CI that starts from cloning and testing python/flask application, and finishes with provisioning infrastructure with terraform, deploying and running it on the provisioned instance.

 Original flask app you can find: https://github.com/codefresh-contrib/python-flask-sample-app

## Task Requirements for the first part - create docker container

1. Create a CI/CD pipeline in TravisCI

2. Clone https://github.com/codefresh-contrib/python-flask-sample-app

3. Run unit tests

4. Build docker container and push it to dockerhub


## Task Requirements for the second part - deploy docker to AWS EC2 instance with terraform

1. Create a terraform script to provision EC2 instance

4. Run created docker container on provisioned instance

## Prerequisites

1. Create account on Travis CI, is just a matter of visiting https://travis-ci.org and logging in with your GitHub credentials.

2. Enabling Travis CI - to start a build at each Push and Pull Request for your repository is as easy as flipping the switch in front of your GitHub python-flask-app repository (click the ‘Sync account’ button in case your repository is not yet visible).

3. Add credentials for DockerHub and AWS's IAM user's credentials for terraform:

## First part

1. Create a .travis.yaml in root of your repository

```
sudo: required

services:
  - docker

language: python

script:
  - python -m pytest -v

after_success:
  - sh .travis/deploy_dockerhub.sh

```

Travis CI will run UT and then if everything ok will use deploy_dockerhub.sh bash script to push container to docker hub

## Second part

1. For second part I created directory tf with all needed scripts to provision EC2 instance and run created container on this instance

2. Downloaded terraform for Travis CI

```
env:
  - tf_version=0.12.19 tf_init_cli_options="-input=false" tf_validation_cli_options="" tf_plan_cli_options="-lock=false -input=false" tf_apply_cli_options="-auto-approve -input=false"

before_install:
  - wget https://releases.hashicorp.com/terraform/"$tf_version"/terraform_"$tf_version"_linux_amd64.zip
  - sudo unzip -o terraform_"$tf_version"_linux_amd64.zip
  - sudo mv -f terraform /usr/local/bin/
  - rm terraform_"$tf_version"_linux_amd64.zip

```

3. Created .travis/deploy_ec2.sh script which will be executed after success and docker container pushed to dockerhub

```
after_success:
  - sh .travis/deploy_ec2.sh

```

4. To connect to newly provisioned EC2 instance I am generating ssh key and adding this key as a terraform resource "aws_key_pair" 

5. Connect using SSH to provisioned instance using generated ssh-key and terraform 'provisioners' then download docker for this instance and execute 'docker run' with last created image
