variable "resource_name_prefix" {
  type        = string
  description = "the prefix for resources in this repo"
}

variable "kms_key_arn" {
  type        = string
  description = "the arn of the kms key used for encrypting the lambda env vars"
}

variable "kms_key_policy_id" {
  type        = string
  description = "id of the kms key policy, used for dependency control"
}