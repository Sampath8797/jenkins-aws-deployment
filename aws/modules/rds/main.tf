resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.app_name}-${var.env_name}-db-subnet-group"
  subnet_ids = [var.db_subnet_1, var.db_subnet_2]

  tags = {
    Name        = "${var.app_name}-${var.env_name}-db-subnet-group"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage           = var.allocated_storage
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.db_instance_class
  name                        = replace("${var.app_name}_${var.env_name}_db", "-", "_")
  identifier                  = "${var.app_name}-${var.env_name}-db"
  username                    = var.master_user
  password                    = var.master_password
  vpc_security_group_ids      = [var.db_sg]
  db_subnet_group_name        = aws_db_subnet_group.db_subnet.id
  backup_retention_period     = var.backup_retention_period
  copy_tags_to_snapshot       = true
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = true
  multi_az                    = var.multi_az
  maintenance_window          = "Sat:21:00-Sat:23:00"
  backup_window               = "02:00-04:00"
  storage_encrypted           = true
  deletion_protection         = true
  ca_cert_identifier          = "rds-ca-2019"
  kms_key_id                  = var.kms_key_arn

  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]

  tags = {
    Name        = "${var.app_name}-${var.env_name}-db"
    Environment = "${var.app_name}-${var.env_name}"
    Application = var.app_name
    CostCenter  = var.cost_center
  }
}
