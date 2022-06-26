variable "nginx_version" {
  type    = string
  default = "nginx:latest"
}
variable "region" {
  type = string
}
variable "nginx_target_group_arn" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}
variable "alb_sg_id" {
  type = string
}
variable "min_capacity" {
  type = number
}
variable "max_capacity" {
  type = number
}
variable "scale_in_cooldown_seconds" {
  type = number
}
variable "scale_out_cooldown_seconds" {
  type = number
}
variable "cpu_target_percent" {
  type = number
}
variable "fargate_to_spot_ratio" {
  type = string
}