output "cloudfront" {
  value = aws_cloudfront_distribution.main_cdn
}
output "cdn_identity_access" {
  value = aws_cloudfront_origin_access_identity.cdn_access_identity.iam_arn
}
