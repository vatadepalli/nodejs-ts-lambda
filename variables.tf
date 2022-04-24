variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "ap-south-1"
}

variable "lambda_bucket_name" {
  description = "AWS S3 bucket name for storing Lambda function archive."
  type        = string
}

variable "SNOWFLAKE_ACCOUNT" {
  type = string
}
variable "SNOWFLAKE_USERNAME" {
  type = string
}
variable "SNOWFLAKE_PASSWORD" {
  type = string
}
variable "SNOWFLAKE_DATABASE" {
  type = string
}
variable "SNOWFLAKE_SCHEMA" {
  type = string
}
variable "SNOWFLAKE_WAREHOUSE" {
  type = string
}
variable "SNOWFLAKE_ROLE" {
  type = string
}