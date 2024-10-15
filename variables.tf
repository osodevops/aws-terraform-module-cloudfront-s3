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

variable "cloudfront_cache_compress_content" {
  type        = bool
  description = "Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header"
  default     = false
}

variable "cors_rules" {
  description = "List of maps of cors rules to ap[ply to the logging bucket"
  type        = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "custom_error_response_error_code" {
  description = "Custom error code for error response"
  type        = number
  default     = 404
}

variable "custom_error_response_min_ttl" {
  description = "Minimum time-to-live for error caching"
  type        = number
  default     = 300
}

variable "custom_error_response_code" {
  description = "Custom error code for error response"
  type        = number
  default     = 200
}

variable "distribution_fqdn" {
  type        = string
  description = "Fully qualified domain bound to Cloudfront."
}

variable "distribution_name" {
  type        = string
  description = "A unique name give to the distribution."
}

variable "hosted_zone_name" {
  type        = string
  description = "The route53 zone."
}

variable "s3_logging_versioning" {
  description = "Whether to version the contents of the logging bucket"
  type        = string
  default     = "Suspended"
}

variable "minimum_protocol_version" {
  description = "Minimum protocol version for the viewer certificate"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "price_class" {
  type        = string
  description = "The price class for this distribution."
  default     = "PriceClass_100"
}

variable "s3_source_bucket_name" {
  type = string
}

variable "ttl" {
  type    = string
  default = "300"
}

variable "function_associations" {
  description = "A config block that triggers a function with specific actions"
  type        = list(object({
    event_type   = string
    function_arn = string
  }))
  default = []
}

variable "response_header_policy_enable" {
  description = "Feature-flag for including response header policy"
  type        = bool
  default     = true
}

variable "shared_origin_access_identity" {
  description = "cloudfront_access_identity_path from a previous distribution, so we can use the same origin"
  type        = string
  default     = ""
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

variable "whitelabel_domain" {
  description = "Flag to toggle whitelabeling the domain"
  type        = bool
  default     = false
}

variable "acl_disabled" {
  description = "Boolean flag to disable ACL"
  type        = bool
  default     = true
}

variable "owner_enabled" {
  description = "Boolean flag to enable owner controlled"
  type        = bool
  default     = true
}

variable "common_tags" {
  type        = map(string)
  description = "Implements the common tags."
}

locals {
  logging_bucket_name = "${var.distribution_name}-cf-logs-${data.aws_region.current.name}-${lower(data.aws_iam_account_alias.current.account_alias)}"
  shared_origin_path  = var.shared_origin_access_identity != "" ? var.shared_origin_access_identity : aws_cloudfront_origin_access_identity.current[0].cloudfront_access_identity_path
}
