data "aws_region" "current" {}

data "aws_availability_zones" "this" {}

data "aws_caller_identity" "current" {}

data "aws_canonical_user_id" "current" {}

data "aws_iam_account_alias" "current" {}