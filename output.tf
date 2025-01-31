output "alb_hostname" {
  value       = module.alb.lb_hostname
  description = "hostname of alb"
}

output "image_url" {
  value = module.ecr.image_url
}