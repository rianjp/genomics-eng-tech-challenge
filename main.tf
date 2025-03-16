module "s3" {
  source               = "./modules/s3"
  resource_name_prefix = var.resource_name_prefix
}

module "iam" {
  source               = "./modules/IAM"
  resource_name_prefix = var.resource_name_prefix
  dest_bucket_arn = module.s3.destination_bucket_arn
  src_bucket_arn = module.s3.source_bucket_arn
  kms_key_arn = module.kms.kms_key_arn
}

module "cloudwatch" {
  source               = "./modules/cloudwatch"
  kms_key_arn          = module.kms.kms_key_arn
  resource_name_prefix = var.resource_name_prefix
  kms_key_policy_id    = module.kms.kms_key_policy_id
}

module "kms" {
  source               = "./modules/kms"
  resource_name_prefix = var.resource_name_prefix
  region               = var.region
}

module "lambda" {
  source               = "./modules/lambda"
  resource_name_prefix = var.resource_name_prefix
  lambda_role_arn      = module.iam.lambda_role_arn
  kms_key_arn          = module.kms.kms_key_arn
  cw_log_group_name    = module.cloudwatch.log_group_name
  eb_rule_arn = module.eventbridge.rule_arn
  destination_bucket_name = module.s3.destination_bucket_name
}

module "eventbridge" {
  source             = "./modules/eventbridge"
  source_bucket_name = module.s3.source_bucket_name
  lambda_function_arn = module.lambda.lambda_function_arn
}