resource "aws_cloudwatch_log_group" "this" {
  depends_on        = [var.kms_key_policy_id]
  name              = "/aws/lambda/${var.resource_name_prefix}-lambda"
  retention_in_days = 14
  kms_key_id        = var.kms_key_arn
}