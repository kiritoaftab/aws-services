#!/usr/bin/env bash
echo "=== LIST OBJECTS IN S3 BUCKET ===="
if [ -z "$1" ]; then
  echo "Usage: $0 <bucket-name>"
  exit 1
fi

BUCKET_NAME=$1
echo "Listing objects in S3 bucket: $BUCKET_NAME"
# region apart from us-east-1 requires LocationConstraint
aws s3api list-objects \
--bucket $BUCKET_NAME \
--query 'Contents[].Key'