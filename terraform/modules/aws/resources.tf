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

resource "aws_cloudfront_origin_access_identity" "s3_static_website" {
  comment = "Access identity for static website"
}

resource "aws_cloudfront_origin_access_control" "s3_static_website" {
  name                              = "origin-access-identity/${aws_s3_bucket.s3_static_website.id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_static_website" {
  origin {
    domain_name = aws_s3_bucket.s3_static_website.bucket_regional_domain_name
    origin_id   = "MainOrigin"
    # origin_access_control_id = aws_cloudfront_origin_access_control.s3_static_website.id
  }

  origin {
    domain_name = aws_s3_bucket.s3_static_website.bucket_regional_domain_name
    origin_id   = "FailoverOrigin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for static website"
  default_root_object = "index.html"

  aliases = [var.route53_record_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "DefaultOriginGroup"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin_group {
    origin_id = "DefaultOriginGroup"

    member {
      origin_id = "MainOrigin"
    }

    member {
      origin_id = "FailoverOrigin"
    }

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn            = aws_acm_certificate.s3_static_website.arn
    ssl_support_method             = "sni-only"
  }

  tags = var.s3_tags
}

resource "aws_route53_record" "s3_static_website" {
  zone_id = var.route53_hostedzone_id
  name    = var.route53_record_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_static_website.domain_name
    zone_id                = aws_cloudfront_distribution.s3_static_website.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "s3_static_website" {
  domain_name       = var.route53_record_name
  validation_method = "EMAIL"

  validation_option {
    domain_name       = var.route53_record_name
    validation_domain = var.route53_base_domain
  }

  tags = var.s3_tags
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
