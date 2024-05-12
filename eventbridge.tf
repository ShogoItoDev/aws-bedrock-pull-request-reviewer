# Create an EventBridge rule
resource "aws_cloudwatch_event_rule" "codecommit_pull_request_rule" {
  name          = "codecommit-pull-request-rule-${var.system_identifier}"
  description   = "Rule to trigger Lambda on CodeCommit pull request events"
  event_pattern = <<EOF
{
  "source": ["aws.codecommit"],
  "detail-type": ["CodeCommit Pull Request State Change"],
  "detail": {
    "event": ["pullRequestCreated", "pullRequestUpdated"],
    "repositoryNames": ["${aws_codecommit_repository.main.repository_name}"]
  }
}
EOF
}

# Create an EventBridge target to invoke the Lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.codecommit_pull_request_rule.name
  target_id = "lambda-target"
  arn       = aws_lambda_function.codecommit_review.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.codecommit_review.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.codecommit_pull_request_rule.arn
}
