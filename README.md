# s3-ingestion

Serverless AWS S3 ingestion pipeline using API Gateway, Lambda and DynamoDB - a cost-effective alternative to Kinesis Firehose

modules/s3-ingestion/s3-ingestion-lambda/
Contains Terraform to:
Create the Lambda function
Attach IAM role/policy
Read from a local ZIP

modules/s3-ingestion/s3-ingestion-s3/
Contains Terraform to:
Create S3 bucket
Enable versioning/lifecycle rules
(Optional) Configure encryption

modules/s3-ingestion/s3-ingestion-api_gateway/
Contains Terraform to:
Create API Gateway HTTP API
Connect Lambda integration
Create the /ingest route

modules/s3-ingestion/s3-ingestion-dynamodb-table

Enable deployment

This serves as an alternative to kinesis as regards cost optimization especially that kinesis is more suitable for
High-volume, real-time streaming from devices or services.

Kinesis is considered expensive for the following reasons
Data ingestion cost: Charged per GB ingested.

Optional data transformation via Lambda costs extra.

Retries + buffering may introduce overhead.

No fine-grained control of what triggers data writes = potential waste.

API Gateway + Lambda + S3 + DynamoDB
This is excellent for low/medium-volume, event-driven ingestion, especially for a community software under development.

Benefits
Feature API Gateway + Lambda + S3 Firehose
Cost Pay per request (cheap at low scale) Pay per GB ingested
Control Full control over trigger + write logic Abstracted
Simplicity Fewer moving parts, less over-provisioning Managed but rigid
Custom Logic Easy in Lambda Limited, optional Lambda transform
Scalability Sufficient for moderate scale Seamless at massive scale
Quick access to data, lightweight indexes
store status or processing flags per record
