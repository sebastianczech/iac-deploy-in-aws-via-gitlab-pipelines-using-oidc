resource "aws_dynamodb_table" "table_create_via_github_actions" {
  provider       = aws.cloud
  name           = "table_create_via_github_actions"
  read_capacity  = "20"
  write_capacity = "20"
  hash_key       = "ID"

  attribute {
    name = "ID"
    type = "S"
  }
}