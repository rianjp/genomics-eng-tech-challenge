data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  description              = "The kms key used for ${var.resource_name_prefix} related encryption tasks"
  enable_key_rotation      = true
  rotation_period_in_days  = 90
  deletion_window_in_days  = 7
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
}

resource "random_string" "this" {
  length  = 5
  lower   = true
  upper   = false
  special = false
  numeric = false
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.resource_name_prefix}-${random_string.this.result}"
  target_key_id = aws_kms_key.this.id
}

data "aws_iam_policy_document" "this" {
  statement {
    sid = "DelegateIAM"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    effect = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid = "CWLogs"
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.resource_name_prefix}*"]
    }
  }
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = data.aws_iam_policy_document.this.json
}