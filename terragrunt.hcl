locals {
  region_vars = read_terragrunt_config("region.hcl")
  region = local.region_vars.locals.region

  # Keep remote state in a single region for maintainability
  bucket_region = local.region_vars.locals.bucket_region
  environment_name = "testing"
  account_id = get_env("TESTING_ACCOUNT_ID","")
  bucket_key = "${local.region}/${local.environment_name}"
  bucket_name = "${local.environment_name}-${local.account_id}-tf-state"
}

remote_state {
  backend = "s3"
  config = {
    bucket = local.bucket_name
    key = local.bucket_key
    region = local.bucket_region
    encrypt = true
    dynamodb_table = "terraform-locking"
  }
}

# get all region-specific variables
inputs = merge(
local.region_vars.locals
)
