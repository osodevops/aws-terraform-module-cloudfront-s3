resource "aws_acm_certificate" "certificate" {
  provider          = aws.cloudfront
  domain_name       = var.distribution_fqdn
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  tags = var.common_tags
}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.cloudfront
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
  depends_on              = [aws_route53_record.certificate_validation]
}

resource "aws_route53_record" "certificate_validation" {
  for_each = var.whitelabel_domain == false ? {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id         = one(data.aws_route53_zone.current).zone_id
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type

  depends_on = [aws_acm_certificate.certificate]
}

