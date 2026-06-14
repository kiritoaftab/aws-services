#!/usr/bin/env bash 

echo "=== SYNCING OBJECTS IN S3 BUCKET ===="

if [ -z "$1" ]; then
    echo "Usage: $0 <bucket-name>"
    exit 1
fi

BUCKET_NAME=$1
echo "Uploading files to S3 bucket: $BUCKET_NAME"

OUTPUT_DIR="/tmp/random-files"
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

NUM_FILES=$((RANDOM % 5 + 1)) 

for ((i=1; i<=NUM_FILES; i++)); do
    FILE_NAME="file_${i}__$RANDOM.txt"

    # Random size between 1KB and 100KB
    SIZE_KB=$((RANDOM % 100 + 1))

    # Generate random alphanumeric data
    head -c $((SIZE_KB * 1024)) /dev/urandom | base64 > "$OUTPUT_DIR/$FILE_NAME"

    echo "Created $FILE_NAME (${SIZE_KB}KB)"
done


aws s3 sync $OUTPUT_DIR s3://$BUCKET_NAME/files