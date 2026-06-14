#!/usr/bin/env bash
echo "=== GETTING NEWEST S3 BUCKET ===="
aws s3api list-buckets \
| jq '.Buckets | sort_by(.CreationDate) | reverse | .[0] | .Name'
