resource "aws_lambda_layer_version" "dependencies" {
  layer_name = "dependencies"

  filename = "src/dependencies.zip"

  compatible_runtimes = ["python3.12"]
}

resource "aws_lambda_function" "url-shortener" {
  function_name = "url-shortener"

  filename = data.archive_file.lambda_function.output_path

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  role    = resource.aws_iam_role.lambda_execution_role.arn

  layers = [resource.aws_lambda_layer_version.dependencies.arn]

  timeout = 30
  memory_size = 128

  environment {
    variables = {
      # ENV_VAR = value
    }
  }
}

resource "aws_lambda_function_url" "url-shortener" {
  function_name      = resource.aws_lambda_function.url-shortener.function_name
  authorization_type = "NONE"
}