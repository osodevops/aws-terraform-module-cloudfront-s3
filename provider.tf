#certificate has to be created in us-east-1 due to cloudfront pre-requisite
provider "aws" {
  region  = "us-east-1"
  alias = "cloudfront"
}