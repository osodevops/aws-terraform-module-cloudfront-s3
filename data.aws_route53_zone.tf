data "aws_route53_zone" "current" {
  name         = var.hosted_zone_name
  private_zone = false
}
