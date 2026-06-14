#!/usr/bin/env bash 

echo "=== PUTTING OBJECTS IN S3 BUCKET ===="

if [ -z "$1" ]; then
    echo "Usage: $0 <bucket-name> <filepath>"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Usage: $0 <bucket-name> <filepath>"
    exit 1
fi

if [ ! -f "$2" ]; then
    echo "File $2 does not exist."
    exit 1
fi

BUCKET_NAME=$1
FILEPATH=$2
echo "Uploading file to S3 bucket: $BUCKET_NAME from path: $FILEPATH"
aws s3api put-object \
    --bucket $BUCKET_NAME \
    --key "$(basename $FILEPATH)" \
    --body "$FILEPATH"

