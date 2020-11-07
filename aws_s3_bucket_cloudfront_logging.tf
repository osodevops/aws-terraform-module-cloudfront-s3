module "bucket-cloudwatch-logs-backup" {
  source                  = "../../aws-terraform-module-s3"
  s3_bucket_name          = local.logging_bucket_name
  s3_bucket_force_destroy = false
  s3_bucket_policy        = ""
  common_tags             = var.common_tags

  # Bucket public access
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true

  versioning = {
    enabled = false
    mfa_delete = false
  }

  lifecycle_rule = [
    {
      enabled = true
      id      = "retire logs after 31 days"
      prefix  = "logs/access"
      expiration = [
        {
          days = 31
        },
      ]
      noncurrent_version_expiration = [
        {
          days = 7
        },
      ]
    }
  ]
}