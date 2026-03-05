resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-bucket"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = "production"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_block" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend_block]
}
# resource "aws_s3_bucket_ownership_controls" "frontend" {
#   bucket = aws_s3_bucket.frontend.id

#   rule {
#     object_ownership = "BucketOwnerEnforced"
#   }
# }


# resource "aws_cloudfront_origin_access_identity" "frontend_oai" {
#   comment = "${var.project_name}-OAI"
# }



# resource "aws_s3_bucket_policy" "frontend_policy" {
#   bucket = aws_s3_bucket.frontend.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = aws_cloudfront_origin_access_identity.frontend_oai.iam_arn
#         }
#         Action   = "s3:GetObject"
#         Resource = "${aws_s3_bucket.frontend.arn}/*"
#       }
#     ]
#   })
# }



# resource "aws_cloudfront_distribution" "frontend_cdn" {

#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "index.html"

#   origin {
#     domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
#     origin_id   = "S3-${aws_s3_bucket.frontend.id}"

#     s3_origin_config {
#       origin_access_identity = aws_cloudfront_origin_access_identity.frontend_oai.cloudfront_access_identity_path
#     }
#   }

#   default_cache_behavior {
#     target_origin_id       = "S3-${aws_s3_bucket.frontend.id}"
#     viewer_protocol_policy = "redirect-to-https"

#     allowed_methods = ["GET", "HEAD", "OPTIONS"]
#     cached_methods  = ["GET", "HEAD"]

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }

#     min_ttl     = 0
#     default_ttl = 3600
#     max_ttl     = 86400
#   }

#   custom_error_response {
#     error_code         = 403
#     response_code      = 200
#     response_page_path = "/index.html"
#   }

#   custom_error_response {
#     error_code         = 404
#     response_code      = 200
#     response_page_path = "/index.html"
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   tags = {
#     Environment = "production"
#   }

#   depends_on = [
#     aws_s3_bucket_policy.frontend_policy
#   ]
# }