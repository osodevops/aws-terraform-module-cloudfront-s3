data "aws_s3_bucket" "origin_bucket" {
  count  = var.origin_type == "s3" ? 1 : 0
  bucket = var.s3_source_bucket_name
}