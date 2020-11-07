data "aws_s3_bucket" "origin_bucket" {
  bucket = var.s3_source_bukcet_name
}