resource "aws_iam_role" "lambda_exec" {
  name = format("%s-%s-api-to-s3-write-lambda-role", var.tags["environment"], var.tags["owner"])

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}