variable "environment_name" {
  type = string
}
variable "region" {
  type = string
}
variable "account_id" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "subnet_ranges" {
  type = list(string)
}
variable "min_capacity" {
  type    = number
  default = 2
}
variable "max_capacity" {
  type    = number
  default = 5
}
variable "scale_in_cooldown_seconds" {
  type    = number
  default = 10
}
variable "scale_out_cooldown_seconds" {
  type    = number
  default = 10
}
variable "cpu_target_percent" {
  type    = number
  default = 70
}
variable "fargate_to_spot_ratio" {
  type    = string
  default = "1:1"
}