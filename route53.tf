# erstellt Zone
resource "aws_route53_zone" "website" {
  name = var.domain_name
}


# Weiterleitungs-Regel
resource "aws_route53_record" "website_ipv4" {
  zone_id = aws_route53_zone.website.zone_id
  name    = var.domain_name
  type    = "A"

# für wechselnde IP-Adressen
  alias {
    name                   = aws_cloudfront_distribution.website_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
