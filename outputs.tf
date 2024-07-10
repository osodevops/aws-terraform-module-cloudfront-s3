output "logging_bucket" {
  value = module.bucket_cloudwatch_logs_backup.s3_bucket_id
}

output "distribution" {
  value = aws_cloudfront_distribution.s3_distribution
}

output "identity" {
  value = try(aws_cloudfront_origin_access_identity.current[0], "")
}

output "domain_validations" {
  value = aws_route53_record.certificate_validation
}
