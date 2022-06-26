locals {
  region = "ap-southeast-2"
  bucket_region = "eu-west-1"
  vpc_cidr = "10.0.0.0/16"
  subnet_ranges = cidrsubnets(local.vpc_cidr, 4, 4, 4)
}
