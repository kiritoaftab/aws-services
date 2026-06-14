#!/usr/bin/env bash
echo "=== DELETING S3 BUCKET ===="
if [ -z "$1" ]; then
  echo "Usage: $0 <bucket-name>"
  exit 1
fi

BUCKET_NAME=$1
echo "Deleting S3 bucket: $BUCKET_NAME"
aws s3api delete-bucket --bucket $BUCKET_NAME 