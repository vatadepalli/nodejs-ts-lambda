output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value       = aws_s3_bucket.lambda_bucket.id
}

output "lambda_function_name" {
  description = "Name of the Lambda function."
  value       = aws_lambda_function.nodejs_ts_hello_world.function_name
}

# aws lambda invoke --region=ap-south-1 --function-name=$(terraform output -raw lambda_function_name) response.json

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.nodejs_ts_api_gateway_prod.invoke_url
}

# curl "$(terraform output -raw base_url)/hello?name=banna"
