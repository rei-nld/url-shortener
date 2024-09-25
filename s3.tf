resource "aws_s3_bucket" "largest_graveyard_mmxxiv" {
  bucket_prefix = "largest-graveyard-mmxxiv-"
  force_destroy = true
}

resource "aws_s3_object" "index" {
  bucket = resource.aws_s3_bucket.largest_graveyard_mmxxiv.bucket
  key    = "index.html"
  source = "src/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = resource.aws_s3_bucket.largest_graveyard_mmxxiv.bucket
  key    = "error.html"
  source = "src/error.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.largest_graveyard_mmxxiv.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.largest_graveyard_mmxxiv.bucket
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.largest_graveyard_mmxxiv.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = "*",
      Action = "s3:GetObject",
      Resource = "${aws_s3_bucket.largest_graveyard_mmxxiv.arn}/*"
    }]
  })
  depends_on = [ aws_s3_bucket_public_access_block.public_access ]
}