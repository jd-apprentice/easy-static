resource "aws_s3_bucket" "s3_static_website" {
  bucket = var.s3_bucket_name
  tags   = var.s3_tags
}

resource "aws_s3_bucket_public_access_block" "s3_static_block" {
  bucket                  = aws_s3_bucket.s3_static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3_static_own" {
  bucket = aws_s3_bucket.s3_static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_static_website" {
  depends_on = [
    aws_s3_bucket_public_access_block.s3_static_block,
    aws_s3_bucket_ownership_controls.s3_static_own
  ]
  bucket = aws_s3_bucket.s3_static_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "s3_static_website" {
  bucket = aws_s3_bucket.s3_static_website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource = [
          aws_s3_bucket.s3_static_website.arn,
          "${aws_s3_bucket.s3_static_website.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "s3_static_website" {
  bucket = aws_s3_bucket.s3_static_website.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
