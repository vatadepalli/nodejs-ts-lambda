# Gateway Definition
resource "aws_apigatewayv2_api" "nodejs_ts_api_gateway" {
  name          = "nodejs_ts_api_gateway"
  protocol_type = "HTTP"
}

# API Stage Definition
resource "aws_apigatewayv2_stage" "nodejs_ts_api_gateway_prod" {
  api_id = aws_apigatewayv2_api.nodejs_ts_api_gateway.id

  name        = "prod"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

# API Gateway Integration Definition
resource "aws_apigatewayv2_integration" "nodejs_ts_api_gateway_integration" {
  api_id = aws_apigatewayv2_api.nodejs_ts_api_gateway.id

  integration_uri    = aws_lambda_function.nodejs_ts_hello_world.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# API Gateway Authorizer Definition
resource "aws_apigatewayv2_authorizer" "nodejs_ts_api_gateway_auth0_authorizer" {
  api_id           = aws_apigatewayv2_api.nodejs_ts_api_gateway.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "nodejs_ts_api_gateway_auth0_authorizer"

  jwt_configuration {
    audience = [var.AUTH0_AUDIENCE]
    issuer   = var.AUTH0_ISSUER_URL
  }
}

# API Route Definition(s)
resource "aws_apigatewayv2_route" "nodejs_ts_hello" {
  api_id = aws_apigatewayv2_api.nodejs_ts_api_gateway.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.nodejs_ts_api_gateway_integration.id}"

  authorizer_id = aws_apigatewayv2_authorizer.nodejs_ts_api_gateway_auth0_authorizer.id
  authorization_type = "JWT"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.nodejs_ts_api_gateway.name}"

  retention_in_days = 30
}

# Permission for API Gateway to Execute Lambda Function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nodejs_ts_hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.nodejs_ts_api_gateway.execution_arn}/*/*"
}
