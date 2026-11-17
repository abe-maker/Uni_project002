output "route53_name_servers" {
  description = "Name servers to configure at the domain registrar"
  value       = aws_route53_zone.website.name_servers
}

output "cloudfront_url" {
  description = "URL of the CloudFront distribution"
  value       = "https://${aws_cloudfront_distribution.website_cdn.domain_name}"
}