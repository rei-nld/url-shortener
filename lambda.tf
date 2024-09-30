#resource "aws_lambda_layer_version" "dependencies" {
#  layer_name = "dependencies"
#
# filename = "src/dependencies.zip"
#
#  compatible_runtimes = ["python3.12"]
#}

resource "aws_lambda_function" "url-shortener_redirect" {
  function_name = "url-shortener_redirect"

  filename = data.archive_file.lambda_function-redirect.output_path

  handler = "lambda_function-redirect.lambda_handler"
  runtime = "python3.12"
  role    = resource.aws_iam_role.lambda_execution_role.arn

  #layers = [resource.aws_lambda_layer_version.dependencies.arn]

  timeout = 30
  memory_size = 128

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.url-mapping.name
    }
  }
}

resource "aws_lambda_function" "url-shortener_shorten" {
  function_name = "url-shortener_shorten"

  filename = data.archive_file.lambda_function-shorten.output_path

  handler = "lambda_function-shorten.lambda_handler"
  runtime = "python3.12"
  role    = resource.aws_iam_role.lambda_execution_role.arn

  #layers = [resource.aws_lambda_layer_version.dependencies.arn]

  timeout = 30
  memory_size = 128

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.url-mapping.name
    }
  }
}

resource "aws_lambda_function_url" "url-shortener_redirect" {
  function_name      = resource.aws_lambda_function.url-shortener_redirect.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_function_url" "url-shortener_shorten" {
  function_name      = resource.aws_lambda_function.url-shortener_shorten.function_name
  authorization_type = "NONE"
}