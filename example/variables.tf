variable "common_tags" {
  type = map(string)
}

variable "cloudfront_cache_compress_content" {
  type    = bool
  default = true
}
locals {
  example_bucket_name = "example-${data.aws_region.current.name}-${lower(data.aws_iam_account_alias.current.account_alias)}"
}