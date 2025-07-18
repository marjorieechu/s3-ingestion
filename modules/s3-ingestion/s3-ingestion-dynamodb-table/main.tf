resource "aws_dynamodb_table" "api_ingestion_metadata" {
  name         = format("%s-%s-api-to-s3-write-dynamodb-table", var.tags["environment"], var.tags["owner"])
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "record_id"

  # Primary key attribute
  attribute {
    name = "record_id"
    type = "S"
  }

  # Optional attribute for TTL
  attribute {
    name = "ttl"  # Optional field for TTL
    type = "N"
  }

  # Optional attribute for secondary index
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

  # TTL configuration (optional - enable if you want records to expire)
  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = var.tags
}

output "table_name" {
  value = aws_dynamodb_table.api_ingestion_metadata.name
}

output "table_arn" {
  value = aws_dynamodb_table.api_ingestion_metadata.arn
}
