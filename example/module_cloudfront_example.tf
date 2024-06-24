module "cloudfront_example" {
  source                            = "git::ssh://git@github.com/osodevops/aws-terraform-module-cloudfront-s3.git"
  s3_source_bucket_name             = local.example_bucket_name
  distribution_fqdn                 = "example.domain-name.com"
  distribution_name                 = "example"
  hosted_zone_name                  = "domain-name.com"
  common_tags                       = var.common_tags
  cloudfront_cache_compress_content = var.cloudfront_cache_compress_content
}
