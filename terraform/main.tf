variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "s3_bucket_name" {}
variable "s3_tags" {}
variable "acm_certificate" {}
variable "route53_base_domain" {}
variable "route53_hostedzone_id" {}
variable "route53_record_name" {}

module "static_s3_bucket" {
  source                = "./modules/aws"
  aws_region            = var.aws_region
  aws_access_key        = var.aws_access_key
  aws_secret_key        = var.aws_secret_key
  s3_bucket_name        = var.s3_bucket_name
  s3_tags               = var.s3_tags
  acm_certificate       = var.acm_certificate
  route53_base_domain   = var.route53_base_domain
  route53_hostedzone_id = var.route53_hostedzone_id
  route53_record_name   = var.route53_record_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.static_s3_bucket.arn
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.static_s3_bucket.bucket_name
}

output "s3_bucket_endpoint" {
  description = "Endpoint of the S3 bucket"
  value       = module.static_s3_bucket.bucket_endpoint
}
