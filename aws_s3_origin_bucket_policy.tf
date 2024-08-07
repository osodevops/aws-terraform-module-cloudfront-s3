resource "aws_s3_bucket_policy" "allow_cloudfront" {
  count = var.shared_origin_access_identity != "" ? 0 : 1
  bucket = data.aws_s3_bucket.origin_bucket.id
  policy = data.aws_iam_policy_document.cloudfront[0].json
}

data "aws_iam_policy_document" "cloudfront" {
  count = var.shared_origin_access_identity != "" ? 0 : 1
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      data.aws_s3_bucket.origin_bucket.arn,
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.current[0].iam_arn,
      ]
    }
  }

  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${data.aws_s3_bucket.origin_bucket.arn}/*",
    ]
    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.current[0].iam_arn,
      ]
    }
  }

  statement {
    sid = "AllowSSLRequestsOnly"
    effect = "Deny"
    actions = [
      "s3:*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      data.aws_s3_bucket.origin_bucket.arn,
      "${data.aws_s3_bucket.origin_bucket.arn}/*"
    ]
  }
}
