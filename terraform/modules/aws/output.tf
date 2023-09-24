output "arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.primary_bucket.arn
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.primary_bucket.id
}

output "bucket_endpoint" {
  description = "Endpoint of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.bucket_configuration.website_endpoint
}
