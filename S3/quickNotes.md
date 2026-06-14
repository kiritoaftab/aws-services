# AWS S3 — Quick Notes (GUI/Console)

---

## Summary (Flashcards)

| # | Key Concept | Quick Answer |
|---|-------------|--------------|
| 1 | **S3 Bucket** | The top-level container that holds objects. Think of it as a folder. |
| 2 | **S3 Object** | Any file stored inside a bucket — images, emails, videos, JSON, etc. |
| 3 | **Bucket Types** | General Purpose (classic) or Directory (new, higher performance). |
| 4 | **Region** | Auto-detected from the top nav; can't freely change it during bucket creation now. |
| 5 | **Namespace** | Global (unique across all AWS) or Account-Regional (prefix + account ID + region). |
| 6 | **ACL** | Access Control List — controls who can access the bucket/objects. Disabled by default. |
| 7 | **Public Access** | Blocked for all public access by default — must explicitly open it up. |
| 8 | **Versioning** | Keeps multiple variants of the same object; useful for rollback and audit. |
| 9 | **Encryption (Default)** | SSE-S3 — Server-Side Encryption managed by Amazon S3. |
| 10 | **Other Encryptions** | SSE-KMS (Key Management Service) and DSSE-KMS (Dual-Layer SSE). |
| 11 | **Bucket Keys** | Used with SSE-KMS to reduce KMS API call costs. |
| 12 | **Storage Classes** | Can be set per-object at upload time (Standard, Standard-IA, Intelligent-Tiering, etc.). |

---

## Details

### Core Concepts

S3 has two main building blocks:

- **S3 Bucket** — the large container (like a top-level folder) that holds everything.
- **S3 Object** — any file stored inside a bucket. It can be any file type: image, email, video, binary, JSON, etc.

---

### Creating a Bucket — Key Configuration Options

#### 1. Bucket Type *(newly added option)*
- **General Purpose** — the classic, widely-used bucket type.
- **Directory** — new type optimized for high-performance, low-latency workloads.

#### 2. AWS Region
- Previously you could freely pick a region; now the console auto-detects it from the **top navigation tab** selection.

#### 3. Bucket Name / Namespace
Two namespace options:
- **Global namespace** — bucket name must be unique across all of AWS worldwide.
- **Account-Regional namespace** — a prefix is auto-appended using your **Account ID + Region**, so the name only needs to be unique within your account in that region.
  - Example suffix: `--<account-id>--<region>--x-s3`

#### 4. ACL (Access Control List)
- Lets you grant access to other AWS accounts or predefined groups at the bucket or object level.
- **Disabled by default** — the recommended modern approach is to use bucket policies instead.

#### 5. Public Access
- All public access is **blocked by default**.
- You must explicitly uncheck the block to allow any public access (e.g., hosting a static website).

#### 6. Versioning
- Enables keeping **multiple versions** of the same object in the same bucket.
- Useful for accidental deletion recovery and audit history.
- Disabled by default; can be enabled per bucket.

#### 7. Tags
- Key-value labels you can attach to a bucket for cost allocation, organization, and access control.

#### 8. Encryption
Encryption is applied **server-side by default**. Three options:

| Encryption Type | Full Name | Notes |
|-----------------|-----------|-------|
| **SSE-S3** | Server-Side Encryption with Amazon S3 Managed Keys | Default. AWS manages the keys entirely. |
| **SSE-KMS** | Server-Side Encryption with AWS Key Management Service | You control/audit the keys via KMS. |
| **DSSE-KMS** | Dual-Layer Server-Side Encryption with KMS | Two independent layers of AES-256 encryption. |

- **Bucket Keys** — an optimization available with SSE-KMS that generates a short-lived key at the bucket level, reducing calls to KMS and lowering cost.

---

### Uploading Objects

- In the console, click **Upload** inside a bucket and select your files.
- **Storage Class** can be set per object at upload time — you don't have to use the same class for everything in a bucket.

#### Storage Classes (choose based on access frequency & cost)

| Class | Best For |
|-------|----------|
| **S3 Standard** | Frequently accessed data, low latency |
| **S3 Standard-IA** | Infrequently accessed, but needs fast retrieval |
| **S3 Intelligent-Tiering** | Unknown or changing access patterns — auto-moves objects between tiers |
| **S3 One Zone-IA** | Infrequent access, non-critical data (single AZ only) |
| **S3 Glacier Instant Retrieval** | Archive data needing millisecond retrieval |
| **S3 Glacier Flexible Retrieval** | Archive data, retrieval in minutes to hours |
| **S3 Glacier Deep Archive** | Longest-term storage, cheapest, retrieval in hours |
| **S3 Express One Zone** | Highest performance, single Availability Zone (Directory bucket type) |

Storage classes are easy to change after upload via the console — just select the object and modify its properties.
