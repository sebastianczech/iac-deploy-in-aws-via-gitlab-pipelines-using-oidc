resource "aws_dynamodb_table" "table_create_via_gitlab_pipeline" {
  name           = "table_create_via_gitlab_pipeline"
  read_capacity  = "20"
  write_capacity = "20"
  hash_key       = "ID"

  attribute {
    name = "ID"
    type = "S"
  }
}