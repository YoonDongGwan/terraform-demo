output "bucekt_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
}
output "bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}