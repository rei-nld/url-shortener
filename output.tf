output "static_website_url" {
    value = aws_s3_bucket_website_configuration.static_website.website_endpoint
}

output "url-shortener_redirect_function_url" {
  value = aws_lambda_function_url.url-shortener_redirect.function_url
}

output "url-shortener_shorten_function_url" {
  value = aws_lambda_function_url.url-shortener_shorten.function_url
}

output "api-gateway_endpoint" {
  value = aws_apigatewayv2_api.url-shortener.api_endpoint
}