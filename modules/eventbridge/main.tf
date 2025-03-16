resource "aws_cloudwatch_event_rule" "this" {
  name        = "src-bucket-jpg"
  description = "JPEG image uploaded to source bucket"
  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = ["${var.source_bucket_name}"]
      }
      object = {
        key = [
            { suffix = { equals-ignore-case = ".jpg" } },
            { suffix = { equals-ignore-case = ".jpeg" } }
        ]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "this" {
  arn = var.lambda_function_arn
  rule = aws_cloudwatch_event_rule.this.id
}