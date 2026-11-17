# erstellt Digitalen Ausweis, mit dem Cloudfront bei Bucket ausweist
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${aws_s3_bucket.website.bucket}-oac"
  description                       = "CloudFront access to the private S3 website bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}





# CDN: nimmt Anfragen entgegen und speichert in Cache
resource "aws_cloudfront_distribution" "website_cdn" {
  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true

# Woher kommen Daten
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "s3-website"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

# wie ausgeliefert und gespeichert
  default_cache_behavior {
    target_origin_id       = "s3-website"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    # cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

# Ländersperre
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
cloudfront_default_certificate = true
  }
}

# automatische Invalidierung für Änderungen an index.html
resource "terraform_data" "invalidate_index_html" {
  triggers_replace = [aws_s3_object.index.source_hash]

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.website_cdn.id} --paths /index.html"
  }
}