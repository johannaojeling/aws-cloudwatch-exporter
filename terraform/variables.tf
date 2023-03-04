variable "region" {
  type        = string
  description = "AWS default region"
}

variable "bucket" {
  type        = string
  description = "Name of S3 bucket to export CloudWatch logs to"
}

variable "log_group" {
  type        = string
  description = "Name of CloudWatch log group to export"
}

variable "function" {
  type        = string
  description = "Name of Lambda function to trigger CloudWatch export task"
}

variable "role" {
  type        = string
  description = "Name of Lambda executor role"
}

variable "event_rule" {
  type        = string
  description = "Name of EventBridge rule to trigger Lambda function"
}
