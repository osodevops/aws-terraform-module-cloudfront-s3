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
  type = list(object({
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
  type    = string
  default = null
}

variable "ttl" {
  type    = string
  default = "300"
}

variable "function_associations" {
  description = "A config block that triggers a function with specific actions"
  type = list(object({
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

variable "origin_type" {
  description = "The type of origin to use: s3 or http"
  type        = string
  default     = "s3"
}

variable "origin_domain_name" {
  description = "The domain name of the origin. For S3 origins this is derived automatically from s3_source_bucket_name if left empty."
  type        = string
  default     = ""
}

variable "origin_id" {
  description = "The unique origin ID. For S3 origins this is derived automatically from s3_source_bucket_name if left empty."
  type        = string
  default     = ""
}

variable "custom_origin_config" {
  description = "Optional custom origin config for HTTP(S) origins"
  type = object({
    http_port              = number
    https_port             = number
    origin_protocol_policy = string
    origin_ssl_protocols   = list(string)
  })
  default = null
}

variable "s3_origin_access_identity" {
  description = "S3 origin access identity path (if using S3 origin)"
  type        = string
  default     = ""
}


variable "allowed_methods" {
  description = "Allowed HTTP methods for the default cache behavior (add OPTIONS for CORS or API verbs as needed)."
  type        = set(string)
  default     = ["GET", "HEAD"]
  validation {
    condition     = length(setsubtract(var.allowed_methods, ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])) == 0
    error_message = "allowed_methods must be a subset of: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE."
  }
}

variable "cached_methods" {
  description = "HTTP methods CloudFront will cache for the default cache behavior (must be a subset of allowed_methods)."
  type        = set(string)
  default     = ["GET", "HEAD"]
  validation {
    condition     = length(setsubtract(var.cached_methods, ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])) == 0
    error_message = "cached_methods must be a subset of: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE."
  }
}

variable "default_root_object" {
  description = "Object to serve at the distribution root path; set to \"index.html\" for SPA, or null to disable - by default."
  type        = string
  default     = null
}

variable "enable_spa_404" {
  description = "Enable custom error response mapping 404s to /index.html for SPA deep linking."
  type        = bool
  default     = false
}

variable "spa_404_page_path" {
  description = "Path served for SPA 404 rewrites when enable_spa_404 is true."
  type        = string
  default     = "/index.html"
}
variable "common_tags" {
  type        = map(string)
  description = "Implements the common tags."
}

locals {
  logging_bucket_name = "${var.distribution_name}-cf-logs-${data.aws_region.current.name}-${lower(data.aws_iam_account_alias.current.account_alias)}"
  shared_origin_path  = var.shared_origin_access_identity != "" ? var.shared_origin_access_identity : aws_cloudfront_origin_access_identity.current[0].cloudfront_access_identity_path

  # For S3 origins, derive domain_name and origin_id from the bucket data source if not explicitly set.
  effective_origin_domain_name = var.origin_domain_name != "" ? var.origin_domain_name : one(data.aws_s3_bucket.origin_bucket).bucket_regional_domain_name
  effective_origin_id          = var.origin_id != "" ? var.origin_id : "S3-${var.s3_source_bucket_name}"
}
