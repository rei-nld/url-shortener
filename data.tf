data "archive_file" "lambda_function" {
  type = "zip"
  source_file = "src/lambda_function.py"
  output_path = "src/package.zip"
}