resource "aws_apigatewayv2_api" "url-shortener" {
  name          = "sho.rten.me"
  description   = "URL Shortener"
  protocol_type = "HTTP"
}

# Redirect
resource "aws_apigatewayv2_integration" "lambda_integration-redirect" {
  api_id           = aws_apigatewayv2_api.url-shortener.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.url-shortener_redirect.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "ShortCode" {
  api_id    = aws_apigatewayv2_api.url-shortener.id
  route_key = "GET /{ShortCode}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration-redirect.id}"
}

resource "aws_lambda_permission" "allow_invoke-redirect" {
  statement_id  = "AllowHttpApiInvokePost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.url-shortener_redirect.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.url-shortener.execution_arn}/*"
}

# Shorten
resource "aws_apigatewayv2_integration" "lambda_integration-shorten" {
  api_id           = aws_apigatewayv2_api.url-shortener.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.url-shortener_shorten.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "shorten" {
  api_id    = aws_apigatewayv2_api.url-shortener.id
  route_key = "POST /shorten"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration-shorten.id}"
}

resource "aws_lambda_permission" "allow_invoke-shorten" {
  statement_id  = "AllowHttpApiInvokePost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.url-shortener_shorten.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.url-shortener.execution_arn}/*"
}

resource "aws_apigatewayv2_stage" "stageProd" {
  api_id      = aws_apigatewayv2_api.url-shortener.id
  name        = "$default"
}

resource "aws_apigatewayv2_deployment" "deployToProd" {
  depends_on = [
    aws_apigatewayv2_route.ShortCode,
    aws_apigatewayv2_route.shorten
  ]

  api_id = aws_apigatewayv2_api.url-shortener.id

  lifecycle {
    create_before_destroy = true
  }
}