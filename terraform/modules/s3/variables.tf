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
