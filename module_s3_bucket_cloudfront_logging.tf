module "bucket_cloudwatch_logs_backup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~>3.0"

  bucket        = local.logging_bucket_name
  force_destroy = false
  tags          = var.common_tags
  acl           = "private"

  # Bucket public access
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true

  versioning = {
    status     = var.s3_logging_versioning
    mfa_delete = "Disabled"
  }

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  cors_rule = var.cors_rules

}
