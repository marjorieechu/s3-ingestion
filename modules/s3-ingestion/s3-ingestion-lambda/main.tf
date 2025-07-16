# Package Lambda (zip entire folder)
data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_function"
  output_path = "${path.module}/lambda_function.zip"
}



resource "aws_lambda_function" "api_writer" {
  function_name = format("%s-%s-api-to-s3-write-lambda", var.tags["environment"], var.tags["owner"])
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "python3.11"
  handler       = "lambda_function.lambda_handler"
  filename      = "${path.module}/lambda_function.zip"
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name   
    }
  }
}

output "lambda_arn" {
  value = aws_lambda_function.api_writer.arn
}

output "lambda_name" {
  value = aws_lambda_function.api_writer.function_name
}