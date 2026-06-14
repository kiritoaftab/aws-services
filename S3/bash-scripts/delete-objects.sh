#!/usr/bin/env bash
echo "=== Deleting all objects in S3 bucket ===="
if [ -z "$1" ]; then
  echo "Usage: $0 <bucket-name>"
  exit 1
fi

BUCKET_NAME=$1
echo "Deleting all objects in S3 bucket: $BUCKET_NAME"
aws s3api list-objects \
--bucket $BUCKET_NAME \
--query 'Contents[].Key' \
| jq -n '{Objects: [inputs | .[] | {Key: .}]}' > /tmp/delete_objects.json

aws s3api delete-objects \
--bucket $BUCKET_NAME \
--delete file:///tmp/delete_objects.json