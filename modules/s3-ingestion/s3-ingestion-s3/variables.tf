variable "aws_region_main" {
  description = "AWS region to deploy resources in"
  type        = string
 }

variable "tags" {
  type        = map(string)
  description = "A map of key-value pairs representing common tags to apply to AWS resources (such as Name, Environment). Tags help in organizing and identifying resources, especially in large-scale environments."
}
