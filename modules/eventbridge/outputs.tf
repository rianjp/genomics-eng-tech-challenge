output "rule_arn" {
  value = aws_cloudwatch_event_rule.this.arn
  description = "the arn of the cloudwatch event rule"
}