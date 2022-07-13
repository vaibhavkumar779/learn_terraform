resource "aws_s3_bucket" "NewS3" {
  bucket = var.bucket_name

  tags = {
    Environment = var.env_name
  }
}

resource "aws_s3_bucket_acl" "ACL_S3" {
  bucket = aws_s3_bucket.NewS3.id
  acl    = "private"
}

resource "aws_s3_object" "object_check" {
  
  for_each = fileset("./uploads/", "*")
  bucket   = aws_s3_bucket.NewS3.id
  key      = each.value
  source   = "./uploads/${each.value}"

  etag = filemd5("./uploads/${each.value}")
}
