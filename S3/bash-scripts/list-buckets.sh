#!/usr/bin/env bash
echo "=== LISTING S3 BUCKETS ===="
aws s3api list-buckets \
| jq '.Buckets | sort_by(.CreationDate) | reverse | .[] | .Name'
