# AWS CloudFormation (CFN) — IaC Notes

---

## Flashcards

**Q: What is AWS CloudFormation?**
A: AWS's native IaC service. You define infrastructure in YAML/JSON templates and CFN provisions and manages it.

**Q: CFN vs Terraform — key difference?**
A: CFN is AWS-only (native, deep integration). Terraform is multi-cloud (AWS, GCP, Azure, etc.) using its own HCL language.

**Q: What file format does CFN use?**
A: YAML (`.yaml`, not `.yml`) or JSON. The YAML version is preferred. File must start with `AWSTemplateFormatVersion`.

**Q: What is the AWSTemplateFormatVersion value?**
A: Always `2010-09-09` — it has never been updated since its release.

**Q: What does `--no-execute-changeset` do in `aws cloudformation deploy`?**
A: Creates a changeset (a preview of what CFN will do) but does NOT execute it. You review it in the AWS Console and manually execute it from there.

**Q: What happens when you delete a CFN stack?**
A: By default, it also deletes ALL resources the stack created (e.g., the S3 bucket gets deleted too).

**Q: How do you prevent resource deletion when a stack is deleted?**
A: Add `DeletionPolicy: Retain` to the resource in the template. The stack deletes but the resource stays.

**Q: Where is the CFN S3 resource reference docs?**
A: https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-s3-bucket.html

---

## Details

### CFN vs Terraform

| Feature            | CloudFormation (CFN)         | Terraform                        |
|--------------------|------------------------------|----------------------------------|
| Provider           | AWS only                     | Multi-cloud (AWS, GCP, Azure...) |
| Language           | YAML / JSON                  | HCL (HashiCorp Config Language)  |
| State management   | AWS manages state internally | You manage `.tfstate` file       |
| Native integration | Deep — first-class AWS       | Good but not always day-0        |
| Changesets         | Built-in                     | `terraform plan`                 |

CFN is similar in *concept* to Terraform (declare desired state, tool figures out how to get there), but CFN only lives inside the AWS ecosystem.

---

### CFN Template Structure

```yaml
AWSTemplateFormatVersion: 2010-09-09   # required, always this value
Description: "Human readable description"
Resources:                             # required section
  LogicalResourceName:
    Type: "AWS::S3::Bucket"            # resource type
    # DeletionPolicy: Retain           # optional — keeps resource if stack is deleted
    # Properties:
    #   BucketName: my-bucket-name     # if omitted, CFN generates a unique name
```

- `Resources` is the only required section in a CFN template.
- If `BucketName` is not provided under `Properties`, CFN auto-generates a unique name.

---

### deploy.sh — `--no-execute-changeset`

```bash
aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name cfn-s3-bare \
  --region ap-south-1 \
  --no-execute-changeset
```

- `--no-execute-changeset`: CFN creates a **changeset** (a diff of what will be created/modified/deleted) but stops there.
- You go to the AWS Console → CloudFormation → your stack → Changesets, review the events, then manually execute.
- Useful for reviewing changes before they hit your account, especially in production.

---

### delete-stack.sh — Stack Deletion Cascades to Resources

```bash
aws cloudformation delete-stack \
  --stack-name cfn-s3-bare \
  --region ap-south-1
```

**Key caveat:** Deleting a stack deletes everything the stack created.
- Verified: deleted the `cfn-s3-bare` stack → the S3 bucket was also deleted.
- To keep a resource after stack deletion, add `DeletionPolicy: Retain` to that resource in the template.

---

### Stack Name Uniqueness

The stack name (`cfn-s3-bare`) must be unique within the AWS region + account combination.
