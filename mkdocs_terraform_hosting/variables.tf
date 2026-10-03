variable "aws_region" {
  description = "AWS region  used to deploy the website"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Bucket used to deploy the website"
  type        = string
}

variable "site_directory" {
  description = "Directory containing the generated MkDocs files"
  type        = string
  default     = "site"
}
