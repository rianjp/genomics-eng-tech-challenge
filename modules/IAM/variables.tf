variable "resource_name_prefix" {
  type        = string
  description = "the prefix for resources in this repo"
}

variable "dest_bucket_arn" {
  type = string
  description = "the arn of the destination bucket"
}

variable "src_bucket_arn" {
  type = string
  description = "the arn of the source bucket"
}

variable "kms_key_arn" {
  type = string
  description = "the arn of the kms key"
}