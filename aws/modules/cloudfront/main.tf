resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = var.domain_name
    origin_id = var.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3.id
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id
    viewer_protocol_policy = "allow-all"
    cache_policy_id = data.aws_cloudfront_cache_policy.cacheoptimized.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  enabled = true
  default_root_object = "index.html"
  depends_on = [ aws_cloudfront_origin_access_control.s3 ]
}

resource "aws_cloudfront_origin_access_control" "s3" {
  name = "cloudfront_s3_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

data "aws_cloudfront_cache_policy" "cacheoptimized" {
  name = "Managed-CachingOptimized"
}