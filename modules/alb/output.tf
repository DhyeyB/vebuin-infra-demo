output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "lb_hostname" {
  value = aws_lb.alb.dns_name
}