resource "aws_route53_record" "fqdn_cloudfront_dist" {
  count   = var.whitelabel_domain ? 0 : 1
  zone_id = one(data.aws_route53_zone.current).zone_id
  name    = var.distribution_fqdn

  allow_overwrite = false
  type            = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  }
}
