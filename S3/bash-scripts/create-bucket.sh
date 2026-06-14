#!/usr/bin/env bash
echo " ====== CREATING S3 BUCKET ====== "
if [ -z "$1" ]; then
  echo "Usage: $0 <bucket-name>"
  exit 1
fi

BUCKET_NAME=$1
echo "Creating S3 bucket: $BUCKET_NAME"
# region apart from us-east-1 requires LocationConstraint
aws s3api create-bucket \
--bucket $BUCKET_NAME \
--region $AWS_DEFAULT_REGION \
--create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION \
--query Location \
--output text