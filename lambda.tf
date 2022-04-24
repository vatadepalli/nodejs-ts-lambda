# Configures the Lambda function
resource "aws_lambda_function" "nodejs_ts_hello_world" {
  function_name = "NodeJSTSHelloWorld"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.nodejs_ts_hello_world_archive.key

  runtime = "nodejs12.x"
  handler = "dist/index.handler"

  source_code_hash = base64encode(filesha256(local.lambda_archive_file_path))

  role = aws_iam_role.lambda_exec.arn

  timeout = 20

  environment {
    variables = {
      SNOWFLAKE_ACCOUNT   = var.SNOWFLAKE_ACCOUNT,
      SNOWFLAKE_USERNAME  = var.SNOWFLAKE_USERNAME,
      SNOWFLAKE_PASSWORD  = var.SNOWFLAKE_PASSWORD,
      SNOWFLAKE_DATABASE  = var.SNOWFLAKE_DATABASE,
      SNOWFLAKE_SCHEMA    = var.SNOWFLAKE_SCHEMA,
      SNOWFLAKE_WAREHOUSE = var.SNOWFLAKE_WAREHOUSE,
      SNOWFLAKE_ROLE      = var.SNOWFLAKE_ROLE,
    }
  }
}

# A log group to store log messages from your Lambda function for 30 days
resource "aws_cloudwatch_log_group" "nodejs_ts_hello_world" {
  name = "/aws/lambda/${aws_lambda_function.nodejs_ts_hello_world.function_name}"

  retention_in_days = 30
}

# IAM role that allows Lambda to access resources in your AWS account.
resource "aws_iam_role" "lambda_exec" {
  name = "nodejs_ts_hello_world_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# Attaches a policy the IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role = aws_iam_role.lambda_exec.name

  # policy that allows your Lambda function to write to CloudWatch logs.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}