data "archive_file" "this" {
  source_dir  = "${path.root}/resources/scripts/exif_remover"
  output_path = "${path.root}/resources/exif_remover.zip"
  excludes    = ["tests"]
  type        = "zip"
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.this.output_path
  function_name    = "${var.resource_name_prefix}-lambda"
  role             = var.lambda_role_arn
  handler          = "lambda_handler.lambda_handler"
  source_code_hash = data.archive_file.this.output_base64sha256
  runtime          = "python3.12"
  kms_key_arn      = var.kms_key_arn
  timeout          = 30
  environment {
    variables = {
      DEST_BUCKET = var.destination_bucket_name
    }
  }
  logging_config {
    log_format = "Text"
    log_group  = var.cw_log_group_name
  }
  architectures = ["x86_64"]
  ephemeral_storage {
    size = 512
  }
  layers = [aws_lambda_layer_version.this.arn]
}

data "archive_file" "layer" {
  source_dir  = "${path.root}/resources/layer"
  output_path = "${path.root}/resources/layer.zip"
  type        = "zip"
}

resource "aws_lambda_layer_version" "this" {
  filename                 = data.archive_file.layer.output_path
  layer_name               = "${var.resource_name_prefix}-layer"
  compatible_runtimes      = ["python3.12"]
  compatible_architectures = ["x86_64"]
}

resource "aws_lambda_permission" "this" {
  statement_id = "AllowFromEventBridge"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal = "events.amazonaws.com"
  source_arn = var.eb_rule_arn
}