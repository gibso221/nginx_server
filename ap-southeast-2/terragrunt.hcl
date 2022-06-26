
# inherit the root terragrunt.hcl variables and remote state
include "root" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${path_relative_from_include()}//nginx_build"
}

inputs = {
  account_id        = include.root.locals.account_id
  environment_name  = include.root.locals.environment_name
}
