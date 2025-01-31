resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-${var.env}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "ecs_nginx_logs" {
  name              = "/ecs/nginx"
  retention_in_days = 3
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  network_mode             = "awsvpc" 
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  cpu                      = "512"  
  memory                   = "1024" 

  container_definitions = jsonencode([
    {
      name      = "nginx-container"
      image     = "${var.image_url}:latest"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_nginx_logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "nginx_service" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2
  force_new_deployment = true

  network_configuration {
    subnets         = var.subnets_id
    security_groups = var.security_group_id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  deployment_controller {
    type = "ECS"
  }
}