# create an API gateway HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = format("%s-%s-api-to-s3-ingestion-api", var.tags["environment"], var.tags["owner"])
  protocol_type = "HTTP"

  tags          = var.tags
}

# Integrate the Lambda with API gateway
resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

# create the route
resource "aws_apigatewayv2_route" "ingest" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /ingest"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# create the deployment
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# allow API gateway to invoke lambda
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowInvokeByAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

output "api_url" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/ingest"
}
