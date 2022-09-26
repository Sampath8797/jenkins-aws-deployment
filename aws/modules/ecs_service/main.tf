resource "aws_ecs_task_definition" "ecs" {
  family                   = "${var.app_name}-${var.env_name}-ecs"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = var.task_execution_role_arn
  container_definitions    = <<DEFINITION
    [
      {
        "name":"${var.app_name}-${var.env_name}-ecs",
        "memory_reservation": "${var.soft_memory_reservation}",
        "image":"${var.app_ecr}:${var.tag}",
        "logConfiguration":{
            "logDriver":"awslogs",
            "options":{
              "awslogs-group":"${var.app_logs}",
              "awslogs-region":"${var.default_region}",
              "awslogs-stream-prefix":"ecs"
            }
        },
        "portMappings":[
            {
              "containerPort":${var.app_service_port},
              "hostPort":${var.app_service_port},
              "protocol":"tcp"
            }
        ],
        "essential":true,
        "secrets": [
          {
            "name": "CANONICAL_ID",
            "valueFrom": "${var.app_secret_manager_arn}:CANONICAL_ID::"
          },
          {
            "name": "SERVER_PORT",
            "valueFrom": "${var.app_secret_manager_arn}:SERVER_PORT::"
          },
          {
            "name": "DB_HOST",
            "valueFrom": "${var.app_secret_manager_arn}:DB_HOST::"
          },
          {
            "name": "DB_USERNAME",
            "valueFrom": "${var.app_secret_manager_arn}:DB_USERNAME::"
          },
          {
            "name": "DB_PASSWORD",
            "valueFrom": "${var.app_secret_manager_arn}:DB_PASSWORD::"
          },
          {
            "name": "DB_NAME",
            "valueFrom": "${var.app_secret_manager_arn}:DB_NAME::"
          },
          {
            "name": "BB_LMS_URL",
            "valueFrom": "${var.app_secret_manager_arn}:BB_LMS_URL::"
          },
          {
            "name": "BB_OIDC_END_POINT",
            "valueFrom": "${var.app_secret_manager_arn}:BB_OIDC_END_POINT::"
          },
          {
            "name": "BB_AUTH_CONFIG_KEY",
            "valueFrom": "${var.app_secret_manager_arn}:BB_AUTH_CONFIG_KEY::"
          },
           {
            "name": "BB_OAUTH2_AUTH_URL",
            "valueFrom": "${var.app_secret_manager_arn}:BB_OAUTH2_AUTH_URL::"
          },
          {
            "name": "BB_OAUTH2_TOKEN_URL",
            "valueFrom": "${var.app_secret_manager_arn}:BB_OAUTH2_TOKEN_URL::"
          },
          {
            "name": "LTI_CLIENT_ID",
            "valueFrom": "${var.app_secret_manager_arn}:LTI_CLIENT_ID::"
          },
          {
            "name": "API_CLIENT_ID",
            "valueFrom": "${var.app_secret_manager_arn}:API_CLIENT_ID::"
          },
          {
            "name": "API_SECRET_KEY",
            "valueFrom": "${var.app_secret_manager_arn}:API_SECRET_KEY::"
          },
          {
            "name": "FOUO_CLIENT_URL",
            "valueFrom": "${var.app_secret_manager_arn}:FOUO_CLIENT_URL::"
          },
          {
            "name": "ENCRYPT_ALGORITHM",
            "valueFrom": "${var.app_secret_manager_arn}:ENCRYPT_ALGORITHM::"
          },
          {
            "name": "ENCRYPT_INIT_VECTOR",
            "valueFrom": "${var.app_secret_manager_arn}:ENCRYPT_INIT_VECTOR::"
          },
          {
            "name": "ENCRYPT_SECURITY_KEY",
            "valueFrom": "${var.app_secret_manager_arn}:ENCRYPT_SECURITY_KEY::"
          },
          {
            "name": "JWT_TOKEN_KEY",
            "valueFrom": "${var.app_secret_manager_arn}:JWT_TOKEN_KEY::"
          }
        ]
      }
  ]
  DEFINITION
}

resource "aws_ecs_service" "service" {
  name            = "${var.app_name}-${var.env_name}-service"
  depends_on      = [var.ecs_policy]
  cluster         = var.app_cluster
  launch_type     = var.launch_type
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.ecs.arn

  load_balancer {
    target_group_arn = var.app_backend_tg_id
    container_name   = "${var.app_name}-${var.env_name}-ecs"
    container_port   = var.app_service_port
  }

  network_configuration {
    security_groups = [var.app_sg]
    subnets         = [var.private_subnet_1, var.private_subnet_2]
  }

  tags = {
    "Name"        = "${var.app_name}-${var.env_name}-service"
    "Environment" = "${var.app_name}-${var.env_name}"
    "Application" = var.app_name
    "CostCenter"  = var.cost_center
  }
}
