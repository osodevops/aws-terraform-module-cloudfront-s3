resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.cloudfront
  origin {
    domain_name = data.aws_s3_bucket.origin_bucket.bucket_regional_domain_name
    origin_id   = "${data.aws_s3_bucket.origin_bucket.id}-origin"

    s3_origin_config {
      origin_access_identity = local.shared_origin_path
    }
  }
  comment         = "${var.distribution_name} distribution"
  enabled         = true
  is_ipv6_enabled = true

  default_root_object = "index.html"

  viewer_certificate {
    cloudfront_default_certificate = var.use_cloudfront_default_certificate
    acm_certificate_arn            = aws_acm_certificate.certificate.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = var.minimum_protocol_version
  }

  custom_error_response {
    error_caching_min_ttl = var.custom_error_response_min_ttl
    error_code            = var.custom_error_response_error_code
    response_code         = var.custom_error_response_code
    response_page_path    = "/index.html"
  }

  aliases = [
    var.distribution_fqdn
  ]

  logging_config {
    bucket          = module.bucket_cloudwatch_logs_backup.s3_bucket_bucket_domain_name
    include_cookies = false
    prefix          = "cloudfront/"
  }

  #caching
  default_cache_behavior {
    response_headers_policy_id = var.response_header_policy_enable ? one(aws_cloudfront_response_headers_policy.security_headers_policy).id : ""

    min_ttl     = var.cloudfront_cache_min_ttl
    default_ttl = var.cloudfront_cache_default_ttl
    max_ttl     = var.cloudfront_cache_max_ttl
    compress    = var.cloudfront_cache_compress_content

    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    target_origin_id       = "${data.aws_s3_bucket.origin_bucket.id}-origin"
    viewer_protocol_policy = "redirect-to-https"

    dynamic "function_association" {
      for_each = var.function_associations
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }

  price_class = var.price_class

  #security
  web_acl_id = var.web_acl_id
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  #tags
  tags = var.common_tags

  depends_on = [module.bucket_cloudwatch_logs_backup, aws_acm_certificate.certificate]
}

resource "aws_cloudfront_origin_access_identity" "current" {
        count = var.shared_origin_access_identity != "" ? 0 : 1
}

resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name  = "${var.distribution_name}-cloudfront-security-headers-policy"
  count = var.response_header_policy_enable ? 1 : 0
  security_headers_config {
    # https://infosec.mozilla.org/guidelines/web_security#x-content-type-options
    # content_type_options {
    #   override = true
    # }
    # https://infosec.mozilla.org/guidelines/web_security#x-frame-options
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    # https://infosec.mozilla.org/guidelines/web_security#referrer-policy
    # referrer_policy {
    #   referrer_policy = "same-origin"
    #   override = true
    # }
    # https://infosec.mozilla.org/guidelines/web_security#content-security-policy
    # xss_protection {
    #   mode_block = true
    #   protection = true
    #   override = true
    # }
    # https://infosec.mozilla.org/guidelines/web_security#http-strict-transport-security
    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains         = true
      preload                    = true
      override                   = true
    }
    # https://infosec.mozilla.org/guidelines/web_security#content-security-policy
    # content_security_policy {
    #   content_security_policy = "frame-ancestors 'none'; default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"
    #   override = true
    # }
  }
}
