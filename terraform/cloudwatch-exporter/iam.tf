locals {
  permissions = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.role_name}-${terraform.workspace}"
  assume_role_policy = file("${path.module}/resources/policies/lambda-policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachments" {
  for_each = toset(local.permissions)

  role       = aws_iam_role.lambda_role.name
  policy_arn = each.value
}
