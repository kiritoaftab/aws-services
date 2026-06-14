# Terraform Notes

## Summary

Terraform is an open-source **Infrastructure as Code (IaC)** tool by HashiCorp that lets you define, provision, and manage cloud resources using declarative configuration files (`.tf`). It supports AWS, GCP, Azure, and 1000+ providers. The core workflow is: **Write → Init → Plan → Apply → Destroy**.

Key files in any Terraform project:
- `main.tf` — provider config and root module entry point
- `*.tf` files — resource definitions (e.g., `s3.tf`, `vpc.tf`)
- `.terraform.lock.hcl` — dependency lock file (commit this)
- `terraform.tfstate` — current state of managed infrastructure (never edit manually)

---

## Core Concepts

### Providers
Providers are plugins that let Terraform talk to cloud APIs. You declare them in `main.tf` and grab them from the [Terraform Registry](https://registry.terraform.io).

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # Credentials are picked up from env vars:
  # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN
}
```

### Resources
Resources are the actual infrastructure objects you manage.

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"

  tags = {
    Environment = "dev"
    Project     = "aws-services"
  }
}
```

### Variables
Variables make configurations reusable and avoid hardcoding values.

```hcl
variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  default     = "my-default-bucket"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}
```

Pass values via `terraform.tfvars`, CLI flags (`-var`), or environment variables (`TF_VAR_bucket_name`).

### Outputs
Outputs expose resource attributes after apply — useful for chaining modules or viewing IDs.

```hcl
output "bucket_arn" {
  value = aws_s3_bucket.my_bucket.arn
}
```

### Data Sources
Read existing infrastructure that Terraform didn't create (e.g., look up an existing VPC).

```hcl
data "aws_vpc" "default" {
  default = true
}
```

---

## Core Workflow Commands

| Command | Purpose |
|---|---|
| `terraform init` | Downloads providers and sets up the working directory. Run first, and after any provider change. |
| `terraform validate` | Checks config syntax without contacting the cloud. |
| `terraform fmt` | Auto-formats `.tf` files to canonical style. |
| `terraform plan` | Shows what will be created/changed/destroyed. No changes are made. |
| `terraform apply` | Executes the plan. Prompts for `yes` confirmation. |
| `terraform apply -auto-approve` | Applies without the confirmation prompt (use carefully). |
| `terraform destroy` | Destroys all managed resources. Prompts for `yes`. |
| `terraform output` | Prints output values from the last apply. |
| `terraform state list` | Lists all resources tracked in state. |
| `terraform show` | Human-readable view of the current state. |

---

## State

Terraform tracks what it has created in a **state file** (`terraform.tfstate`). This is how it knows what exists vs. what needs to be added/changed/removed.

- **Local state** (default): stored in `terraform.tfstate` in your working directory.
- **Remote state** (recommended for teams): store in S3 + DynamoDB for locking.

```hcl
# backend.tf — remote state in S3
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

---

## Modules

Modules are reusable groups of resources. The root module is your working directory. Child modules are called with the `module` block.

```hcl
module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = "my-app-bucket"
}
```

Public modules are available on the Terraform Registry (e.g., `terraform-aws-modules/s3-bucket/aws`).

---

## S3 Bucket Example (as practiced)

```hcl
# s3.tf
resource "aws_s3_bucket" "example" {
  bucket = "my-practice-bucket-aftab"
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

---

## Terraform vs CloudFormation

| | Terraform | CloudFormation |
|---|---|---|
| Language | HCL (HashiCorp Config Language) | JSON / YAML |
| Multi-cloud | Yes | AWS only |
| State management | Explicit (tfstate file) | Managed by AWS |
| Drift detection | `terraform plan` | CloudFormation drift detection |
| Ecosystem | Huge (public registry) | AWS-native |

---

## Tips & Best Practices

- Always run `terraform plan` before `terraform apply` — review the diff carefully.
- Store state remotely (S3 + DynamoDB) for any shared or production work.
- Use `.gitignore` to exclude `terraform.tfstate`, `terraform.tfstate.backup`, and `.terraform/` directory.
- Pin provider versions with `~> x.y` to avoid unexpected breaking changes.
- Use `terraform fmt` and `terraform validate` in CI to catch issues early.
- Tag every resource — makes cost attribution and cleanup much easier.
- Use workspaces (`terraform workspace`) to manage multiple environments (dev/staging/prod) with one config.
