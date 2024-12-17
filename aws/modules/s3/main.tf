resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_cloudfront_access" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = jsonencode({
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "AllowCloudFrontServicePrincipal",
                "Effect": "Allow",
                "Principal": {
                    "Service": "cloudfront.amazonaws.com"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${var.bucket_name}/*",
                "Condition": {
                    "StringEquals": {
                      "AWS:SourceArn": "${var.cloudfront_arn}"
                    }
                }
            }
        ]
      })
}