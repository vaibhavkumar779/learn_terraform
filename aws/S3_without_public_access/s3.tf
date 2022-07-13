resource "aws_s3_bucket" "NewS3" {
  bucket = var.bucket_name

  tags = {
    Environment = var.env_name
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket                  = aws_s3_bucket.NewS3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
