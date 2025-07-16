variable "lambda_arn" {
  type = string
}

variable "lambda_name" {
  description = "Name of the lambda to trigger"
  type = string
}

variable "aws_region_main" {
  description = "AWS region to deploy resources in"
  type        = string
 }

variable "tags" {
  description = "A map of key-value pairs representing common tags to apply to AWS resources (such as Name, Environment). Tags help in organizing and identifying resources, especially in large-scale environments."
  type        = map(string)
}