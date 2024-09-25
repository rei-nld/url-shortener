output "static_website_url" {
    value = aws_s3_bucket_website_configuration.static_website.website_endpoint
}

output "url-shortener_function_url" {
  value = aws_lambda_function_url.url-shortener.function_url
}
