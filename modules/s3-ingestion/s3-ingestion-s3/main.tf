resource "aws_s3_bucket" "this" {
  bucket        = format("%s-%s-api-to-s3-write-s3", var.tags["environment"], var.tags["owner"])
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket" "replica" {
  bucket        = format("%s-%s-api-to-s3-write-replica", var.tags["environment"], var.tags["owner"])
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "replica_versioning" {
  bucket = aws_s3_bucket.replica.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [
    aws_s3_bucket_versioning.versioning,
    aws_s3_bucket_versioning.replica_versioning
  ]

  bucket = aws_s3_bucket.this.id
  role   = aws_iam_role.replication_role.arn

  rule {
    id     = "replicate-everything"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD"
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
