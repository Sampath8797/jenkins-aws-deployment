#Security Group for alb
resource "aws_security_group" "alb_sg" {
  name        = "${var.app_name}-${var.env_name}-alb-sg"
  description = "Allow traffic from the internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.env_name}-alb-sg"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

#Security Group for ECS Fargate application
resource "aws_security_group" "app_sg" {
  name        = "${var.app_name}-${var.env_name}-app-sg"
  description = "Forwards traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ALB to access service"
    from_port       = var.app_service_port
    to_port         = var.app_service_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.env_name}-app-sg"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

#Security Group for PostgreSQL DB
resource "aws_security_group" "rds_sg" {
  name        = "${var.app_name}-${var.env_name}-rds-sg"
  description = "Security group for Database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow ECS access"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  ingress {
    description     = "Allow Bastion access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.bastion_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.env_name}-rds-sg"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}
