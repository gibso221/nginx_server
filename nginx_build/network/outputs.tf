output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "nginx_target_group_arn" {
  value = aws_lb_target_group.nginx_target_group.arn
}
output "public_subnet_ids" {
  value = local.public_subnets
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}