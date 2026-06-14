# AWS S3 — CLI Quick Reference

---

## Summary (Flashcards)

| # | Command / Concept | Quick Answer |
|---|-------------------|--------------|
| 1 | **`aws s3` vs `aws s3api`** | `s3` = high-level, simpler syntax. `s3api` = low-level, JSON output, finer control. |
| 2 | **Auto-prompt** | `AWS_CLI_AUTO_PROMPT=on-partial` — triggers autocomplete only when you use `?`. |
| 3 | **Copy object** | `aws s3 cp <src> <dest>` — works local→S3, S3→S3, or S3→local. |
| 4 | **Upload to subfolder** | `aws s3 cp file.txt s3://bucket/subdir/` — just add the prefix path. |
| 5 | **Sync (bulk upload/download)** | `aws s3 sync <src> <dest>` — mirrors entire folder structure both ways. |
| 6 | **Delete all objects** | `aws s3 rm s3://bucket/ --recursive` — must empty bucket before deleting it. |
| 7 | **Delete bucket** | `aws s3 rb s3://bucket` — fails if not empty. Add `--force` to nuke contents too. |
| 8 | **Create bucket (s3api)** | `aws s3api create-bucket --bucket <name> --region <region>` |
| 9 | **List buckets** | `aws s3api list-buckets` — returns JSON with name, date, ARN, owner. |
| 10 | **Filter bucket list** | Use `--query` with JMESPath — e.g. `Buckets[].Name` or filter by name substring. |
| 11 | **Download object (s3api)** | `aws s3api get-object --bucket <b> --key <k> <local-file>` |
| 12 | **Upload object (s3api)** | `aws s3api put-object --bucket <b> --key <k> --body <file> --content-type <type>` |

---

## Details

### Auto-Prompt

```bash
# Check if auto-prompt is set
env | grep -i auto
# AWS_CLI_AUTO_PROMPT=on-partial

# Set it permanently in your shell profile
export AWS_CLI_AUTO_PROMPT=on-partial
```

`on-partial` mode activates the interactive auto-completer only when you type `?` — it won't interrupt normal commands.

---

### `aws s3` vs `aws s3api`

| | `aws s3` | `aws s3api` |
|-|----------|-------------|
| Level | High-level | Low-level |
| Output | Human-readable | JSON (programmatic) |
| Control | Simpler, fewer flags | Finer-grained options |
| Use case | Day-to-day tasks | Scripting, automation |

---

### Copying Objects — `aws s3 cp`

```bash
# Local → S3
aws s3 cp quickNotes.md s3://sample-bucket-kirito/

# Local → S3 subfolder/prefix
aws s3 cp quickNotes.md s3://sample-bucket-kirito/images/

# S3 → S3
aws s3 cp s3://bucket-a/file.txt s3://bucket-b/file.txt

# S3 → Local
aws s3 cp s3://sample-bucket-kirito/file.txt ./file.txt
```

`<source>` and `<dest>` can be any combination of local path and S3 URI.

---

### Syncing — `aws s3 sync`

Mirrors a full directory structure. Only transfers new or changed files (unlike `cp` which always overwrites).

```bash
# Upload entire local folder to S3 (preserves subdirectory structure)
aws s3 sync images/ s3://sample-bucket-kirito-1/

# Download entire bucket to local folder
aws s3 sync s3://sample-bucket-kirito-1/ local-copy/
```

---

### Deleting Objects & Buckets

```bash
# Delete all objects in a bucket (recursive)
aws s3 rm s3://sample-bucket-kirito/ --recursive

# Delete an empty bucket
aws s3 rb s3://sample-bucket-kirito

# Delete bucket AND all its contents in one shot
aws s3 rb s3://sample-bucket-kirito --force
```

> You cannot delete a bucket until it is empty. `--force` on `rb` handles emptying + deletion together.

---

### Creating a Bucket — `aws s3api`

```bash
aws s3api create-bucket --bucket sample-bucket-kirito-1 --region us-east-1
```

```json
{
  "Location": "/sample-bucket-kirito-1",
  "BucketArn": "arn:aws:s3:::sample-bucket-kirito-1"
}
```

> For regions other than `us-east-1`, add `--create-bucket-configuration LocationConstraint=<region>`.

---

### Listing Buckets — `aws s3api`

```bash
# List all buckets (full JSON)
aws s3api list-buckets

# List only bucket names
aws s3api list-buckets --query "Buckets[].Name"

# Filter bucket names containing a keyword (JMESPath)
aws s3api list-buckets --query "Buckets[?contains(Name,'sample')].Name" --output text
```

`--query` uses [JMESPath](https://jmespath.org/) syntax for filtering/transforming JSON output.

---

### Downloading an Object — `aws s3api get-object`

```bash
aws s3api get-object \
  --bucket sample-bucket-kirito-1 \
  --key sample.txt \
  save.txt         # local filename to save as
```

Returns metadata on success:
```json
{
  "ContentLength": 45,
  "ContentType": "text/plain",
  "ServerSideEncryption": "AES256",
  "ETag": "\"61ecccf44f58605c9110f285c37dcdb6\""
}
```

---

### Uploading an Object — `aws s3api put-object`

```bash
aws s3api put-object \
  --bucket sample-bucket-kirito-1 \
  --key learn.txt \
  --body learn.txt \
  --content-type text/plain
```

```json
{
  "ETag": "\"609d166a24f8bcdc446900605c1a74ab\"",
  "ServerSideEncryption": "AES256"
}
```

> Use `put-object` when you need fine-grained control (metadata, content-type, encryption settings). For simple uploads, `aws s3 cp` is easier.

---

### Cheat Sheet — All Commands at a Glance

```bash
# --- aws s3 (high-level) ---
aws s3 cp <src> <dest>                          # copy (local↔S3, S3↔S3)
aws s3 sync <src> <dest>                        # sync folder structure
aws s3 rm s3://bucket/key                       # delete single object
aws s3 rm s3://bucket/ --recursive              # delete all objects
aws s3 rb s3://bucket                           # remove empty bucket
aws s3 rb s3://bucket --force                   # remove bucket + contents
aws s3 ls                                       # list all buckets
aws s3 ls s3://bucket/                          # list objects in bucket

# --- aws s3api (low-level, JSON) ---
aws s3api create-bucket --bucket <name> --region <region>
aws s3api list-buckets
aws s3api list-buckets --query "Buckets[].Name"
aws s3api put-object --bucket <b> --key <k> --body <file> --content-type <type>
aws s3api get-object --bucket <b> --key <k> <local-output-file>
aws s3api delete-object --bucket <b> --key <k>
aws s3api head-object --bucket <b> --key <k>   # get metadata without downloading
```
