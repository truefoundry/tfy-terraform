resource "aws_s3_bucket" "svcfoundry_bucket" {
  bucket_prefix = local.svcfoundry_unique_name
  force_destroy = var.svcfoundry_s3_force_destroy

  tags = merge(
    {
      Name = local.svcfoundry_unique_name
    },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "svcfoundry_bucket" {
  bucket = aws_s3_bucket.svcfoundry_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "svcfoundry_bucket" {
  bucket = aws_s3_bucket.svcfoundry_bucket.id

  rule {
    id     = "history"
    status = "Enabled"
    transition {
      days          = 60
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

resource "aws_s3_bucket_versioning" "svcfoundry_bucket" {
  bucket = aws_s3_bucket.svcfoundry_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "svcfoundry_bucket" {
  bucket = aws_s3_bucket.svcfoundry_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.svcfoundry_s3_encryption_key_arn
      sse_algorithm     = var.svcfoundry_s3_encryption_algorithm
    }
  }
}

resource "aws_s3_bucket_public_access_block" "svcfoundry_bucket" {
  bucket = aws_s3_bucket.svcfoundry_bucket.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  # Block new public bucket policies
  block_public_policy = true

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true

}

resource "aws_s3_bucket_policy" "svcfoundry_bucket" {
  bucket = aws_s3_bucket.svcfoundry_bucket.id
  policy = data.aws_iam_policy_document.svcfoundry_bucket_tls_only.json
}

data "aws_iam_policy_document" "svcfoundry_bucket_tls_only" {
  statement {
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "*"
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.svcfoundry_bucket.arn}/*",
      aws_s3_bucket.svcfoundry_bucket.arn,
    ]
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }
}

resource "aws_iam_policy" "svcfoundry_bucket_policy" {
  name_prefix = "${local.svcfoundry_unique_name}-access-to-bucket"
  description = "svcfoundry bucket policy"
  policy      = data.aws_iam_policy_document.svcfoundry_bucket_policy.json
  tags        = local.tags
}

data "aws_iam_policy_document" "svcfoundry_bucket_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:HeadBucket",
    ]
    resources = concat(
      aws_s3_bucket.svcfoundry_bucket.*.arn,
      var.svcfoundry_artifact_buckets_will_read,
    )
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketTagging",
      "s3:GetObjectVersionTagging",
      "s3:ReplicateTags",
      "s3:PutObjectVersionTagging",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:PutBucketTagging",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging",
      "s3:GetObjectVersion",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:DeleteObjectVersionTagging",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
    ]
    resources = [
      for bucket in concat(aws_s3_bucket.svcfoundry_bucket.*.arn, var.svcfoundry_artifact_buckets_will_read) :
      "${bucket}/*"
    ]
  }
}
