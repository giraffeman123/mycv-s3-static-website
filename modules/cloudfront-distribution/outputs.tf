output "cf_distribution_arn" {
  value = aws_cloudfront_distribution.cf_dist.arn
}

output "cf_dist_domain_name" {
  value = aws_cloudfront_distribution.cf_dist.domain_name
}

output "cf_dist_hosted_zone_id" {
  value = aws_cloudfront_distribution.cf_dist.hosted_zone_id
}