variable "resource_name_prefix" {
  type        = string
  description = "the prefix for resources in this repo"
}

variable "region" {
  type        = string
  description = "the region that resources are deployed to by default"
  default     = "eu-west-2"
}