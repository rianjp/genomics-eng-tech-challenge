output "source_bucket_arn" {
  value       = aws_s3_bucket.source.arn
  description = "the arn of the soruce bucket"
}

output "destination_bucket_arn" {
  value       = aws_s3_bucket.destination.arn
  description = "the arn of the destination bucket"
}

output "source_bucket_name" {
  value       = aws_s3_bucket.source.bucket
  description = "the name of the source s3 bucket"
}

output "destination_bucket_name" {
  value = aws_s3_bucket.destination.bucket
  description = "the name of the destination s3 bucket"
}