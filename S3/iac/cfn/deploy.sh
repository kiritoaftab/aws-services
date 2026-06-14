#!/usr/bin/env bash
echo " ====== Deploy  S3 BUCKET via CFN | CloudFormation ====== "

# this variable must be unique within the AWS region and Account we are deploying it.
STACK_NAME="cfn-s3-bare"

aws cloudformation deploy \
--template-file template.yaml \
--stack-name $STACK_NAME \
--region ap-south-1 \
--no-execute-changeset