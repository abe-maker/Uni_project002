
# S3-Bucket
resource "aws_s3_bucket" "website" {
  bucket = "bucket-cloud-programming"
  force_destroy = true
}


# öffentlichen Zugriff komplett sperren
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# Verknüpft data-Block mit S3-Bucket
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.allow_cloudfront.json

  depends_on = [aws_s3_bucket_public_access_block.website]
}


#  index.html automatisch hochladen
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "${path.module}/website/index.html"
  source_hash  = filemd5("${path.module}/website/index.html")
  content_type = "text/html"
}

# Bucket Policy, damit Cloudfront auf Bucket zugreifen darf
data "aws_iam_policy_document" "allow_cloudfront" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.website_cdn.arn]
    }
  }
}



