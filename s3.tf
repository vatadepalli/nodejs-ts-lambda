# S3 bucket that stores lambda function archives
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.lambda_bucket_name
  acl           = "private"
  force_destroy = true
}

# Uploads archive to S3 bucket
# once done - aws s3 ls $(terraform output -raw lambda_bucket_name)
resource "aws_s3_object" "nodejs_ts_hello_world_archive" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "function.zip"
  source = local.lambda_archive_file_path

  etag = filemd5(local.lambda_archive_file_path)
}