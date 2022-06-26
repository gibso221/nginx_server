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