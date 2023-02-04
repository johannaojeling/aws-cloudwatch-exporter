variable "region" {
  type        = string
  description = "AWS default region"
}

variable "bucket_name" {
  type        = string
  description = "Name of S3 bucket to export CloudWatch logs"
}

variable "function_name" {
  type        = string
  description = "Name of Lambda function to trigger CloudWatch export task"
}

variable "role_name" {
  type        = string
  description = "Name of Lambda executor role"
}
