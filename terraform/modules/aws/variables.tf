### AWS

variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "aws access key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_secret_key" {
  description = "aws secret key"
  type        = string
  default     = ""
  sensitive   = true
}

#### S3

variable "s3_bucket_name" {
  description = "s3 bucket name"
  type        = string
  default     = "s3-static-website"
}

variable "s3_tags" {
  description = "s3 tags"
  type        = map(string)
  default = {
    Name = "s3-static-website-bucket"
  }
}

#### ACM

variable "acm_certificate" {
  description = "ACM Certificate"
  type        = string
  default     = ""
  sensitive   = true
}

#### Route53

variable "route53_hostedzone_id" {
  description = "route53 hostedzone id"
  type        = string
  default     = ""
  sensitive   = true
}

variable "route53_record_name" {
  description = "route53 record name"
  type        = string
  default     = ""
}

variable "route53_base_domain" {
  description = "route53 base domain"
  type        = string
  default     = ""
}
