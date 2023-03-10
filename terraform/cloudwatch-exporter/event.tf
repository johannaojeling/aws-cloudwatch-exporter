resource "aws_cloudwatch_event_rule" "cloudwatch_exporter" {
  name                = "${var.event_rule}-${terraform.workspace}"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "cloudwatch_exporter" {
  rule = aws_cloudwatch_event_rule.cloudwatch_exporter.name
  arn  = aws_lambda_function.cloudwatch_exporter.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudwatch_exporter.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudwatch_exporter.arn
}
