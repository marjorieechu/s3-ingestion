resource "aws_dynamodb_table" "api_ingestion_metadata" {
  name         = format("%s-%s-api-to-s3-write-dynamodb-table", var.tags["environment"], var.tags["owner"])
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "record_id"

  # Primary key attribute
  attribute {
    name = "record_id"
    type = "S"
  }

  # Secondary index attribute
  attribute {
    name = "status"
    type = "S"
  }

  # Global Secondary Index to query by status
  global_secondary_index {
    name            = "status-index"
    hash_key        = "status"
    projection_type = "ALL"
  }

  # TTL configuration (no need to declare 'ttl' in attribute block)
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = var.tags
}


output "dynamodb_table_name" {
  value = aws_dynamodb_table.api_ingestion_metadata.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.api_ingestion_metadata.arn
}
