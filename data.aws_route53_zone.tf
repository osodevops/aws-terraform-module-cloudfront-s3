data "aws_route53_zone" "current" {
  count        = var.whitelabel_domain ? 0 : 1
  name         = var.hosted_zone_name
  private_zone = false
}
