resource "aws_iam_role" "this" {
  name               = "${var.resource_name_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role_trust.json
  path               = "/${var.resource_name_prefix}/"
}

data "aws_iam_policy_document" "lambda_role_trust" {
  statement {
    sid = "AllowLambdaAssumeRole"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "basic_exec" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.this.name
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid = "s3put"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${var.dest_bucket_arn}/*"]
  }
  statement {
    sid = "s3get"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["${var.src_bucket_arn}/*"]
  }
  statement {
    sid = "kms"
    effect = "Allow"
    actions = [ 
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*" 
      ]
    resources = [ var.kms_key_arn ]
  }
}

resource "aws_iam_policy" "lambda_task_perms" {
  name = "${var.resource_name_prefix}_lambda_policy"
  path = "/"
  description = "A policy containing the required permissions for the lambda to function"
  policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_perms" {
  role = aws_iam_role.this.name
  policy_arn = aws_iam_policy.lambda_task_perms.arn
}

resource "aws_iam_user" "rw_src" {
  name = "rw_src"
  path = "/"
}

data "aws_iam_policy_document" "rw_src" {
  statement {
    sid = "s3"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:List*"
    ]
    resources = [ var.src_bucket_arn, "${var.src_bucket_arn}/*" ]
  }
  statement {
    sid = "kms"
    effect = "Allow"
    actions = [ 
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*" 
      ]
    resources = [ var.kms_key_arn ]
  }
}

resource "aws_iam_user_policy" "rw_src" {
  name = "rw_src"
  user = aws_iam_user.rw_src.name
  policy = data.aws_iam_policy_document.rw_src.json
}

resource "aws_iam_user" "r_dst" {
  name = "r_dst"
  path = "/"
}

data "aws_iam_policy_document" "r_dst" {
  statement {
    sid = "s3"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:List*"
    ]
    resources = [ var.dest_bucket_arn, "${var.dest_bucket_arn}/*" ]
  }
  statement {
    sid = "kms"
    effect = "Allow"
    actions = [ 
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*" 
      ]
    resources = [ var.kms_key_arn ]
  }
}

resource "aws_iam_user_policy" "r_dst" {
  name = "r_dst"
  user = aws_iam_user.r_dst.name
  policy = data.aws_iam_policy_document.r_dst.json
}