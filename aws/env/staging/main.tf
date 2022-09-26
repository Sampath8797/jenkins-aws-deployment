terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.15"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "fouo-nonprod"
}

# S3 bUCKET FOR STORING THE TERRAFORM STATE
resource "aws_s3_bucket" "terraform_state" {
  bucket = "fouo-jenkins-test-tfstate"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#DINAMODB TABLE FOR LOCKING THR TERRAFORM
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "fouo-jenkins-test-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket         = "fouo-jenkins-test-tfstate"
    key            = "fouo-infra-setup/aws/env/staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "fouo-jenkins-test-tfstate-locks"
    encrypt        = false
  }
}

# ########################Modules########################
/* module "vpc" {
  source      = "../../modules/vpc"
  app_name    = var.app_name
  env_name    = var.env_name
  cost_center = var.cost_center
  vpc_cidr    = var.vpc_cidr
  az_count    = var.az_count
}

module "security" {
  source           = "../../modules/security"
  app_name         = var.app_name
  env_name         = var.env_name
  cost_center      = var.cost_center
  vpc_id           = module.vpc.vpc_id
  app_service_port = var.app_service_port
  db_port          = var.db_port
  bastion_sg       = var.bastion_sg
}

module "acm" {
  source               = "../../modules/acm"
  app_name             = var.app_name
  env_name             = var.env_name
  cost_center          = var.cost_center
  assume_role          = var.assume_role
  main_domain_name     = var.main_domain_name
  wildcard_domain_name = var.wildcard_domain_name
}

module "alb" {
  source           = "../../modules/alb"
  app_name         = var.app_name
  env_name         = var.env_name
  cost_center      = var.cost_center
  assume_role      = var.assume_role
  main_domain_name = var.main_domain_name
  public_subnet_1  = module.vpc.public_subnet_1
  public_subnet_2  = module.vpc.public_subnet_2
  alb_sg           = module.security.alb_sg
  vpc_id           = module.vpc.vpc_id
  acm_certificate  = module.acm.wildcard_acm_certificate
  alb_domain_name  = var.alb_domain_name
}

module "ecr" {
  source      = "../../modules/ecr"
  app_name    = var.app_name
  env_name    = var.env_name
  cost_center = var.cost_center
}

module "secret_manager" {
  source      = "../../modules/secret_manager"
  app_name    = var.app_name
  env_name    = var.env_name
  cost_center = var.cost_center
}

module "iam" {
  source             = "../../modules/iam"
  app_name           = var.app_name
  env_name           = var.env_name
  cost_center        = var.cost_center
  secret_manager_arn = module.secret_manager.secret_manager_arn.arn
}

module "kms" {
  source             = "../../modules/kms"
  app_name           = var.app_name
  env_name           = var.env_name
  cost_center        = var.cost_center
  principal_accounts = var.principal_accounts
  accountID          = var.accountID
  IAMUser            = var.IAMUser
}

module "rds" {
  source                  = "../../modules/rds"
  app_name                = var.app_name
  env_name                = var.env_name
  cost_center             = var.cost_center
  db_subnet_1             = module.vpc.db_subnet_1
  db_subnet_2             = module.vpc.db_subnet_2
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  db_instance_class       = var.db_instance_class
  master_user             = var.master_user
  master_password         = var.master_password
  db_sg                   = module.security.rds_sg
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  kms_key_arn             = module.kms.rds_kms_key_arn
}

module "cloudwatch" {
  source      = "../../modules/cloudwatch"
  app_name    = var.app_name
  env_name    = var.env_name
  cost_center = var.cost_center
}

module "s3" {
  source      = "../../modules/s3"
  app_name    = var.app_name
  env_name    = var.env_name
  cost_center = var.cost_center
}

module "cloudfront" {
  source               = "../../modules/cloudfront"
  app_name             = var.app_name
  env_name             = var.env_name
  cost_center          = var.cost_center
  assume_role          = var.assume_role
  main_domain_name     = var.main_domain_name
  s3_static            = var.s3_static
  frontend_domain_name = var.frontend_domain_name
  alb_domain_name      = var.alb_domain_name
  nv_cf_certificate    = module.acm.wildcard_acm_certificate
  cf_logs_s3_bucket    = module.s3.cf_logs_s3_bucket.id
}

module "ecs_cluster" {
  source      = "../../modules/ecs_cluster"
  app_name    = var.app_name
  env_name    = var.env_name
  cost_center = var.cost_center
}

module "ecs_service" {
  source                  = "../../modules/ecs_service"
  app_name                = var.app_name
  env_name                = var.env_name
  cost_center             = var.cost_center
  fargate_cpu             = var.fargate_cpu
  fargate_memory          = var.fargate_memory
  task_execution_role_arn = module.iam.task_execution_role.arn
  soft_memory_reservation = var.soft_memory_reservation
  app_ecr                 = module.ecr.app_ecr.repository_url
  tag                     = var.tag
  app_logs                = module.cloudwatch.app_logs
  default_region          = var.default_region
  app_service_port        = var.app_service_port
  app_secret_manager_arn  = module.secret_manager.secret_manager_arn.arn
  ecs_policy              = module.iam.ecs_policy
  app_cluster             = module.ecs_cluster.ecs_cluster
  launch_type             = var.launch_type
  desired_count           = var.desired_count
  app_backend_tg_id       = module.alb.app_backend_tg_id.arn
  app_sg                  = module.security.app_sg
  private_subnet_1        = module.vpc.private_subnet_1
  private_subnet_2        = module.vpc.private_subnet_2
} */