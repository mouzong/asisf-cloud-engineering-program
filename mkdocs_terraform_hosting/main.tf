resource "aws_s3_bucket" "mkdocs_bk" {
  bucket = var.bucket_name

  tags = {
    Name        = "Cloud Engineering MkDocs"
    Environment = "DEV"
    ManagedBy   = "IaC-Terraform"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mkdocs_bk.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.mkdocs_bk.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mkdocs_bucket_policy" {
  bucket = aws_s3_bucket.mkdocs_bk.id

  depends_on = [aws_s3_bucket_public_access_block.website]

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"

        Resource = "${aws_s3_bucket.mkdocs_bk.arn}/*"
      }
    ]
  })

}

locals {
  site_files = fileset(
    "${path.module}/${var.site_directory}",
    "**"
  )

  mime_types = {
    ".html"  = "text/html"
    ".css"   = "text/css"
    ".js"    = "application/javascript"
    ".json"  = "application/json"
    ".xml"   = "application/xml"
    ".txt"   = "text/plain"
    ".png"   = "image/png"
    ".jpg"   = "image/jpeg"
    ".jpeg"  = "image/jpeg"
    ".gif"   = "image/gif"
    ".svg"   = "image/svg+xml"
    ".ico"   = "image/x-icon"
    ".webp"  = "image/webp"
    ".woff"  = "font/woff"
    ".woff2" = "font/woff2"
    ".ttf"   = "font/ttf"
    ".pdf"   = "application/pdf"
  }
}

resource "aws_s3_object" "website_files" {
  for_each = local.site_files

  bucket = aws_s3_bucket.mkdocs_bk.id

  key = each.value

  source = "${path.module}/${var.site_directory}/${each.value}"

  source_hash = filemd5(
    "${path.module}/${var.site_directory}/${each.value}"
  )

  content_type = lookup(
    local.mime_types,
    regex("\\.[^.]+$", each.value),
    "application/octet-stream"
  )
}
