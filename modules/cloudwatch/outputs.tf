output "log_group_name" {
  value       = aws_cloudwatch_log_group.this.name
  description = "the name of the CW log group"
}