output "bucket_name" {
  description = "S3 Bucket hosting our website"
  value       = aws_s3_bucket.mkdocs_bk.bucket
}

output "site_url" {
  description = "Hosted Website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
