locals {
  env = yamldecode(file("${path.module}/../../environments/sentinel.yaml"))
}

terraform {
  required_version = ">= 1.10.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "development-sentinel-sandbox-tf-state"
    key            = "sentinel/s3-ingestion/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-sentinel-sandbox-tf-state-lock"
  }
}

module "s3-ingestion-s3" {
  source          = "../../modules/s3-ingestion/s3-ingestion-s3"
  tags            = local.env.tags
  aws_region_main = local.env.s3-ingestion.aws_region_main
}

module "dynamodb_ingestion_metadata" {
  source = "../../modules/s3-ingestion/s3-ingestion-dynamodb-table"
  tags   = local.env.tags
  aws_region_main = local.env.s3-ingestion.aws_region_main
}

module "s3-ingestion-lambda" {
  source          = "../../modules/s3-ingestion/s3-ingestion-lambda"
  tags            = local.env.tags
  aws_region_main = local.env.s3-ingestion.aws_region_main
  bucket_name     = module.s3-ingestion-s3.bucket_name
  bucket_arn      = module.s3-ingestion-s3.bucket_arn
  dynamodb_table_name     = module.s3-ingestion-dynamodb-table.dynamodb_table_name
  dynamodb_table_arn      = module.s3-ingestion-dynamodb-table.dynamodb_table_arn
}

module "s3-ingestion-api-gateway" {
  source          = "../../modules/s3-ingestion/s3-ingestion-api-gateway"
  tags            = local.env.tags
  lambda_arn      = module.s3-ingestion-lambda.lambda_arn
  lambda_name     = module.s3-ingestion-lambda.lambda_name
  aws_region_main = local.env.s3-ingestion.aws_region_main
}