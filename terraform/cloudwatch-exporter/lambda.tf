data "archive_file" "go_binary" {
  type        = "zip"
  source_file = "${path.module}/resources/artifacts/main"
  output_path = "${path.module}/resources/artifacts/main.zip"
}

resource "aws_lambda_function" "cloudwatch_exporter" {
  function_name = "${var.function_name}-${terraform.workspace}"

  role             = aws_iam_role.lambda_role.arn
  filename         = data.archive_file.go_binary.output_path
  source_code_hash = filebase64sha256(data.archive_file.go_binary.output_path)
  handler          = "main"
  runtime          = "go1.x"

  environment {
    variables = {
      "BUCKET" = aws_s3_bucket.bucket.id
    }
  }
}
