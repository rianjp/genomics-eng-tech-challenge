resource "random_pet" "this" {
  length    = 3
  separator = "-"
}

resource "aws_s3_bucket" "source" {
  bucket        = "${var.resource_name_prefix}-src-bucket-${random_pet.this.id}"
  force_destroy = true
}

resource "aws_s3_bucket_notification" "source" {
  bucket      = aws_s3_bucket.source.id
  eventbridge = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source" {
  bucket = aws_s3_bucket.source.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "destination" {
  bucket        = "${var.resource_name_prefix}-dst-bucket-${random_pet.this.id}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "destination" {
  bucket = aws_s3_bucket.destination.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}