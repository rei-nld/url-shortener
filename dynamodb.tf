resource "aws_dynamodb_table" "url-mapping" {
  name = "url-mapping"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "ShortCode"
  range_key = "LongUrl"

  attribute {
    name = "ShortCode"
    type = "S"
  }

  attribute {
    name = "LongUrl"
    type = "S"
  }
}