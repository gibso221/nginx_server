locals {
  container_name = "nginx"
  container_port = 80
  host_port      = 80
  weights        = split(":", var.fargate_to_spot_ratio)
}

# Send logs to CloudWatch using logDriver for better monitoring
resource "aws_cloudwatch_log_group" "nginx_ecs_logs" {
  name              = "ecs-nginx-task-logs"
  retention_in_days = 14
}

resource "aws_ecs_task_definition" "nginx_task" {
  depends_on = [aws_cloudwatch_log_group.nginx_ecs_logs]

  family             = "nginx-task-definition"
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  execution_role_arn = aws_iam_role.ecs_role.arn

  container_definitions = jsonencode([
    {
      name  = local.container_name
      image = var.nginx_version
      portMappings = [
        {
          containerPort = local.container_port
          hostPort      = local.host_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.nginx_ecs_logs.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "nginx"
        }
      }
    }
  ])
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate_providers" {
  cluster_name       = aws_ecs_cluster.nginx_cluster.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = local.weights[0]
    capacity_provider = "FARGATE"
  }

  default_capacity_provider_strategy {
    weight            = local.weights[1]
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_cluster" "nginx_cluster" {
  name = "nginx-cluster"
}

resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = var.nginx_target_group_arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.alb_to_ecs.id]
    assign_public_ip = true
  }
}

resource "aws_security_group" "alb_to_ecs" {
  name        = "alb-to-ecs"
  description = "Allows HTTP ALB traffic from world to ECS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
