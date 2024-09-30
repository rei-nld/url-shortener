resource "aws_dynamodb_table" "url-mapping" {
  name = var.dynamodb_tablename
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "ShortCode"

  attribute {
    name = "ShortCode"
    type = "S"
  }
}