output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}

output "function_name" {
  value = aws_lambda_function.cloudwatch_exporter.function_name
}
