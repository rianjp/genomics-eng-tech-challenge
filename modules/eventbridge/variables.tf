variable "source_bucket_name" {
  type        = string
  description = "the name of the source bucket"
}

variable "lambda_function_arn" {
  type = string
  description = "the arn of the lambda funcition"
}