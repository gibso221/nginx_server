locals {
  region = "eu-west-1"
  bucket_region = "eu-west-1"
  vpc_cidr = "10.0.0.0/16"
  subnet_ranges = cidrsubnets(local.vpc_cidr, 4, 4, 4)

  # include fargate-specific settings here
  min_capacity = 2
  max_capacity = 4
  scale_in_cooldown_seconds = 10
  scale_out_cooldown_seconds = 10
  cpu_target_percent = 70
  fargate_to_spot_ratio = "1:1"
}