variable "aws_region_main" {
  description = "AWS region to deploy resources in"
  type        = string
 }

variable "tags" {
  description = "A map of key-value pairs representing common tags to apply to AWS resources (such as Name, Environment). Tags help in organizing and identifying resources, especially in large-scale environments."
  type        = map(string)
}

variable "bucket_name" {
  description = "Name of the S3 bucket to write to"
  type = string
}

variable "bucket_arn" {
  type = string
}

variable "dynamodb_table_name" {
  description = "Name of the dynamodb_table to write to"
  type = string
}

variable "dynamodb_table_arn" {
    description = "ARN of the dynamodb_table to write to" 
  type = string
}