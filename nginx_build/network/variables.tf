variable "vpc_cidr" {
  type = string
}
variable "subnet_ranges" {
  type = list(string)
}
variable "environment_name" {
  type = string
}
variable "region" {
  type = string
}