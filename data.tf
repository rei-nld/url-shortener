data "archive_file" "lambda_function-redirect" {
  type = "zip"
  source_file = "src/lambda_function-redirect.py"
  output_path = "src/package-redirect.zip"
}

data "archive_file" "lambda_function-shorten" {
  type = "zip"
  source_file = "src/lambda_function-shorten.py"
  output_path = "src/package-shorten.zip"
}