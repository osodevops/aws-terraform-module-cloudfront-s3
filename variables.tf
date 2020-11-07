variable "cloudfront_cache_min_ttl" {
  type        = number
  description = "The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries."
  default     = 30
}

variable "cloudfront_cache_default_ttl" {
  type        = number
  description = "he default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request."
  default     = 90
}

variable "cloudfront_cache_max_ttl" {
  type        = number
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request."
  default     = 300
}

variable "distribution_fqdn" {
  type        = string
  description = "Fully qualified domain bound to Cloudfront."
}

variable "hosted_zone_name" {
  type        = string
  description = "The route53 zone."
}

variable "price_class" {
  type    = string
  description = "The price class for this distribution."
  default = "PriceClass_100"
}

variable "s3_source_bukcet_name" {
  type = string
}

variable "ttl" {
  type    = string
  default = "300"
}

variable "use_cloudfront_default_certificate" {
  type        = bool
  description = "Default SSL certificate."
  default     = false
}

variable "web_acl_id" {
  type        = string
  description = "Optional WAF Id to associate with the distribution"
  default     = ""
}

variable "common_tags" {
  type        = map(string)
  description = "Implements the common tags."
}

locals {
  logging_bucket_name = "test-cloudfront-logs-${data.aws_region.current.name}-${lower(data.aws_iam_account_alias.current.account_alias)}"
}