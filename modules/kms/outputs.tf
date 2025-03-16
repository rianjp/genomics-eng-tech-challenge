output "kms_key_arn" {
  value       = aws_kms_key.this.arn
  description = "the arn of the kms key for this project"
}

output "kms_key_policy_id" {
  value       = aws_kms_key_policy.this.id
  description = "the id for the kms key policy used to prevent race conditions"
}