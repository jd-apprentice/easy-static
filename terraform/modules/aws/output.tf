output "arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.s3_static_website.arn
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.s3_static_website.id
}

output "bucket_endpoint" {
  description = "Endpoint of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.s3_static_website.website_endpoint
}
