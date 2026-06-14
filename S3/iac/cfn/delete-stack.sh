#!/usr/bin/env bash
echo " Delete CFN Stack | CloudFormation Stack "

STACK_NAME="cfn-s3-bare"

aws cloudformation delete-stack \
--stack-name $STACK_NAME \
--region ap-south-1