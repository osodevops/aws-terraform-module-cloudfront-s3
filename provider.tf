# The aws.cloudfront provider alias is declared via configuration_aliases in
# terraform.tf. Consumers must pass it when calling this module:
#
#   providers = {
#     aws.cloudfront = aws.us_east_1
#   }
#
# The provider must target us-east-1 because CloudFront requires ACM
# certificates in that region.