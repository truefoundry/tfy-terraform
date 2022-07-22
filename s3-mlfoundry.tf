resource "aws_s3_bucket" "mlfoundry_bucket" {
  bucket = var.mlfoundry_s3_enable_override ? var.mlfoundry_s3_override_name : null
  bucket_prefix = var.mlfoundry_s3_enable_override ? null : local.mlfoundry_unique_name

  force_destroy = var.mlfoundry_s3_force_destroy

  tags = merge(
    {
      Name = var.mlfoundry_s3_enable_override ? var.mlfoundry_s3_override_name : local.mlfoundry_unique_name
    },
    local.tags
  )
}

resource "aws_s3_bucket_acl" "mlfoundry_bucket" {
  bucket = aws_s3_bucket.mlfoundry_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "mlfoundry_bucket" {
  bucket = aws_s3_bucket.mlfoundry_bucket.id

  rule {
    id     = "history"
    status = "Enabled"
    transition {
      days          = 60
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

resource "aws_s3_bucket_versioning" "mlfoundry_bucket" {
  bucket = aws_s3_bucket.mlfoundry_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mlfoundry_bucket" {
  bucket = aws_s3_bucket.mlfoundry_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.mlfoundry_s3_encryption_key_arn
      sse_algorithm     = var.mlfoundry_s3_encryption_algorithm
    }
  }
}

resource "aws_s3_bucket_public_access_block" "mlfoundry_bucket" {
  bucket = aws_s3_bucket.mlfoundry_bucket.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  # Block new public bucket policies
  block_public_policy = true

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true

}

resource "aws_s3_bucket_cors_configuration" "mlfoundry_bucket" {
  bucket = aws_s3_bucket.mlfoundry_bucket.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = var.mlfoundry_s3_cors_origins
  }
}


resource "aws_s3_bucket_policy" "mlfoundry_bucket" {
  bucket = aws_s3_bucket.mlfoundry_bucket.id
  policy = data.aws_iam_policy_document.mlfoundry_bucket_tls_only.json
}

data "aws_iam_policy_document" "mlfoundry_bucket_tls_only" {
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
      "${aws_s3_bucket.mlfoundry_bucket.arn}/*",
      aws_s3_bucket.mlfoundry_bucket.arn,
    ]
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
  }
}


resource "aws_iam_policy" "mlfoundry_bucket_policy" {
  name_prefix = "${local.mlfoundry_unique_name}-access-to-bucket"
  description = "mlfoundry bucket policy for"
  policy      = data.aws_iam_policy_document.mlfoundry_bucket_policy.json
  tags        = local.tags
}

data "aws_iam_policy_document" "mlfoundry_bucket_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:HeadBucket",
    ]
    resources = concat(
      aws_s3_bucket.mlfoundry_bucket.*.arn,
      var.mlfoundry_artifact_buckets_will_read,
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
      "s3:GetObject",
      "s3:AbortMultipartUpload",
      "s3:PutBucketTagging",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging",
      "s3:GetObjectVersion",
      "s3:ListBucket",
    ]
    resources = [
      for bucket in concat(aws_s3_bucket.mlfoundry_bucket.*.arn, var.mlfoundry_artifact_buckets_will_read) :
      "${bucket}/*"
    ]
  }
}