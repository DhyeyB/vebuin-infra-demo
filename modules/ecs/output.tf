output "service_name" {
    value = aws_ecs_service.nginx_service.name
}

output "cluster_name" {
    value = aws_ecs_cluster.ecs_cluster.name
}