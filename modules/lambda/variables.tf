variable "resource_name_prefix" {
  type        = string
  description = "the prefix for resources in this repo"
}

variable "lambda_role_arn" {
  type        = string
  description = "the arn of the role to be used by lambda"
}

variable "kms_key_arn" {
  type        = string
  description = "the arn of the kms key used for encrypting the lambda env vars"
}

variable "cw_log_group_name" {
  type        = string
  description = "the name of the CW logs log group"
}

variable "eb_rule_arn" {
  type = string
  description = "the arn of the eventbridge rule used to invoke the lambda function"
}

variable "destination_bucket_name" {
  type = string
  description = "the name of the destination s3 bucket"
}